resource "aws_ecs_cluster" "meteo" {
  name = "meteo-cluster"

  tags = {
    Name        = "meteo-cluster"
    Environment = "dev"
  }
}

resource "aws_ecs_task_definition" "meteo_dbt" {
  family                   = "meteo-dbt"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "512"
  memory = "1024"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "meteo-dbt"
      image     = "${aws_ecr_repository.meteo_dbt.repository_url}:latest"
      essential = true

      command = ["run"]

      environment = [
        {
          name  = "DBT_PROFILES_DIR"
          value = "/app/ecs"
        },
        {
          name  = "DBT_RDS_HOST"
          value = "database-weatherhub.c2dcu2o0suj9.us-east-1.rds.amazonaws.com"
        },
        {
          name  = "DBT_RDS_PORT"
          value = "5432"
        },
        {
          name  = "DBT_RDS_USER"
          value = "airbyte_user"
        },
        {
          name  = "DBT_RDS_DATABASE"
          value = "weatherdb"
        }
      ]

      environment = [
        {
          name  = "DBT_PROFILES_DIR"
          value = "/app/ecs"
        },
        {
          name  = "DBT_RDS_HOST"
          value = "database-weatherhub.c2dcu2o0suj9.us-east-1.rds.amazonaws.com"
        },
        {
          name  = "DBT_RDS_PORT"
          value = "5432"
        },
        {
          name  = "DBT_RDS_USER"
          value = "airbyte_user"
        },
        {
          name  = "DBT_RDS_DATABASE"
          value = "weatherdb"
        },
        {
          name  = "DBT_RDS_PASSWORD"
          value = var.dbt_rds_password
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.meteo_dbt.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "dbt"
        }
      }
    }
  ])

  tags = {
    Name        = "meteo-dbt"
    Environment = "dev"
  }
}