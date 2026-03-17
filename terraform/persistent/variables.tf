variable "aws_region"   { default = "ap-south-1" }
variable "project_name" { default = "blog-app"  }
variable "domain_name"  {
  description = "Domain name"
  type        = string
  default     = "zeba.click"
}
