resource "aws_iam_role" "task" {
  name = "${var.project}-${var.environment}-task-role"
}

resource "aws_iam_policy" "task" {
  name        = "${var.project}-${var.environment}-task-policy"
  description = "Policy for ${var.project} ecs instances in the ${var.environment} environment."
  policy = var.task_iam_policy != "" ? var.task_iam_policy : jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "EnableCreationAndManagementOfCloudwatchLogEvents",
          "Effect" : "Allow",
          "Action" : [
            "logs:GetLogEvents",
            "logs:PutLogEvents"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "EnableCreationAndManagementOfCloudwatchLogGroupsAndStreams",
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "logs:PutRetentionPolicy",
            "logs:CreateLogGroup"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "ReadOnlyAccessForAllCMKsInAccount",
          "Effect" : "Allow",
          "Action" : [
            "kms:GetPublicKey",
            "kms:GetKeyRotationStatus",
            "kms:GetKeyPolicy",
            "kms:DescribeKey",
            "kms:ListKeyPolicies",
            "kms:ListResourceTags",
            "kms:Decrypt"
          ],
          "Resource" : "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
        },
        {
          "Sid" : "ReadOnlyAccessForOperationsWithNoCMK",
          "Effect" : "Allow",
          "Action" : [
            "kms:ListKeys",
            "kms:ListAliases",
            "iam:ListRoles",
            "iam:ListUsers"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "ReadOnlyAccessForAllSecrets",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "AllowSNSPublish",
          "Effect" : "Allow",
          "Action" : [
            "sns:GetTopicAttributes",
            "sns:Subscribe",
            "sns:Unsubscribe",
            "sns:Publish"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "EnableSSMExec",
          "Effect" : "Allow",
          "Action" : [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "task" {
  role       = aws_iam_role.task.name
  policy_arn = aws_iam_policy.task.arn
}

resource "aws_iam_role" "execution" {
  name = "${var.project}-${var.environment}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.execution_trust.json
}

resource "aws_iam_policy" "execution" {
  name        = "${var.project}-${var.environment}-execution-policy"
  description = "Execution Policy for ${var.project} ecs service in the ${var.environment} environment."
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "BasicRequirementsForExecution",
          "Effect": "Allow",
          "Action": [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource": "*"
        },
        {
          "Sid" : "ReadOnlyAccessForAllCMKsInAccount",
          "Effect" : "Allow",
          "Action" : [
            "kms:GetPublicKey",
            "kms:GetKeyRotationStatus",
            "kms:GetKeyPolicy",
            "kms:DescribeKey",
            "kms:ListKeys",
            "kms:ListAliases",
            "kms:ListKeyPolicies",
            "kms:ListResourceTags",
            "kms:Decrypt"
          ],
          "Resource" : "${data.aws_kms_key.basic.arn}"
        },
        {
          "Sid" : "ReadOnlyAccessForAllSecrets",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.name
  policy_arn = aws_iam_policy.execution.arn
}

data "aws_iam_policy_document" "execution_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}