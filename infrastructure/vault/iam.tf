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

resource "aws_iam_user" "vault" {
  name = "Vault"
}

resource "aws_iam_user_policy_attachment" "vault" {
  user       = aws_iam_user.vault.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  # TODO: Write a policy that only allows Vault to assume role
}

resource "aws_iam_access_key" "vault" {
  user = aws_iam_user.vault.name
}

