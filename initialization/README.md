# Infrastructures

## Initialization

### Overview

This document describes the process of starting the infrastructure setup for the project.

### Objectives

- **Create IAM Users and Access Keys for Managing AWS Root Account Using Terraform**: Use Terraform to create IAM users and access keys to automate and structure AWS root account operations.

- **Establish AWS Organization**: Configure an AWS Organization via Terraform to set up the foundational structure.



### Preparation Steps

1. Purchase the `idelior.com` domain from GoDaddy.
2. Sign up for Google Workspace using the `idelior.com` domain.
3. Create the `root@idelior.com` Google account.
4. Sign up for AWS using `root@idelior.com`.
5. Create a temporary user in IAM.
6. Attach the `AdministratorAccess` policy to the temporary user.
7. Generate an access key for the temporary user.

### Run `init.sh`

After completing all the preparation steps, execute `init.sh` to configure AWS environment using Terraform.

1. **Ensure Execution Permissions**: Before running the script, make sure it has the appropriate execution permissions:
    ```bash
    chmod +x init.sh
    ```

2. **Execute the Script**: Run the script to apply the Terraform configurations:
    ```bash
    ./init.sh
    ```

3. **Verify Completion**: Check the output of the script to ensure that all configurations have been applied successfully and verify that the AWS environment is set up as expected.

Notes

    Ensure that all prerequisite tools (aws CLI and jq) are installed and properly configured before running the script.
    Double-check that the temporary IAM user and access keys are valid and have the necessary permissions.
