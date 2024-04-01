
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
    "ucop:source"      = ""https://github.com/ucopacme/ucop-terraform-deployments/terraform/"
  }
  versioning_enabled = "Disabled"
}

