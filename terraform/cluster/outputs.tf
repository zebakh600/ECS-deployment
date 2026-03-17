output "alb_dns_name" {
  description = "Raw ALB URL — use this during Phase 1 testing (no domain)"
  value       = aws_lb.main.dns_name
}

output "test_url" {
  description = "Phase 1 test URL — paste in browser"
  value       = "http://${aws_lb.main.dns_name}"
}

output "website_url" {
  description = "Phase 2 HTTPS URL — works after Cloudflare CNAME is added"
  value       = "https://${var.subdomain}.${var.domain_name}"
}

output "cloudwatch_dashboard" {
  value = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home#dashboards:name=${var.project_name}-dashboard"
}
