resource "aws_iam_role" "k8s_ec2_role" {
  name = "k8s-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "k8s-ec2-role"
  }
}

resource "aws_iam_policy" "k8s_ssm_policy" {
  name        = "k8s-ssm-policy"
  description = "Allow Kubernetes nodes to use AWS Systems Manager Parameter Store"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "ssm:PutParameter",
          "ssm:DeleteParameter"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "k8s_ssm_attach" {
  role       = aws_iam_role.k8s_ec2_role.name
  policy_arn = aws_iam_policy.k8s_ssm_policy.arn
}

resource "aws_iam_instance_profile" "k8s_instance_profile" {
  name = "k8s-instance-profile"
  role = aws_iam_role.k8s_ec2_role.name
}

# ============================================================
# AWS Secrets Manager Policy
# ============================================================

resource "aws_iam_policy" "k8s_secretsmanager_policy" {
  name        = "k8s-secretsmanager-policy"
  description = "Allow Kubernetes nodes to read AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

	Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:CreateSecret",
          "secretsmanager:PutSecretValue"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "k8s_secretsmanager_attach" {
  role       = aws_iam_role.k8s_ec2_role.name
  policy_arn = aws_iam_policy.k8s_secretsmanager_policy.arn
}

