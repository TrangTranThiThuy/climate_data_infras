resource "aws_cloudwatch_log_group" "meteo_dbt" {
  name              = "/ecs/meteo-dbt"
  retention_in_days = 30

  tags = {
    Name        = "meteo-dbt"
    Environment = "dev"
  }
}