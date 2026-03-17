terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
   backend "s3" {
     bucket = "ecs-blog-app"
     key    = "ecs-blog/persistent/terraform.tfstate"
     region = "ap-south-1"
     encrypt = true
   }
}

provider "aws" { region = var.aws_region }

# ── ECR Repositories (3 repos, one per service) ──────────────────────────
locals {
  services = ["frontend", "auth-service", "blog-service"]
}

resource "aws_ecr_repository" "services" {
  for_each             = toset(local.services)
  name                 = "${var.project_name}/${each.key}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration { scan_on_push = true }
  tags = { Layer = "persistent", Project = var.project_name }
}

resource "aws_ecr_lifecycle_policy" "services" {
  for_each   = aws_ecr_repository.services
  repository = each.value.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection    = { tagStatus = "any", countType = "imageCountMoreThan", countNumber = 5 }
      action       = { type = "expire" }
    }]
  })
}

# ── Data source to fetch your existing ACM certificate ───────────────────
data "aws_acm_certificate" "existing" {
  domain   = "*.${var.domain_name}"
  statuses = ["ISSUED"]
}

# ── Outputs ──────────────────────────────────────────────────────────────
output "ecr_urls" {
  description = "ECR repository URLs for all 3 services"
  value = { for k, v in aws_ecr_repository.services : k => v.repository_url }
}

output "acm_cert_arn" {
  description = "ARN of your existing ACM certificate"
  value       = data.aws_acm_certificate.existing.arn
}