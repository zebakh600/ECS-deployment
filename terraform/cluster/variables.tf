variable "aws_region"    { default = "ap-south-1" }
variable "project_name"  { default = "blog-app"  }
variable "domain_name"   {
  description = "Root domain e.g."
  type        = string
}
variable "subdomain" {
  description = "Subdomain prefix e.g. app"
}
variable "mongodb_url" {
  description = "MongoDB Atlas connection string"
  type        = string
  sensitive   = true
  
}
variable "secret_key" {
  description = "JWT secret for auth service"
  type        = string
  sensitive   = true
  #random generated code using command openssl rand -base64 32
}

variable "frontend_image" {
  type    = string
  default = "329668418627.dkr.ecr.ap-south-1.amazonaws.com/blog-app/frontend:latest"
}

variable "auth_image" {
  type    = string
  default = "329668418627.dkr.ecr.ap-south-1.amazonaws.com/blog-app/auth-service:latest"
}

variable "blog_image" {
  type    = string
  default = "329668418627.dkr.ecr.ap-south-1.amazonaws.com/blog-app/blog-service:latest"
}
