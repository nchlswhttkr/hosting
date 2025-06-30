resource "tls_private_key" "github_ssh_key" {
  algorithm = "ED25519"
}

resource "aws_s3_object" "github_ssh_key" {
  bucket                 = aws_cloudformation_stack.buildkite.outputs.ManagedSecretsBucket
  key                    = "private_ssh_key"
  server_side_encryption = "aws:kms"
  content                = tls_private_key.github_ssh_key.private_key_openssh
}

resource "github_user_ssh_key" "github_ssh_key" {
  title = "Buildkite"
  key   = tls_private_key.github_ssh_key.public_key_openssh
}
