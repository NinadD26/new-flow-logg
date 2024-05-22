terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
}


provider "aws" {
  region  = "us-east-1"
  profile = "SandboxTeamA"
}


module "vpc_flow_log" {
  source         = "./modules/flowlog"
  traffic_type   = var.traffic_type
  s3_bucket_name = var.s3_bucket_name

}
