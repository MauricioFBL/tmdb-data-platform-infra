variable "public_key" {
  description = "SSH public key"
  type        = string
}

variable "instance_size" {
  description = "Size of EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet donde se desplegarán ambas EC2."
  type        = string
}

variable "scheduler_security_group_id" {
  description = "Security Group de scheduler, PostgreSQL y DAG Processor."
  type        = string
}

variable "api_security_group_id" {
  description = "Security Group del API Server."
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

variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}