variable "aws_region" {
  description = "AWS region for the TMDB data platform"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used as a resource-naming prefix"
  type        = string
  default     = "tmdb-data-platform"
}