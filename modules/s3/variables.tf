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

variable "folders" {
  type = list(string)
  default = [
    "bronze",
    "silver",
    "artifacts/jobs",
    "artifacts/airflow/dags"
  ]
}