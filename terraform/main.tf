terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49.0"
    }
  }
}

provider "aws" {
  region              = "us-east-2" # Change this to your desired region
  shared_config_files = ["~/.aws/credentials"]
  profile             = "terraform"
}

resource "aws_vpc" "study_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "study_public_subnet" {
  vpc_id                  = aws_vpc.study_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
  tags = {
    Name = "dev-public-subnet"
  }
}

resource "aws_internet_gateway" "study_internet_gateway" {
  vpc_id = aws_vpc.study_vpc.id
  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "study_route_table" {
  vpc_id = aws_vpc.study_vpc.id
  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route" "study_route" {
  route_table_id         = aws_route_table.study_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.study_internet_gateway.id
}

resource "aws_route_table_association" "study_rta" {
  subnet_id      = aws_subnet.study_public_subnet.id
  route_table_id = aws_route_table.study_route_table.id
}

resource "aws_security_group" "study_sg" {
  vpc_id      = aws_vpc.study_vpc.id
  name        = "study-sg"
  description = "dev sg for study app"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["208.58.219.22/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "study_key_pair" {
  key_name   = "study-key"
  public_key = file("~/.ssh/study.pub")
}

resource "aws_instance" "study_ec2" {
  ami                    = data.aws_ami.server_ami.id # ubuntu AMI for us-east-2
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.study_sg.id]
  subnet_id              = aws_subnet.study_public_subnet.id
  #iam_instance_profile = aws_iam_instance_profile.ec2_study.name

  key_name = aws_key_pair.study_key_pair.id


  tags = {
    Name = "dev-study-ec2"
  }
}
/*
resource "aws_iam_instance_profile" "ec2_study" {
  name = "ec2-study"
  role = aws_iam_role.ec2_study.name
}

resource "aws_iam_role" "ec2_study" {
  name = "ec2-study"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


*/