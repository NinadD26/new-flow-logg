variable "s3_bucket_name" {
  description = "The name of the existing S3 bucket to store flow logs"
  type        = string
  default     = "flowlog-bcktts"
}

variable "traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL"
  type        = string
  default     = "ALL"
}
