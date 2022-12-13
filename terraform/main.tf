# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.1"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.52.0"
    }
  }
}

locals {
  config = yamldecode(file("../loaders.yml"))
  loader_dir = "../loaders"
}

locals {
  loader_names = toset(local.config.loaders[*].name)
  project_name = local.config.project_name
  role_arn  = "arn:aws:iam::${var.aws_account_id}:role/${local.project_name}"
}

#TODO
# -- Create Docker Image
# -- Create ECR repository
# Push docker image to ECR
# -- Create IAM role for executing all of this
# Create Lmabda function using image
# Schedule lambda function
# -- Create S3 Bucket with SQS notification
# Create snowpipe 
# Create role for snowflake to access s3
# Create stage
# Create pipe reading from SQS queue
# Backfill Pipe <= created at date? 