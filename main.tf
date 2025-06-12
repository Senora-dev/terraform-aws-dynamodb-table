locals {
  billing_mode_valid = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.billing_mode)
  read_capacity_valid = var.billing_mode == "PAY_PER_REQUEST" || var.read_capacity > 0
  write_capacity_valid = var.billing_mode == "PAY_PER_REQUEST" || var.write_capacity > 0

  # Validate billing mode
  validate_billing_mode = tobool(local.billing_mode_valid) ? true : tobool("The billing_mode value must be either 'PROVISIONED' or 'PAY_PER_REQUEST'.")
  # Validate read capacity
  validate_read_capacity = tobool(local.read_capacity_valid) ? true : tobool("read_capacity must be greater than 0 when billing_mode is PROVISIONED.")
  # Validate write capacity
  validate_write_capacity = tobool(local.write_capacity_valid) ? true : tobool("write_capacity must be greater than 0 when billing_mode is PROVISIONED.")
}

resource "aws_dynamodb_table" "this" {
  count = var.create_table ? 1 : 0

  name                        = var.name
  billing_mode               = var.billing_mode
  hash_key                   = var.hash_key
  range_key                  = var.range_key
  table_class                = var.table_class
  deletion_protection_enabled = var.deletion_protection_enabled

  read_capacity  = var.billing_mode == "PROVISIONED" ? max(var.read_capacity, 1) : null
  write_capacity = var.billing_mode == "PROVISIONED" ? max(var.write_capacity, 1) : null

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = local_secondary_index.value.non_key_attributes
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      write_capacity     = var.billing_mode == "PROVISIONED" ? max(coalesce(global_secondary_index.value.write_capacity, 5), 1) : null
      read_capacity      = var.billing_mode == "PROVISIONED" ? max(coalesce(global_secondary_index.value.read_capacity, 5), 1) : null
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.non_key_attributes
    }
  }

  dynamic "replica" {
    for_each = var.replica_regions
    content {
      region_name = replica.value.region_name
    }
  }

  stream_enabled  = var.stream_enabled
  stream_view_type = var.stream_view_type

  ttl {
    enabled        = var.ttl_enabled
    attribute_name = var.ttl_attribute_name
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  server_side_encryption {
    enabled     = var.server_side_encryption_enabled
    kms_key_arn = var.server_side_encryption_kms_key_arn
  }

  tags = var.tags

  timeouts {
    create = lookup(var.timeouts, "create", null)
    update = lookup(var.timeouts, "update", null)
    delete = lookup(var.timeouts, "delete", null)
  }
}

resource "aws_appautoscaling_target" "read_target" {
  count = var.create_table && var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? 1 : 0

  max_capacity       = var.read_max_capacity
  min_capacity       = var.read_min_capacity
  resource_id        = "table/${aws_dynamodb_table.this[0].name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.this]
}

resource "aws_appautoscaling_policy" "read_policy" {
  count = var.create_table && var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? 1 : 0

  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.read_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = var.read_target_value
  }

  depends_on = [aws_appautoscaling_target.read_target]
}

resource "aws_appautoscaling_target" "write_target" {
  count = var.create_table && var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? 1 : 0

  max_capacity       = var.write_max_capacity
  min_capacity       = var.write_min_capacity
  resource_id        = "table/${aws_dynamodb_table.this[0].name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.this]
}

resource "aws_appautoscaling_policy" "write_policy" {
  count = var.create_table && var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? 1 : 0

  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.write_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = var.write_target_value
  }

  depends_on = [aws_appautoscaling_target.write_target]
} 