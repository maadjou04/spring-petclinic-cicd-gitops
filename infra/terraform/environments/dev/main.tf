# Variables
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "petclinic"
}

# Data sources
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "selected" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1a"
}

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "${var.app_name}-${var.environment}-sg"
  description = "Security group for PetClinic application"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-sg"
    Environment = var.environment
  }
}

# EC2 Instance
resource "aws_instance" "app" {
  ami                    = "ami-0df80e66b6b8a0056"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  subnet_id              = data.aws_subnet.selected.id

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y java-17-amazon-corretto
    yum install -y git
    cd /home/ec2-user
    git clone https://github.com/maadjou04/spring-petclinic-cicd-gitops.git
    cd spring-petclinic-cicd-gitops
    mvn clean package -DskipTests
    nohup java -jar target/*.jar &
    EOF

  tags = {
    Name        = "${var.app_name}-${var.environment}"
    Environment = var.environment
  }
}

output "instance_ip" {
  value = aws_instance.app.public_ip
}

output "instance_url" {
  value = "http://${aws_instance.app.public_ip}:8080"
}
