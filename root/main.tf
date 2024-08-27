data "aws_iam_user" "root" {
  user_name = "root"
}

data "aws_organizations_organization" "default" {}

resource "aws_organizations_organizational_unit" "this" {
  parent_id = aws_organizations_organization.default.id

  for_each = 
  name      = "example"
  
}
