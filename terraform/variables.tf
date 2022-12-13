variable "aws_access_key" {
  description = "AWS secret acces key"
}

variable "aws_secret_key" {
  description = "AWS secret_key"
}

variable "aws_region" {
  description = "AWS region"
}

variable "aws_account_id" {
  description = "AWS account ID."
}

variable "snowflake_user" {
  description = "Snowflake username"
  type        = string
}

variable "snowflake_password" {
  description = "Snowflake password"
  type        = string
}
variable "snowflake_region" {
  description = "Snowflake account region"
  type        = string
}

variable "snowflake_account" {
  description = "Snowflake accoiunt ID."
  type        = string
}

variable "snowflake_account_arn" {
  description = "Snowflake's account ARN"
  type        = string
}

variable "snowflake_external_id" {
  description = "Snowflake's external id"
  type        = string
}