variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "instance_type_rds" {
  description = " instance type used for RDS"
  type        = string
}

variable "ami_id" {
  description = "AMI ID used for the EC2 instance"
  type        = string
}


variable "airbyte_ami_id" {
  description = "AMI ID for the Airbyte EC2 instance"
  type        = string
}

variable "airbyte_instance_type" {
  description = "EC2 instance type for Airbyte"
  type        = string
}

variable "dbt_rds_password" {
  type      = string
  sensitive = true
}