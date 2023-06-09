# An example of an account-wide shared secret.

# Secret value can be provided to TF Variable via Github Actions Secrets,
# or manually entered if deploying from local (not recommended).
# Marking the variables as sensitive means they will not be visible in the state.

# variable "example_username" {
#   type = string
#   sensitive = true
# }

# variable "example_password" {
#   type = string
#   sensitive = true
# }

# resource "aws_secretsmanager_secret" "example" {
#   name             = "example-credential"
#   description      = "example credentials"
#   kms_key_id       = data.aws_kms_key.basic.arn
# }

# resource "aws_secretsmanager_secret_version" "example" {
#   secret_id     = aws_secretsmanager_secret.example.id
#   secret_string = <<EOF
#    {
#     "username": "${var.example_username}",
#     "password": "${var.example_password}"
#    }
# EOF
# }