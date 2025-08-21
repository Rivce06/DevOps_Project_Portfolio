variable "region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"
}

variable "my_state_bucket" {
  description = "S3 bucket unique state name"
  type        = string
  default     = "andresr-devops-20250821"
}

variable "dynamodb_table" {
  description = "dynamodb state table "
  type        = string
  default     = "andres-devops-tfstate-20250821"
}
