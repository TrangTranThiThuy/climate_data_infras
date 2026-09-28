data "http" "my_ip" {
  url = "https://checkip.amazonaws.com/"
}

locals {
  my_ip = "${chomp(data.http.my_ip.response_body)}/32"
}

data "aws_vpc" "existing" {
  id = "vpc-0c3785696ba26c68d"
}

resource "aws_security_group" "weather" {
  name        = "launch-wizard-3"
  description = "launch-wizard-3 created 2026-08-17T08:53:15.509Z"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "airbyte" {
  name        = "airbyte-ec2-sg"
  description = "allows SSH to Airbyte instance"
  vpc_id      = data.aws_vpc.existing.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  ingress {
    description = "Airbyte UI from my IP"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "airbyte-ec2-sg"
    Environment = "dev"
  }
}

resource "aws_security_group" "ecs" {
  name        = "meteo-ecs-sg"
  description = "Security group for MeteoHub ECS Fargate tasks"
  vpc_id      = data.aws_vpc.existing.id

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "meteo-ecs-sg"
    Environment = "dev"
  }
}

data "aws_security_group" "rds" {
  id = "sg-07793509672df165c"
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_ecs" {
  security_group_id            = data.aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.ecs.id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"

  description = "Allow PostgreSQL access from ECS Fargate"
}