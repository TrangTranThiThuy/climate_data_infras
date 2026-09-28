resource "aws_eip" "weather_server" {
  domain = "vpc"

  tags = {
    Name        = "MeteoHub-EIP"
    Environment = "dev"
  }
}

resource "aws_eip_association" "weather_server" {
  instance_id   = aws_instance.weather_server.id
  allocation_id = aws_eip.weather_server.id
}