terraform {
  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state backend intentionally left unconfigured here.
  # Decide and document in an ADR before the first `terraform apply`:
  # S3 backend + DynamoDB lock table is the usual choice, but for a
  # two-person portfolio project a local backend during Phase 0 may be
  # acceptable — this is an open decision, not yet made.
}

provider "aws" {
  region = var.aws_region
}
