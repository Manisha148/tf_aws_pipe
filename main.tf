# locals {
#   bucketName=var.BucketName
# }
# provider "aws" {
#   region = "us-east-1"
#   shared_credentials_files = ["/credentials"]
#   profile = "demo"
# }

# resource "aws_s3_bucket" "bucket" {
#   bucket = local.bucketName
#   versioning {
#     enabled=true
#   }
  
#   acl = "private"
#   tags = {
#     Name        = "My bucket"
#     Environment = "test"
#   }
# }
# resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
#   bucket=aws_s3_bucket.bucket.bucket
#   rule {
#     id = "demorule"

#     filter {}

#     transition {
#       days          = 30
#       storage_class = "STANDARD_IA"
#     }

#     transition {
#       days          = 60
#       storage_class = "GLACIER"
#     }

#     status = "Enabled"
#   }
    
# }






# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC with CIDR block 10.0.0.0/16
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my_vpc"
  }
}

# Create a public subnet in the VPC
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public_subnet"
  }
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

# Create a route table and associate it with the VPC
resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my_rt"
  }
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my_rt.id
}

# # Create an EC2 instance in the public subnet
# resource "aws_instance" "my_ec2" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.public_subnet.id

#   tags = {
#     Name = "my_ec2"
#   }
# }

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "09876yhkhgbb"

  tags = {
    Name = "my_bucket"
  }
}

# Create an RDS instance in the VPC
resource "aws_db_instance" "my_rds" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "my_rds"
  username             = "admin"
  password             = "password123"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "my_rds"
  }
}

# Create a security group for the RDS instance
resource "aws_security_group" "my_sg" {
  name_prefix = "my_sg_"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_sg"
  }
}

