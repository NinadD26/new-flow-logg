

data "aws_iam_role" "flow_logs_role" {
  name = "vpc-flowlogs-role"
}

data "aws_s3_bucket" "flow_logs_bucket" {
  bucket = var.s3_bucket_name
}




resource "aws_s3_object" "create_vpc_folders" {
  for_each = toset(data.aws_vpcs.all.ids)
  bucket   = var.s3_bucket_name
  key      = "test-flowlog/${each.value}/"
}

resource "aws_flow_log" "vpc_flow_log" {
  for_each             = toset(data.aws_vpcs.all.ids)
  vpc_id               = each.value
  log_destination      = "${data.aws_s3_bucket.flow_logs_bucket.arn}/test-flowlog/${each.value}/Awslogs/"
  traffic_type         = var.traffic_type
  log_destination_type = "s3"

  # log_format = "${vpc_id} ${subnet_id} ${region} ${account_id} ${az_id} ${flow_direction} ${protocol}"

  destination_options {
    file_format                = "plain-text"
    hive_compatible_partitions = false
    per_hour_partition         = false
  }
}

output "flow_logs_role_arn" {
  value = data.aws_iam_role.flow_logs_role.arn
}

output "vpc_flow_log_ids" {
  value = values(aws_flow_log.vpc_flow_log)[*].id
}














# resource "aws_s3_bucket" "flow_logs_bucket" {
#   bucket = var.s3_bucket_name

#   versioning {
#     enabled = true
#   }

#   lifecycle_rule {
#     enabled = true
#     noncurrent_version_expiration {
#       days = 30
#     }
#   }
# }

# resource "aws_iam_role" "flow_logs_role" {
#   name = "vpc-flowlogs-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "vpc-flow-logs.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "flow_logs_policy" {
#   name   = "vpc-flow-logs-policy"
#   role   = aws_iam_role.flow_logs_role.id
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = [
#           "s3:PutObject"
#         ],
#         Effect   = "Allow",
#         Resource = "${aws_s3_bucket.flow_logs_bucket.arn}/*"
#       },
#       {
#         Action = [
#           "s3:GetBucketAcl"
#         ],
#         Effect   = "Allow",
#         Resource = aws_s3_bucket.flow_logs_bucket.arn
#       }
#     ]
#   })
# }

# resource "aws_flow_log" "vpc_flow_log" {
#   log_destination      = aws_s3_bucket.flow_logs_bucket.arn
#   traffic_type         = var.traffic_type
#   for_each             = toset(data.aws_vpcs.all.ids)
#   vpc_id               = each.value
#   log_destination_type = "s3"

# }
####################################################################old version################
# output "s3_bucket_name" {
#   value = aws_s3_bucket.flow_logs_bucket.bucket
# }

# output "flow_logs_role_arn" {
#   value = aws_iam_role.flow_logs_role.arn
# }

# output "vpc_flow_log_id" {
#   value = aws_flow_log.vpc_flow_log[each.value].id
# }
#############################################

# resource "aws_s3_bucket" "flow_logs_buckets" {
#   bucket = var.s3_bucket_name

#   # versioning {
#   #   enabled = true
#   # }

#   # lifecycle_rule {
#   #   enabled = true
#   #   noncurrent_version_expiration {
#   #     days = 30
#   #   }
#   # }
# }
#=======================================================================================================================
# resource "aws_s3_bucket_object" "create_vpc_folders" {
#   for_each = toset(data.aws_vpcs.all.ids)
#   bucket   = var.s3_bucket_name
#   key      = "us-east-1/${each.value}/"
# }

# resource "aws_iam_role" "flow_logs_role-" {
#   name = "vpc-flowlogs-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "vpc-flow-logs.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "flow_logs_policy" {
#   name   = "vpc-flow-logs-policy"
#   role   = aws_iam_role.flow_logs_role.id
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = [
#           "s3:PutObject"
#         ],
#         Effect   = "Allow",
#         Resource = "${aws_s3_bucket.flow_logs_buckets.arn}/us-east-1/*"
#       },
#       {
#         Action = [
#           "s3:GetBucketAcl"
#         ],
#         Effect   = "Allow",
#         Resource = aws_s3_bucket.flow_logs_buckets.arn
#       }
#     ]
#   })
# }

# # data "aws_vpcs" "all" {}

# resource "aws_s3_bucket_object" "create_vpc_folders" {
#   for_each = toset(data.aws_vpcs.all.ids)
#   bucket   = aws_s3_bucket.flow_logs_buckets.bucket
#   key      = "us-east-1/${each.value}/"
# }

# resource "aws_flow_log" "vpc_flow_log" {
#   for_each             = toset(data.aws_vpcs.all.ids)
#   vpc_id               = each.value
#   log_destination      = "${aws_s3_bucket.flow_logs_buckets.arn}/us-east-1/${each.value}/2024/"
#   traffic_type         = var.traffic_type
#   log_destination_type = "s3"
  
#   # log_format = "${vpc-id} ${subnet-id} ${region} ${account-id} ${az-id} ${flow-direction} ${protocol}"
  

#   #  log_format = join(" ", [
#   #   "vpc-id",
#   #   "subnet-id",
#   #   "region",
#   #   "account-id",
#   #   "az-id",
#   #   "flow-direction",
#   #   "protocol"
#   # ])

#   destination_options {
#     file_format                = "plain-text"
#     hive_compatible_partitions = false
#     per_hour_partition         = false
#   }
# }

# # output "s3_bucket_name" {
# #   value = aws_s3_bucket.flow_logs_bucket.bucket
# # }

# # output "flow_logs_role_arn" {
# #   value = aws_iam_role.flow_logs_role.arn
# # }

# # output "vpc_flow_log_id" {
# #   value = aws_flow_log.vpc_flow_log[each.value].id
# # }
#******************************************************************************************************************************************************



# data "aws_vpcs" "all" {}

# resource "aws_s3_bucket_object" "create_vpc_folders" {
#   for_each = toset(data.aws_vpcs.all.ids)
#   bucket   = var.s3_bucket_name
#   key      = "flowlog/${each.value}/Awslogs/"
# }



