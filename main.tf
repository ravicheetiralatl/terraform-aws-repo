terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "raviorg38"

    workspaces {
      name = "ravi-tf-workspace"
    }
  }
}
# Define the AWS provider and region

provider "aws" {
  region = "ap-southeast-1"
}

# Define the RDS instance
resource "aws_db_instance" "rds" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.t4g.medium"
  identifier           = "rds-${var.prefix}"
  db_name              = "db${var.prefix}"
  username             = "db_user"
  password             = "xfVsgnsroGHqxQ"
  parameter_group_name = "default.postgres15"
  skip_final_snapshot  = true # Set to false if you want to create a final snapshot before deleting

  # Subnet Group
  vpc_security_group_ids = [aws_security_group.asg.id]

  # Availability Zone
  availability_zone = "ap-southeast-1a" # Change to your desired AZ

  # Backup settings
  backup_retention_period = 7             # Change to your desired retention period
  backup_window           = "02:00-03:00" # Change to your desired backup window
}

# Define the DB Subnet Group
resource "aws_db_subnet_group" "adsg" {
  name        = "example-subnet-group"
  description = "Subnet group for RDS example"
  subnet_ids  = [aws_subnet.subnet1.id, aws_subnet.subnet2.id] # Define your subnets here
}

# Define the security group for the RDS instance
resource "aws_security_group" "asg" {
  name        = "example-db-sg"
  description = "Security group for RDS example"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow incoming connections from anywhere (for demonstration purposes; restrict as needed)
  }
}

# Define the VPC and subnets (customize as needed)
resource "aws_vpc" "vpc1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a" # Change to your desired AZ
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b" # Change to your desired AZ
}
