#!/bin/bash

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null ; then
  echo -e "\033[1;31mERROR\033[0m: AWS CLI is not installed. Please install AWS CLI."
  exit 1
fi

# Check if 'jq' is installed
if ! command -v jq &> /dev/null ; then
  echo -e "\033[1;31mERROR\033[0m: 'jq' is not installed. Please install 'jq'."
  exit 1
fi

# Save the current AWS CLI credentials for rollback
ORIG_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
ORIG_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

# Prompt for the temporary AWS IAM user's name
read -p "Enter the temporary AWS IAM user's name: " TEMP_USER_NAME
if [ -z "$TEMP_USER_NAME" ] ; then
  echo -e "\033[1;31mERROR\033[0m: The temporary AWS IAM user's name must not be empty."
  exit 1
fi

# Prompt for the temporary AWS IAM user's access key ID
read -p "Enter the temporary AWS IAM user's access key ID: " TEMP_ACCESS_KEY_ID
if [ -z "$TEMP_ACCESS_KEY_ID" ] ; then
  echo -e "\033[1;31mERROR\033[0m: The access key ID must not be empty."
  exit 1
fi

# Prompt for the temporary AWS IAM user's secret access key
read -sp "Enter the temporary AWS IAM user's secret access key: " TEMP_SECRET_ACCESS_KEY
echo
if [ -z "$TEMP_SECRET_ACCESS_KEY" ] ; then
  echo -e "\033[1;31mERROR\033[0m: The secret access key must not be empty."
  exit 1
fi

# Configure AWS CLI with the temporary AWS IAM user's access key ID
if ! aws configure set aws_access_key_id "$TEMP_ACCESS_KEY_ID" ; then
  echo -e "\033[1;31mERROR\033[0m: Failed to set the access key ID."
  exit 1
fi

# Export the temporary AWS IAM user's access key ID for use in the current session
export AWS_ACCESS_KEY_ID="$TEMP_ACCESS_KEY_ID"


# Configure AWS CLI with the temporary AWS IAM user's secret access key
if ! aws configure set aws_secret_access_key "$TEMP_SECRET_ACCESS_KEY" ; then
  echo -e "\033[1;31mERROR\033[0m: Failed to set the secret access key."
  exit 1
fi

# Export the temporary AWS IAM user's secret access key for use in the current session
export AWS_SECRET_ACCESS_KEY="$TEMP_SECRET_ACCESS_KEY"

# Check if the temporary AWS IAM user exists
GET_USER_RESULT=$(aws iam get-user --user-name "$TEMP_USER_NAME" --no-cli-pager 2>&1)
if [ $? -ne 0 ] ; then
  if echo "$GET_USER_RESULT" | grep -q "NoSuchEntity" ; then
    echo -e "\033[1;31mERROR\033[0m: The user '$TEMP_USER_NAME' does not exist."
    exit 1
  elif echo "$GET_USER_RESULT" | grep -q "InvalidClientTokenId\|SignatureDoesNotMatch\|InvalidAccessKeyId" ; then
    echo -e "\033[1;31mERROR\033[0m: The provided AWS credentials are invalid. Please check the access key ID and secret access key."
    exit 1
  elif echo "$GET_USER_RESULT" | grep -q "AccessDenied" ; then
    echo -e "\033[1;31mERROR\033[0m: The user '$TEMP_USER_NAME' does not have the necessary permissions."
    exit 1
  else
    echo -e "\033[1;31mERROR\033[0m: An unknown error occurred."
    exit 1
  fi
fi

# Verify that the temporary AWS IAM user has the 'AdministratorAccess' IAM policy attached
if ! aws iam list-attached-user-policies --user-name "$TEMP_USER_NAME" | grep -q "AdministratorAccess" ; then
  echo -e "\033[1;31mERROR\033[0m: The user '$TEMP_USER_NAME' does not have the 'AdministratorAccess' IAM policy attached."
  exit 1
fi

# Verify the temporary AWS IAM user's access key ID
if ! aws iam list-access-keys --user-name "$TEMP_USER_NAME" | grep -q "$TEMP_ACCESS_KEY_ID" ; then
  echo -e "\033[1;31mERROR\033[0m: The access key ID '$TEMP_ACCESS_KEY_ID' does not belong to the user '$TEMP_USER_NAME'."
  exit 1
fi

# Initialize Terraform
if ! terraform init ; then
  echo -e "\033[1;31mERROR\033[0m: Terraform initialization failed."
  exit 1
fi

# Apply Terraform
if ! terraform apply -auto-approve ; then
  echo -e "\033[1;31mERROR\033[0m: Terraform apply failed."
  exit 1
fi

# Extract access key ID and secret access key from terraform.tfstate
ACCESS_KEY_ID=$(jq -r '.resources[] | select(.type == "aws_iam_access_key") | .instances[] | .attributes.id' terraform.tfstate)
SECRET_ACCESS_KEY=$(jq -r '.resources[] | select(.type == "aws_iam_access_key") | .instances[] | .attributes.secret' terraform.tfstate)

# Overwrite the existing Terraform AWS provider configuration with new access credentials
cat << EOF > provider.tf
provider "aws" {
  region     = "ap-northeast-2"
  access_key = "$ACCESS_KEY_ID"
  secret_key = "$SECRET_ACCESS_KEY"
}
EOF

# Disable the temporary AWS IAM user's access key ID
if ! aws iam update-access-key --user-name "$TEMP_USER_NAME" --access-key-id "$TEMP_ACCESS_KEY_ID" --status Inactive ; then
  echo -e "\033[1;31mERROR\033[0m: Failed to disable the temporary AWS IAM user's access key."
  exit 1
fi

# Delete the temporary AWS IAM user's access key ID
if ! aws iam delete-access-key --user-name "$TEMP_USER_NAME" --access-key-id "$TEMP_ACCESS_KEY_ID" ; then
  echo -e "\033[1;31mERROR\033[0m: Failed to delete the temporary AWS IAM user's access key."
  exit 1
fi

# Detach the 'AdministratorAccess' IAM policy from the temporary AWS IAM user
if ! aws iam detach-user-policy --user-name "$TEMP_USER_NAME" --policy-arn "arn:aws:iam::aws:policy/AdministratorAccess" ; then
  echo -e "\033[1;31mERROR\033[0m: Failed to detach the 'AdministratorAccess' IAM policy from the temporary AWS IAM user."
  exit 1
fi

# Delete the temporary AWS IAM user
if ! aws iam delete-user --user-name "$TEMP_USER_NAME" ; then
  echo -e "\033[1;31mERROR\033[0m: Failed to delete the temporary AWS IAM user."
  exit 1
fi

# Rollback to the original AWS credentials
aws configure set aws_access_key_id "$ORIG_ACCESS_KEY_ID"
export AWS_ACCESS_KEY_ID=$ORIG_ACCESS_KEY_ID
aws configure set aws_secret_access_key "$ORIG_SECRET_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY=$ORIG_SECRET_ACCESS_KEY
