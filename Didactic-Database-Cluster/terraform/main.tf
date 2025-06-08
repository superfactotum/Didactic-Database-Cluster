provider "aws" {
  region = var.aws_region_main
  alias  = "ireland"
}

provider "aws" {
  region = var.aws_region_disaster
  alias  = "london"
}

# --- eu-west-1 (Ireland) Resources ---

data "aws_availability_zones" "available_ew1" {
  provider = aws.ireland
  state    = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# VPC in eu-west-1
resource "aws_vpc" "main_vpc_ew1" {
  provider   = aws.ireland
  cidr_block = var.vpc_cidr_ew1
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "main-postgres-vpc"
  }
}

# Subnets for eu-west-1
resource "aws_subnet" "control_plane_subnet_ew1" {
  provider          = aws.ireland
  vpc_id            = aws_vpc.main_vpc_ew1.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available_ew1.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-control-plane-ew1"
  }
}

resource "aws_subnet" "data_plane_subnet_ew1_az1" {
  provider          = aws.ireland
  vpc_id            = aws_vpc.main_vpc_ew1.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available_ew1.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-data-plane-ew1-${data.aws_availability_zones.available_ew1.names[0]}"
  }
}

resource "aws_subnet" "data_plane_subnet_ew1_az2" {
  provider          = aws.ireland
  vpc_id            = aws_vpc.main_vpc_ew1.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available_ew1.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-data-plane-ew1-${data.aws_availability_zones.available_ew1.names[1]}"
  }
}

resource "aws_subnet" "data_plane_subnet_ew1_az3" {
  provider          = aws.ireland
  vpc_id            = aws_vpc.main_vpc_ew1.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available_ew1.names[2]
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-data-plane-ew1-${data.aws_availability_zones.available_ew1.names[2]}"
  }
}

# Security Group in eu-west-1
resource "aws_security_group" "pg_sg_ew1" {
  provider    = aws.ireland
  name        = "pg-sg-main-k3s"
  description = "Allow all internal traffic for K3S cluster and PostgreSQL in main VPC"
  vpc_id      = aws_vpc.main_vpc_ew1.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    self        = true
    description = "Allow all traffic from within this SG"
  }
  
  # Add specific settings
  # For example add specific K3s ports e.g. 6443 from specific sources or ssh
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pg-sg"
  }
}

# AMI for eu-west-1
data "aws_ami" "amazon_linux_2_ew1" {
  provider    = aws.ireland
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instances in eu-west-1
resource "aws_instance" "control_plane_1" {
  provider               = aws.ireland
  ami                    = data.aws_ami.amazon_linux_2_ew1.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.control_plane_subnet_ew1.id
  vpc_security_group_ids = [aws_security_group.pg_sg_ew1.id]
  tags = { Name = "control_plane_1" }
}

resource "aws_instance" "data_plane_1" {
  provider               = aws.ireland
  ami                    = data.aws_ami.amazon_linux_2_ew1.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.data_plane_subnet_ew1_az1.id
  vpc_security_group_ids = [aws_security_group.pg_sg_ew1.id]
  tags = { Name = "data_plane_1" }
}

resource "aws_instance" "data_plane_2" {
  provider               = aws.ireland
  ami                    = data.aws_ami.amazon_linux_2_ew1.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.data_plane_subnet_ew1_az2.id
  vpc_security_group_ids = [aws_security_group.pg_sg_ew1.id]
  tags = { Name = "data_plane_2" }
}

resource "aws_instance" "data_plane_3" {
  provider               = aws.ireland
  ami                    = data.aws_ami.amazon_linux_2_ew1.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.data_plane_subnet_ew1_az3.id
  vpc_security_group_ids = [aws_security_group.pg_sg_ew1.id]
  tags = { Name = "data_plane_3" } 
}

# S3 Bucket in eu-west-1
resource "random_id" "bucket_suffix_ew1" {
  byte_length = 4
}
resource "aws_s3_bucket" "backup_bucket_ew1" {
  provider = aws.ireland
  bucket   = "${var.s3_bucket_prefix_ew1}-${random_id.bucket_suffix_ew1.hex}"
  tags = { Name = "s3-backup-bucket-eu-west-1" }
}

# --- eu-west-2 (London) Resources ---

data "aws_availability_zones" "available_ew2" {
  provider = aws.london
  state    = "available"
   filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# VPC in eu-west-2
resource "aws_vpc" "disaster_vpc_ew2" {
  provider   = aws.london
  cidr_block = var.vpc_cidr_ew2
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "disaster-postgres-vpc"
  }
}

# Subnet for eu-west-2
resource "aws_subnet" "subnet_ew2" {
  provider          = aws.london
  vpc_id            = aws_vpc.disaster_vpc_ew2.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = data.aws_availability_zones.available_ew2.names[0]
  map_public_ip_on_launch = true
  tags = { Name = "subnet-generic-ew2" }
}

# Security Group in eu-west-2
resource "aws_security_group" "pg_sg_ew2" {
  provider    = aws.london
  name        = "pg-sg-disaster"
  description = "Security group for PostgreSQL in disaster VPC"
  vpc_id      = aws_vpc.disaster_vpc_ew2.id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "pg-sg" }
}

# AMI for eu-west-2
data "aws_ami" "amazon_linux_2_ew2" {
  provider    = aws.london
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance in eu-west-2
resource "aws_instance" "vm_ew2" {
  provider               = aws.london
  ami                    = data.aws_ami.amazon_linux_2_ew2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_ew2.id
  vpc_security_group_ids = [aws_security_group.pg_sg_ew2.id]
  tags = { Name = "disaster-recovery-vm-eu-west-2" }
}

# S3 Bucket in eu-west-2
resource "random_id" "bucket_suffix_ew2" {
  byte_length = 4
}
resource "aws_s3_bucket" "backup_bucket_ew2" {
  provider = aws.london
  bucket   = "${var.s3_bucket_prefix_ew2}-${random_id.bucket_suffix_ew2.hex}"
  tags = { Name = "s3-backup_bucket-eu-west-2" }
}

