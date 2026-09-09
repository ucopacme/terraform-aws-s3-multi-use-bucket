# terraform-aws-s3-multi-use-bucket

Terraform AWS S3 multi-use bucket module.

Special Note: When configuring a lifecycle policy and utilizing both `noncurrent_version_expiration_days` and `newer_noncurrent_versions`, BOTH conditions must be true for the lifecycle rule to apply to the object.

Special Note: S3 server access logging is optional and off by default. Set `logging_enabled = true` and provide `logging_target_bucket` and `logging_target_prefix` (typically `access_logs/<bucket-name>/`) to bring bucket logging under management.

## Usage

```hcl
data "aws_caller_identity" "current" {}

module "s3" {
  source                   = "git::https://git@github.com/ucopacme/terraform-aws-s3-multi-use-bucket.git//?ref=v0.0.9"
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

  # Optional S3 server access logging (off by default)
  logging_enabled       = true
  logging_target_bucket = join("-", ["server-access-logging", data.aws_caller_identity.current.account_id, "us-west-2"])
  logging_target_prefix = "access_logs/<bucket-name>/"

  tags = {
    "ucop:application" = "security-logging"
    "ucop:createdBy"   = "terraform"
    "ucop:environment" = "prod"
    "ucop:group"       = "cs"
    "ucop:source"      = "https://github.com/ucopacme/ucop-terraform-config.git"
  }
  versioning_enabled = "Disabled"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.63.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_abort_incomplete_multipart_upload_days"></a> [abort\_incomplete\_multipart\_upload\_days](#input\_abort\_incomplete\_multipart\_upload\_days) | Maximum time (in days) that you want to allow multipart uploads to remain in progress | `number` | `10` | no |
| <a name="input_allow_encrypted_uploads_only"></a> [allow\_encrypted\_uploads\_only](#input\_allow\_encrypted\_uploads\_only) | Set to `true` to prevent uploads of unencrypted objects to S3 bucket | `bool` | `false` | no |
| <a name="input_allowed_bucket_actions"></a> [allowed\_bucket\_actions](#input\_allowed\_bucket\_actions) | List of actions the user is permitted to perform on the S3 bucket | `list(string)` | <pre>[<br/>  "s3:PutObject",<br/>  "s3:PutObjectAcl",<br/>  "s3:GetObject",<br/>  "s3:DeleteObject",<br/>  "s3:ListBucket",<br/>  "s3:ListBucketMultipartUploads",<br/>  "s3:GetBucketLocation",<br/>  "s3:AbortMultipartUpload"<br/>]</pre> | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Set to `false` to disable the blocking of new public access lists on the bucket | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Set to `false` to disable the blocking of new public policies on the bucket | `bool` | `true` | no |
| <a name="input_blocked_encryption_types"></a> [blocked\_encryption\_types](#input\_blocked\_encryption\_types) | List of encryption types to block. AWS defaults to blocking SSE-C. | `list(string)` | <pre>[<br/>  "SSE-C"<br/>]</pre> | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | S3 Bucket name | `string` | n/a | yes |
| <a name="input_bucket_key_enabled"></a> [bucket\_key\_enabled](#input\_bucket\_key\_enabled) | Whether to use an S3 Bucket Key for SSE-KMS | `bool` | `false` | no |
| <a name="input_cors_rule_inputs"></a> [cors\_rule\_inputs](#input\_cors\_rule\_inputs) | Specifies the allowed headers, methods, origins and exposed headers when using CORS on this bucket | <pre>list(object({<br/>    allowed_headers = list(string)<br/>    allowed_methods = list(string)<br/>    allowed_origins = list(string)<br/>    expose_headers  = list(string)<br/>    max_age_seconds = number<br/>  }))</pre> | `null` | no |
| <a name="input_enable_glacier_transition"></a> [enable\_glacier\_transition](#input\_enable\_glacier\_transition) | Enables the transition to AWS Glacier which can cause unnecessary costs for huge amount of small files | `bool` | `true` | no |
| <a name="input_enable_standard_ia_transition"></a> [enable\_standard\_ia\_transition](#input\_enable\_standard\_ia\_transition) | Enables the transition to STANDARD\_IA | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to `false` to prevent the module from creating resources | `bool` | `true` | no |
| <a name="input_expiration_days"></a> [expiration\_days](#input\_expiration\_days) | Number of days after which to expunge the objects | `number` | `90` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean string that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable | `bool` | `false` | no |
| <a name="input_glacier_transition_days"></a> [glacier\_transition\_days](#input\_glacier\_transition\_days) | Number of days after which to move the data to the glacier storage tier | `number` | `60` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Set to `false` to disable the ignoring of public access lists on the bucket | `bool` | `true` | no |
| <a name="input_infrequent_access_type"></a> [infrequent\_access\_type](#input\_infrequent\_access\_type) | Define type of infrequent access S3, standard or onezone | `string` | `"STANDARD_IA"` | no |
| <a name="input_kms_master_key_arn"></a> [kms\_master\_key\_arn](#input\_kms\_master\_key\_arn) | The AWS KMS master key ARN used for the `SSE-KMS` encryption. This can only be used when you set the value of `sse_algorithm` as `aws:kms`. The default aws/s3 AWS KMS master key is used if this element is absent while the `sse_algorithm` is `aws:kms` | `string` | `""` | no |
| <a name="input_lifecycle_id"></a> [lifecycle\_id](#input\_lifecycle\_id) | define name of id within lifecycle | `string` | `"lifecycle"` | no |
| <a name="input_lifecycle_rule_enabled"></a> [lifecycle\_rule\_enabled](#input\_lifecycle\_rule\_enabled) | Enable or disable lifecycle rule | `string` | `"Disabled"` | no |
| <a name="input_lifecycle_tags"></a> [lifecycle\_tags](#input\_lifecycle\_tags) | Tags filter. Used to manage object lifecycle events | `map(string)` | `{}` | no |
| <a name="input_logging_enabled"></a> [logging\_enabled](#input\_logging\_enabled) | Set to `true` to enable S3 server access logging on the bucket | `bool` | `false` | no |
| <a name="input_logging_target_bucket"></a> [logging\_target\_bucket](#input\_logging\_target\_bucket) | The name of the bucket that will receive the S3 server access log objects | `string` | `""` | no |
| <a name="input_logging_target_prefix"></a> [logging\_target\_prefix](#input\_logging\_target\_prefix) | A prefix for all log object keys | `string` | `""` | no |
| <a name="input_newer_noncurrent_versions"></a> [newer\_noncurrent\_versions](#input\_newer\_noncurrent\_versions) | Number of noncurrent versions Amazon S3 will retain. Must be a non-zero positive integer. | `number` | `null` | no |
| <a name="input_noncurrent_version_expiration_days"></a> [noncurrent\_version\_expiration\_days](#input\_noncurrent\_version\_expiration\_days) | Specifies when noncurrent object versions expire | `number` | `90` | no |
| <a name="input_noncurrent_version_transition_days"></a> [noncurrent\_version\_transition\_days](#input\_noncurrent\_version\_transition\_days) | Number of days to persist in the standard storage tier before moving to the glacier tier infrequent access tier | `number` | `30` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Object ownership. Valid values: `BucketOwnerPreferred`, `ObjectWriter` or `BucketOwnerEnforced` | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy | `string` | `""` | no |
| <a name="input_policy_enabled"></a> [policy\_enabled](#input\_policy\_enabled) | Set to `false` to prevent the module from creating resources | `bool` | `false` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix identifying one or more objects to which the rule applies | `string` | `""` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Set to `false` to disable the restricting of making the bucket public | `bool` | `true` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms` | `string` | `"AES256"` | no |
| <a name="input_standard_transition_days"></a> [standard\_transition\_days](#input\_standard\_transition\_days) | Number of days to persist in the standard storage tier before moving to the infrequent access tier | `number` | `30` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_user_enabled"></a> [user\_enabled](#input\_user\_enabled) | Set to `true` to create an IAM user with permission to access the bucket | `bool` | `false` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket | `string` | `"Disabled"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | Bucket ARN |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | Bucket ID |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Bucket Name |
| <a name="output_bucket_regional_name"></a> [bucket\_regional\_name](#output\_bucket\_regional\_name) | The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | The Route 53 Hosted Zone ID for this bucket's region. |
| <a name="output_website_domain"></a> [website\_domain](#output\_website\_domain) | The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. |
| <a name="output_website_endpoint"></a> [website\_endpoint](#output\_website\_endpoint) | The website endpoint, if the bucket is configured with a website. If not, this will be an empty string. |
<!-- END_TF_DOCS -->
