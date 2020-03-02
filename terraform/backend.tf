terraform {
  backend "s3" {
    bucket = "com.startup.terraform-state"
    region = "us-west-1"
  }
}
