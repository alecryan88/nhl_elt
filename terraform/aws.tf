
resource "aws_s3_bucket" "buckets" {
  
  for_each =  local.loader_names
  bucket        = each.value
  force_destroy = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  for_each = snowflake_pipe.pipes
  bucket = each.key

  queue {
    queue_arn = each.value.notification_channel
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on =[
    snowflake_pipe.pipes,
    time_sleep.wait_15_seconds,
    aws_s3_bucket.buckets
  ]

}
resource "aws_iam_role" "snowflake_acccess_role" {
  name = "${local.project_name}_snowflake_acccess_role"
  assume_role_policy = data.aws_iam_policy_document.snowflake_assume_role_policy.json

  inline_policy {
    name = "snowflake_s3_access_policy"
    policy = data.aws_iam_policy_document.s3_inline_acces_policy.json
  }
}
