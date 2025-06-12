provider "aws" {
  region = "us-west-2"
}

module "dynamodb_table" {
  source = "../../"

  name                        = "my-table"
  billing_mode               = "PROVISIONED"
  hash_key                   = "id"
  range_key                  = "title"
  table_class                = "STANDARD"
  deletion_protection_enabled = false

  read_capacity  = 5
  write_capacity = 5

  attributes = [
    {
      name = "id"
      type = "S"
    },
    {
      name = "title"
      type = "S"
    },
    {
      name = "created_at"
      type = "N"
    }
  ]

  global_secondary_indexes = [
    {
      name               = "TitleIndex"
      hash_key           = "title"
      range_key          = "created_at"
      projection_type    = "INCLUDE"
      non_key_attributes = toset(["id"])
    }
  ]

  # Enable point-in-time recovery
  point_in_time_recovery_enabled = true

  # Enable server-side encryption
  server_side_encryption_enabled = true

  # Enable auto-scaling
  autoscaling_enabled = true
  read_min_capacity   = 5
  read_max_capacity   = 20
  write_min_capacity  = 5
  write_max_capacity  = 20

  # Enable DynamoDB Streams
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  # Enable TTL
  ttl_enabled = true
  ttl_attribute_name = "ttl"

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
} 