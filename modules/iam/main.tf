# Rol para Glue bronze (ajustar permisos).
resource "aws_iam_role" "glue_bronze_role" {
    name = "glue-bronze-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow"
            Principal = {
                Service = "glue.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }
        ]
    })
    }

# Rol que usara Glue para la Interactive Sesion (ajustar permisos).
resource "aws_iam_role" "dbt_glue_role" {
    name = "tmdb-data-platform-dbt-glue-session"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow"
            Principal = {
                Service = "glue.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }
        ]
    })
    }

# Politica Admin (crear una con permisos necesarios).
resource "aws_iam_role_policy_attachment" "glue_bronze_admin_access" {
    role       = aws_iam_role.glue_bronze_role.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

}

resource "aws_iam_role_policy_attachment" "dbt_glue_admin_access" {
    role       = aws_iam_role.dbt_glue_role.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

}