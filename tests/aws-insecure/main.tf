terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# INTENTIONALLY INSECURE TEST FIXTURES.
# Do not deploy these resources.

resource "aws_s3_bucket" "insecure" {
  bucket = "c7n-left-insecure-test-bucket-001"
}

resource "aws_s3_bucket_public_access_block" "insecure" {
  bucket = aws_s3_bucket.insecure.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_ebs_volume" "insecure" {
  availability_zone = "eu-west-1a"
  size              = 8
  encrypted         = false

  tags = {
    Name = "c7n-left-insecure-test-volume"
  }
}

resource "aws_security_group" "insecure" {
  name        = "c7n-left-insecure-test-sg"
  description = "Insecure c7n-left test fixture"

  ingress {
    description = "SSH open to the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "All inbound traffic open"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudtrail" "insecure" {
  name                          = "c7n-left-insecure-test-trail"
  s3_bucket_name                = aws_s3_bucket.insecure.id
  enable_logging                = false
  include_global_service_events = false
  is_multi_region_trail         = false
}

resource "aws_db_instance" "insecure" {
  identifier          = "c7n-left-insecure-test-db"
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username            = "testadmin"
  password            = "NotARealPassword123!"
  skip_final_snapshot = true
  storage_encrypted   = false
}