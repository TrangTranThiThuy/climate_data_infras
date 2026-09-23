# ============================================================
# EventBridge → ECS Fargate scheduled dbt execution
# ============================================================

# ------------------------------------------------------------
# 1. IAM role assumed by EventBridge
# ------------------------------------------------------------

resource "aws_iam_role" "eventbridge_ecs" {
  name = "meteo-eventbridge-ecs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "events.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "meteo-eventbridge-ecs-role"
    Environment = "dev"
  }
}


# ------------------------------------------------------------
# 2. Permissions for EventBridge to launch the ECS task
# ------------------------------------------------------------

resource "aws_iam_role_policy" "eventbridge_ecs" {
  name = "meteo-eventbridge-ecs"
  role = aws_iam_role.eventbridge_ecs.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ecs:RunTask"
        ]

        Resource = aws_ecs_task_definition.meteo_dbt.arn
      },
      {
        Effect = "Allow"

        Action = [
          "iam:PassRole"
        ]

        Resource = aws_iam_role.ecs_task_execution.arn
      }
    ]
  })
}


# ------------------------------------------------------------
# 3. Schedule: run dbt every day at 02:00 UTC
# ------------------------------------------------------------

resource "aws_cloudwatch_event_rule" "dbt_schedule" {
  name        = "meteo-dbt-daily"
  description = "Run MeteoHub dbt transformations daily"

  schedule_expression = "cron(0 2 * * ? *)"

  tags = {
    Name        = "meteo-dbt-daily"
    Environment = "dev"
  }
}


# ------------------------------------------------------------
# 4. EventBridge → ECS Fargate target
# ------------------------------------------------------------

resource "aws_cloudwatch_event_target" "dbt_ecs" {
  rule      = aws_cloudwatch_event_rule.dbt_schedule.name
  target_id = "meteo-dbt-fargate"

  arn      = aws_ecs_cluster.meteo.arn
  role_arn = aws_iam_role.eventbridge_ecs.arn

  ecs_target {
    task_definition_arn = aws_ecs_task_definition.meteo_dbt.arn

    launch_type      = "FARGATE"
    platform_version = "LATEST"

    network_configuration {
      subnets = [
        "subnet-001d60d8eb9947dd5"
      ]

      security_groups = [
        aws_security_group.ecs.id
      ]

      assign_public_ip = true
    }
  }
}