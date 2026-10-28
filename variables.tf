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

variable "public_key" {
  description = "SSH public key"
  type        = string
}

variable "postgres_password" {
  type      = string
  sensitive = true
}

variable "fernet_key" {
  type      = string
  sensitive = true
}

variable "jwt_secret" {
  type      = string
  sensitive = true
}

variable "api_secret" {
  type      = string
  sensitive = true
}

variable "airflow_admin_password" {
  type      = string
  sensitive = true
}