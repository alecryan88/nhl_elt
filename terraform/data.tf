

data "aws_iam_policy_document" "s3_inline_acces_policy" {
  statement {
    actions = [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:ListBucket"
    ]
    effect = "Allow"
    resources = values(tomap({
        for key, val in aws_s3_bucket.buckets : key => val.arn
    }))
  }
}


data "aws_iam_policy_document" "snowflake_assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]
        principals  {
            type = "AWS"
            identifiers = [snowflake_storage_integration.storage_integration.storage_aws_iam_user_arn]
        }
        effect = "Allow"
        
        condition  {
            test = "StringEquals"
            variable = "sts:ExternalId"
            values = [snowflake_storage_integration.storage_integration.storage_aws_external_id]
        }
    }
  }