resource "tls_private_key" "github_ssh_key" {
  algorithm = "ED25519"

  provisioner "local-exec" {
    command = "./github-create-ssh-key.sh"
    environment = {
      SSH_PUBLIC_KEY = trimspace(self.public_key_openssh)
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./github-delete-ssh-key.sh"
    environment = {
      SSH_PUBLIC_KEY = trimspace(self.public_key_openssh)
    }
  }
}

resource "aws_s3_object" "github_ssh_key" {
  bucket                 = aws_cloudformation_stack.buildkite.outputs.ManagedSecretsBucket
  key                    = "private_ssh_key"
  server_side_encryption = "aws:kms"
  content                = tls_private_key.github_ssh_key.private_key_openssh
}
