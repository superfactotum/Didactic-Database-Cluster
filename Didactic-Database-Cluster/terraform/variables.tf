variable "aws_region_main" {
  description = "AWS region for the main resources (eu-west-1)"
  type        = string
  default     = "eu-west-1"
}

variable "aws_region_disaster" {
  description = "AWS region for the disaster recovery resources (eu-west-2)"
  type        = string
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "EC2 instance type for all VMs"
  type        = string
  default     = "t3.2xlarge"
}

variable "vpc_cidr_ew1" {
  description = "CIDR block for the VPC in eu-west-1"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_cidr_ew2" {
  description = "CIDR block for the VPC in eu-west-2"
  type        = string
  default     = "10.1.0.0/16"
}

variable "s3_bucket_prefix_ew1" {
  description = "Prefix for the S3 bucket name in eu-west-1. A random suffix will be added."
  type        = string
  default     = "backup-postgres-bucket-ew1"
}

variable "s3_bucket_prefix_ew2" {
  description = "Prefix for the S3 bucket name in eu-west-2. A random suffix will be added."
  type        = string
  default     = "my-dr-backup-postgres-bucket-ew2"
}