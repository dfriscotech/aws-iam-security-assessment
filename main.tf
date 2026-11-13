
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

# ==========================================
# IAM ROLE
# ==========================================

# This role is intended for an EC2 application
# that only needs to read reports from S3.

resource "aws_iam_role" "app_role" {
  name = "friscosec-app-role"

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
}

# ==========================================
# INTENTIONALLY INSECURE IAM POLICY
# ==========================================

# LAB PURPOSE:
# Identify excessive permissions and
# potential privilege escalation risks.
#
# Do not deploy this configuration.

resource "aws_iam_role_policy" "app_policy" {
  name = "friscosec-app-policy"

  role = aws_iam_role.app_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid      = "ExcessiveS3Access"
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "*"
      },
      {
        Sid      = "UnrestrictedPassRole"
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "*"
      }
    ]
  })
}

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

# Intentionally insecure IAM configuration
# Security assessment only — DO NOT APPLY

resource "aws_iam_role" "app_role" {
  name = "friscosec-app-role"

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
}

resource "aws_iam_role_policy" "app_policy" {
  name = "friscosec-app-policy"
  role = aws_iam_role.app_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "*"
      }
    ]
  })
}
