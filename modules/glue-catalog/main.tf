resource "aws_glue_catalog_database" "glue_catalog" {
    name = "${var.layer}-${var.environment}"
}