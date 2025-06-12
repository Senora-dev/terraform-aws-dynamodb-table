output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = try(aws_dynamodb_table.this[0].arn, "")
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = try(aws_dynamodb_table.this[0].id, "")
}

output "dynamodb_table_stream_arn" {
  description = "The ARN of the Table Stream. Only available when stream_enabled = true"
  value       = try(aws_dynamodb_table.this[0].stream_arn, "")
}

output "dynamodb_table_stream_label" {
  description = "A timestamp, in ISO 8601 format of the Table Stream. Only available when stream_enabled = true"
  value       = try(aws_dynamodb_table.this[0].stream_label, "")
}

output "dynamodb_table_autoscaling_read_target" {
  description = "The ARN of the Application Autoscaling read target"
  value       = try(aws_appautoscaling_target.read_target[0].resource_id, "")
}

output "dynamodb_table_autoscaling_write_target" {
  description = "The ARN of the Application Autoscaling write target"
  value       = try(aws_appautoscaling_target.write_target[0].resource_id, "")
}

output "dynamodb_table_autoscaling_read_policy" {
  description = "The ARN of the Application Autoscaling read policy"
  value       = try(aws_appautoscaling_policy.read_policy[0].arn, "")
}

output "dynamodb_table_autoscaling_write_policy" {
  description = "The ARN of the Application Autoscaling write policy"
  value       = try(aws_appautoscaling_policy.write_policy[0].arn, "")
}

output "dynamodb_table_replica_arns" {
  description = "ARNs of the replicas of the DynamoDB table"
  value       = try(aws_dynamodb_table.this[0].replica.*.region_name, [])
}

output "dynamodb_table_billing_mode" {
  description = "Billing mode of the DynamoDB table"
  value       = try(aws_dynamodb_table.this[0].billing_mode, "")
}

output "dynamodb_table_hash_key" {
  description = "Hash key of the DynamoDB table"
  value       = try(aws_dynamodb_table.this[0].hash_key, "")
}

output "dynamodb_table_range_key" {
  description = "Range key of the DynamoDB table"
  value       = try(aws_dynamodb_table.this[0].range_key, "")
} 