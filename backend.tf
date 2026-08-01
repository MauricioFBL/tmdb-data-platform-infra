terraform {
  backend "s3" {
    bucket         = "tf-backend-state-corp"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}
