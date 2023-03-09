
resource "aws_iam_user" "backend" {
  name = "TerraformBackend"
}

resource "aws_iam_user_policy" "backend" {
  user   = aws_iam_user.backend.name
  policy = data.aws_iam_policy_document.backend.json
}

data "aws_iam_policy_document" "backend" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.state.arn]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.state.arn}/*"]
  }

  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [aws_dynamodb_table.state_lock.arn]
  }
}

resource "aws_iam_access_key" "backend" {
  user = aws_iam_user.backend.name
}

resource "pass_password" "backend_access_key" {
  name     = "aws/terraform-backend-access-key"
  password = aws_iam_access_key.backend.id
}

resource "pass_password" "backend_secret_key" {
  name     = "aws/terraform-backend-secret-key"
  password = aws_iam_access_key.backend.secret
}
