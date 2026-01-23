# The IAM role Terraform workloads assume for AWS operations

resource "vault_aws_secret_backend_role" "terraform" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "Terraform"
  credential_type = "assumed_role"
  role_arns = [
    aws_iam_role.vault_assumed_role.arn
  ]
}

resource "aws_iam_role" "vault_assumed_role" {
  name               = "VaultAssumedRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy_attachment" "vault_assumed_role" {
  role       = aws_iam_role.vault_assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  # TODO: Write a more restrictive policy to limit the access of assumed roles
}

