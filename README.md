# terraform-aws-ec2
Terraform AWS S3 Module


-->

Terraform module to provision AWS [`S3`]



####

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

module "s3" {
  source                   = "git::https://git@github.com/ucopacme/terraform-aws-s3-multi-use-bucket.git//?ref=v0.0.4"
  bucket                   = join("-", ["server-access-logging", data.aws_caller_identity.current.account_id, "us-west-2"])
  enabled                  = true
  policy                   = file("./policy.json")
  policy_enabled           = false
  lifecycle_rule_enabled   = "Enabled"
  lifecycle_id             = "secops lifecycle"
  sse_algorithm            = "AES256"
  standard_transition_days = 30
  infrequent_access_type   = "STANDARD_IA"
  expiration_days          = 180
  prefix                   = "" # Default = "" ; to use:  prefix = "logs/"
  tags = {
    "ucop:application" = "security-logging"
    "ucop:createdBy"   = "terraform"
    "ucop:environment" = "prod"
    "ucop:group"       = "cs"
    "ucop:source"      = "https://github.com/ucopacme/ucop-terraform-config.git"
  }
  versioning_enabled = "Disabled"
}


2. (Optional) create outputs.tf config file, copy/paste the following configuration.

output "bucket_name" {
  value       = module.s3.bucket_name
  description = "Bucket Name"
}
output "bucket_id" {
  value       = module.s3.bucket_id
  description = "Bucket ID"
}
output "bucket_arn" {
  value       = module.s3.bucket_arn
  description = "Bucket ARN"
}
output "bucket_regional_name" {
  value       = module.s3.bucket_regional_name
  description = "The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
}
output "hosted_zone_id" {
  value       = module.s3.hosted_zone_id
  description = "The Route 53 Hosted Zone ID for this bucket's region."
}
output "website_endpoint" {
  value       = module.s3.website_endpoint
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
}
output "website_domain" {
  value       = module.s3.website_domain
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records."
}

