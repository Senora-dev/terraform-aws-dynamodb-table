variable "create_table" {
  description = "Whether to create the DynamoDB table"
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the table"
  type        = string
}

variable "billing_mode" {
  description = "The billing mode for the table"
  type        = string
  default     = "PROVISIONED"
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key"
  type        = string
}

variable "range_key" {
  description = "The attribute to use as the range (sort) key"
  type        = string
  default     = null
}

variable "read_capacity" {
  description = "The number of read units for the table"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "The number of write units for the table"
  type        = number
  default     = 5
}

variable "attributes" {
  description = "List of nested attribute definitions"
  type        = list(map(string))
  default     = []
}

variable "global_secondary_indexes" {
  description = "List of global secondary indexes"
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    write_capacity     = optional(number)
    read_capacity      = optional(number)
    projection_type    = string
    non_key_attributes = optional(set(string))
  }))
  default     = []
}

variable "local_secondary_indexes" {
  description = "List of local secondary indexes"
  type = list(object({
    name               = string
    range_key          = string
    projection_type    = string
    non_key_attributes = optional(set(string))
  }))
  default     = []
}

variable "stream_enabled" {
  description = "Whether to enable DynamoDB Streams"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "When an item in the table is modified, what information is written to the stream"
  type        = string
  default     = null
}

variable "ttl_enabled" {
  description = "Whether to enable TTL"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "The name of the table attribute to store the TTL timestamp"
  type        = string
  default     = null
}

variable "point_in_time_recovery_enabled" {
  description = "Whether to enable point-in-time recovery"
  type        = bool
  default     = false
}

variable "server_side_encryption_enabled" {
  description = "Whether to enable server-side encryption"
  type        = bool
  default     = true
}

variable "server_side_encryption_kms_key_arn" {
  description = "The ARN of the KMS key to use for server-side encryption"
  type        = string
  default     = null
}

variable "replica_regions" {
  description = "List of regions to replicate the table to"
  type        = list(map(string))
  default     = []
}

variable "autoscaling_enabled" {
  description = "Whether to enable auto-scaling"
  type        = bool
  default     = false
}

variable "read_min_capacity" {
  description = "Minimum read capacity units"
  type        = number
  default     = 5
}

variable "read_max_capacity" {
  description = "Maximum read capacity units"
  type        = number
  default     = 20
}

variable "write_min_capacity" {
  description = "Minimum write capacity units"
  type        = number
  default     = 5
}

variable "write_max_capacity" {
  description = "Maximum write capacity units"
  type        = number
  default     = 20
}

variable "read_target_value" {
  description = "Target value for read capacity utilization"
  type        = number
  default     = 70
}

variable "write_target_value" {
  description = "Target value for write capacity utilization"
  type        = number
  default     = 70
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "table_class" {
  description = "The storage class of the table"
  type        = string
  default     = "STANDARD"
}

variable "deletion_protection_enabled" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = false
}

variable "timeouts" {
  description = "Updated Terraform resource management timeouts"
  type        = map(string)
  default     = {}
} 