# s3 datalake
module "datalake" {
  source = "./modules/s3"
  environment = var.environment
}

# Glue Catalog
module "glue_catalog_bronze" {
  source = "./modules/glue-catalog"
  layer = "bronze"
  environment = var.environment
}

module "glue_catalog_silver" {
  source = "./modules/glue-catalog"
  layer = "silver"
  environment = var.environment
}

# IAM Roles para Glue y dbt
module "glue_role" {
    source = "./modules/iam"
}