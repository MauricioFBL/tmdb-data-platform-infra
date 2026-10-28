data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

locals {
  parameter_name = "/tmdb/airflow/${var.environment}/execution-api"

  template_values = {
    postgres_password = var.postgres_password
    fernet_key        = var.fernet_key
    jwt_secret        = var.jwt_secret
    api_secret        = var.api_secret

    admin_passwords_b64 = base64encode(jsonencode({
      admin = var.airflow_admin_password
    }))

    region         = var.aws_region
    parameter_name = local.parameter_name

    dockerfile_b64 = filebase64(
      "${path.module}/docker/Dockerfile"
    )
  }
}

resource "aws_key_pair" "airflow-key-pair" {
  key_name   = "airflow-key-pair"
  public_key = var.public_key
}

# Permitir que EC2 asuma este rol.
resource "aws_iam_role" "airflow_backend" {
  name_prefix = "tmdb-airflow-${var.environment}-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Usar el nombre conocido evita depender del parámetro, que depende de B.
resource "aws_iam_role_policy" "read_api_endpoint" {
  name = "read-airflow-api-endpoint"
  role = aws_iam_role.airflow_backend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["ssm:GetParameter"]
      Resource = join("", [
        "arn:${data.aws_partition.current.partition}:ssm:",
        "${var.aws_region}:${data.aws_caller_identity.current.account_id}:",
        "parameter${local.parameter_name}"
      ])
    }]
  })
}

resource "aws_iam_instance_profile" "airflow_backend" {
  name_prefix = "tmdb-airflow-${var.environment}-"
  role        = aws_iam_role.airflow_backend.name
}

resource "aws_instance" "airflow-scheduler-db-dp" {
  ami                         = "ami-0d27e0fb3bac4d724"
  instance_type               = var.instance_size
  key_name                    = aws_key_pair.airflow-key-pair.key_name
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    var.scheduler_security_group_id
  ]
  iam_instance_profile = aws_iam_instance_profile.airflow_backend.name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  user_data_base64 = base64gzip(templatefile(
    "${path.module}/scripts/install-docker.sh.tftpl",
    merge(local.template_values, {
      role = "backend"
      compose_b64 = filebase64(
        "${path.module}/docker/compose-scheduler.yaml"
      )
      database_url = "postgresql+psycopg2://airflow:${var.postgres_password}@postgres:5432/airflow"
    })
  ))
  user_data_replace_on_change = true

  depends_on = [aws_iam_role_policy.read_api_endpoint]
}

resource "aws_instance" "airflow-api-server" {
  ami                         = "ami-0d27e0fb3bac4d724"
  instance_type               = var.instance_size
  key_name                    = aws_key_pair.airflow-key-pair.key_name
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    var.api_security_group_id
  ]
  user_data_base64 = base64gzip(templatefile(
    "${path.module}/scripts/install-docker.sh.tftpl",
    merge(local.template_values, {
      role = "api"
      compose_b64 = filebase64(
        "${path.module}/docker/compose-api-server.yaml"
      )
      database_url = "postgresql+psycopg2://airflow:${var.postgres_password}@${aws_instance.airflow-scheduler-db-dp.private_ip}:5432/airflow"
    })
  ))
  user_data_replace_on_change = true
}

# Terraform crea el parámetro después de conocer la IP privada de B.
resource "aws_ssm_parameter" "execution_api" {
  name  = local.parameter_name
  type  = "String"
  tier  = "Standard"
  value = "http://${aws_instance.airflow-api-server.private_ip}:8080/execution/"
}
