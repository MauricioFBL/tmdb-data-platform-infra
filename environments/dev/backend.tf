terraform {
  backend "s3" {
    bucket         = "tf-backend-state-corp"
    key            = "dev/terraform.tfstate" # pendiente parametrizar environment.
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}
