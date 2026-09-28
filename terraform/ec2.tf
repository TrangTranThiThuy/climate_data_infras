resource "aws_instance" "weather_server" {
  ami           = var.ami_id
  instance_type = var.instance_type_rds

  vpc_security_group_ids = [
    "sg-0aca0159c1fdf6763",
    aws_security_group.weather.id
  ]

  tags = {
    Name        = "MeteoHub"
    Environment = "dev"
  }
}


resource "aws_instance" "airbyte" {
  ami           = var.airbyte_ami_id
  instance_type = var.airbyte_instance_type

  key_name = "airbyte-ec2"

  vpc_security_group_ids = [
    aws_security_group.airbyte.id,
    "sg-09667b212a31b7662"
  ]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name        = "Airbyte"
    Environment = "dev"
  }
}