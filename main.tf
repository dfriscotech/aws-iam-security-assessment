
# ==========================================
# AWS IAM SECURITY ASSESSMENT LAB
# FriscoSec
# ==========================================
#
# Security Objective:
# NIST CSF 2.0 - PR.AA-05
# Enforce least privilege and identify
# excessive IAM permissions.
#
# WARNING:
# This configuration intentionally contains
# security misconfigurations.
# DO NOT DEPLOY TO AWS.
# ==========================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# ==========================================
# AWS PROVIDER
# ==========================================

provider "aws" {
  region = "us-east-2"
}

# ==========================================
# IAM ROLE
# ==========================================

# Business Requirement:
# An EC2 application needs to read reports
# from a designated S3 bucket.

resource "aws_iam_role" "app_role" {
  name = "friscosec-app-role"

  # Trust policy: EC2 can assume this role.
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

# Finding 1:
# Excessive S3 permissions.
#
# Finding 2:
# Unrestricted iam:PassRole.
#
# Both violate our stated least-privilege
# security objective.

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
