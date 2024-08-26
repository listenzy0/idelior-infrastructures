# Create an IAM user named 'root' for Terraform usage
resource "aws_iam_user" "root" {
  path = "/"
  name = "root"
  tags = { purpose = "terraform" }
}

# Retrieve details of the 'AdministratorAccess' IAM policy
data "aws_iam_policy" "administrator_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Attach the 'AdministratorAccess' policy to the 'root' IAM user
resource "aws_iam_user_policy_attachment" "root" {
  user       = aws_iam_user.root.name
  policy_arn = data.aws_iam_policy.administrator_access.arn
}

# Generate an access key for the 'root' IAM user for CLI authentication
resource "aws_iam_access_key" "root" {
  user = aws_iam_user.root.name
}

# Create an Organizations organization
resource "aws_organizations_organization" "default" {
  feature_set = "ALL"
}
