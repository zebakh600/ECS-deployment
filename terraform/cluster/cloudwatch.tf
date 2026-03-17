# Log groups — one per service, 7-day retention (within free tier)
resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/${var.project_name}/frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "auth_service" {
  name              = "/ecs/${var.project_name}/auth-service"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "blog_service" {
  name              = "/ecs/${var.project_name}/blog-service"
  retention_in_days = 7
}

# Dashboard — visible in AWS Console → CloudWatch → Dashboards
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "ECS CPU Utilization"
          region  = var.aws_region
          period  = 300
          stat    = "Average"
          view    = "timeSeries"
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", "${var.project_name}-cluster", "ServiceName", "frontend"],
            ["AWS/ECS", "CPUUtilization", "ClusterName", "${var.project_name}-cluster", "ServiceName", "auth-service"],
            ["AWS/ECS", "CPUUtilization", "ClusterName", "${var.project_name}-cluster", "ServiceName", "blog-service"]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "ALB Request Count"
          region  = var.aws_region
          period  = 60
          stat    = "Sum"
          view    = "timeSeries"
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.main.arn_suffix]
          ]
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "Auth Service Logs"
          region = var.aws_region
          view   = "table"
          query  = "SOURCE \"/ecs/${var.project_name}/auth-service\" | fields @timestamp, @message | sort @timestamp desc | limit 50"
        }
      },
      {
        type   = "log"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "Blog Service Logs"
          region = var.aws_region
          view   = "table"
          query  = "SOURCE \"/ecs/${var.project_name}/blog-service\" | fields @timestamp, @message | sort @timestamp desc | limit 50"
        }
      }
    ]
  })
}

# Alarm — fires if CPU exceeds 80% for 10 minutes
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  dimensions = {
    ClusterName = "${var.project_name}-cluster"
  }
}
