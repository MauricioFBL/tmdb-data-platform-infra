resource "aws_s3_bucket" "datalake" {
  bucket = "${var.project_name}-${var.environment}"
  force_destroy = true
  

  tags = {
    Name        = var.project_name
    Environment = var.environment
  }
}

resource "aws_s3_object" "storage_layers" {
    for_each = toset(var.folders)
    bucket  = aws_s3_bucket.datalake.id
    key     = "${each.value}/"
    content = ""
}