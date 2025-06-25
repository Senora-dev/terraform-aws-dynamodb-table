# AWS DynamoDB Table Terraform Module

This Terraform module creates a DynamoDB table with support for various features including:
- On-demand or provisioned capacity
- Auto-scaling
- Global tables (replication)
- Point-in-time recovery
- Server-side encryption
- TTL
- Local and global secondary indexes

## Features

- Create DynamoDB tables with flexible configuration
- Support for both on-demand and provisioned capacity modes
- Auto-scaling for read and write capacity
- Global tables with multi-region replication
- Point-in-time recovery
- Server-side encryption with KMS
- TTL (Time To Live) support
- Local and global secondary indexes
- Tagging support

## Usage

```hcl
module "dynamodb_table" {
  source = "Senora-dev/dynamodb-table/aws"

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
      non_key_attributes = ["id"]
    }
  ]

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.1 |
| aws | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_table | Whether to create the DynamoDB table | `bool` | `true` | no |
| name | The name of the table | `string` | n/a | yes |
| billing_mode | The billing mode for the table | `string` | `"PROVISIONED"` | no |
| hash_key | The attribute to use as the hash (partition) key | `string` | n/a | yes |
| range_key | The attribute to use as the range (sort) key | `string` | `null` | no |
| read_capacity | The number of read units for the table | `number` | `null` | no |
| write_capacity | The number of write units for the table | `number` | `null` | no |
| attributes | List of nested attribute definitions | `list(map(string))` | `[]` | no |
| global_secondary_indexes | List of global secondary indexes | `list(map(string))` | `[]` | no |
| local_secondary_indexes | List of local secondary indexes | `list(map(string))` | `[]` | no |
| stream_enabled | Whether to enable DynamoDB Streams | `bool` | `false` | no |
| stream_view_type | When an item in the table is modified, what information is written to the stream | `string` | `null` | no |
| ttl_enabled | Whether to enable TTL | `bool` | `false` | no |
| ttl_attribute_name | The name of the table attribute to store the TTL timestamp | `string` | `null` | no |
| point_in_time_recovery_enabled | Whether to enable point-in-time recovery | `bool` | `false` | no |
| server_side_encryption_enabled | Whether to enable server-side encryption | `bool` | `true` | no |
| server_side_encryption_kms_key_arn | The ARN of the KMS key to use for server-side encryption | `string` | `null` | no |
| replica_regions | List of regions to replicate the table to | `list(map(string))` | `[]` | no |
| autoscaling_enabled | Whether to enable auto-scaling | `bool` | `false` | no |
| read_min_capacity | Minimum read capacity units | `number` | `5` | no |
| read_max_capacity | Maximum read capacity units | `number` | `20` | no |
| write_min_capacity | Minimum write capacity units | `number` | `5` | no |
| write_max_capacity | Maximum write capacity units | `number` | `20` | no |
| read_target_value | Target value for read capacity utilization | `number` | `70` | no |
| write_target_value | Target value for write capacity utilization | `number` | `70` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| table_id | The ID of the DynamoDB table |
| table_arn | The ARN of the DynamoDB table |
| table_name | The name of the DynamoDB table |
| table_stream_arn | The ARN of the DynamoDB stream |
| table_stream_label | A timestamp, in ISO 8601 format, for this stream |

## Examples

### Basic Table

```hcl
module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name                        = "my-table"
  billing_mode               = "PROVISIONED"
  hash_key                   = "id"
  range_key                  = "title"
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
    }
  ]

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}
```

### Table with Auto-scaling

```hcl
module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name                        = "my-table"
  billing_mode               = "PROVISIONED"
  hash_key                   = "id"
  deletion_protection_enabled = false

  read_capacity  = 5
  write_capacity = 5

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]

  autoscaling_enabled = true
  read_min_capacity   = 5
  read_max_capacity   = 20
  write_min_capacity  = 5
  write_max_capacity  = 20

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}
```

### Global Table

```hcl
module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name                        = "my-table"
  billing_mode               = "PROVISIONED"
  hash_key                   = "id"
  deletion_protection_enabled = false

  read_capacity  = 5
  write_capacity = 5

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]

  replica_regions = [
    {
      region_name = "eu-west-1"
    },
    {
      region_name = "ap-southeast-1"
    }
  ]

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}
```

## License

MIT Licensed. See [LICENSE](LICENSE) for full details.

## Maintainers

This module is maintained by [Senora.dev](https://senora.dev). 