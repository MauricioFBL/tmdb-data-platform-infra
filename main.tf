/*
# s3 datalake
module "datalake" {
  source      = "./modules/s3"
  environment = var.environment
}
*/
# Glue Catalog
module "glue_catalog_bronze" {
  source      = "./modules/glue-catalog"
  layer       = "bronze"
  environment = var.environment
}

module "glue_catalog_silver" {
  source      = "./modules/glue-catalog"
  layer       = "silver"
  environment = var.environment
}

# IAM Roles para Glue y dbt
module "glue_role" {
  source = "./modules/iam"
}

module "networking" {
  source = "./modules/networking"
}

module "orchestrator" {
  source = "./modules/orchestrator"

  public_key  = var.public_key
  aws_region  = var.aws_region
  environment = var.environment

  postgres_password      = var.postgres_password
  fernet_key             = var.fernet_key
  jwt_secret             = var.jwt_secret
  api_secret             = var.api_secret
  airflow_admin_password = var.airflow_admin_password

  subnet_id                   = module.networking.subnet_id
  scheduler_security_group_id = module.networking.scheduler_security_group_id
  api_security_group_id       = module.networking.api_security_group_id

  dags_bucket_name = var.dags_bucket_name
  dags_prefix      = var.dags_prefix

  depends_on = [module.networking]
}