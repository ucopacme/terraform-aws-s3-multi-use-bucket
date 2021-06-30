output "bucket_name" {
  value       = aws_s3_bucket.this.*.bucket_domain_name
  description = "Bucket Name"
}
output "bucket_id" {
  value       = aws_s3_bucket.this.*.id
  description = "Bucket ID"
}
output "bucket_arn" {
  value       = aws_s3_bucket.this.*.arn
  description = "Bucket ARN"
}
output "bucket_regional_name" {
  value       = aws_s3_bucket.this.*.bucket_regional_domain_name
  description = "The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
}
output "hosted_zone_id" {
  value       = aws_s3_bucket.this.*.hosted_zone_id
  description = "The Route 53 Hosted Zone ID for this bucket's region."
}
output "website_endpoint" {
  value       = aws_s3_bucket.this.*.website_endpoint
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
}
output "website_domain" {
  value       = aws_s3_bucket.this.*.website_domain
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records."
}
