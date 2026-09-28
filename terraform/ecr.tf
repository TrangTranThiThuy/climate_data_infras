resource "aws_ecr_repository" "meteo_dbt" {
  name                 = "meteo-dbt"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
