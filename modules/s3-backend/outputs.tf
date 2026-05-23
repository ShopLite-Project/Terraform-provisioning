output "bucket_name" {
  description = "Terraform state bucket name."
  value       = aws_s3_bucket.state.bucket
}

output "bucket_arn" {
  description = "Terraform state bucket ARN."
  value       = aws_s3_bucket.state.arn
}

output "dynamodb_table_name" {
  description = "Terraform state lock table name."
  value       = aws_dynamodb_table.state_lock.name
}

output "key_prefix" {
  description = "Suggested state key prefix for other live roots."
  value       = var.config.key_prefix
}
