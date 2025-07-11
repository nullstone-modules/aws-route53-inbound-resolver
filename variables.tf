variable "aws_account_ids" {
  type        = set(string)
  default     = []
  description = <<EOF
A list of AWS account IDs that we are allowing access to the Route53 Resolver.
EOF
}

variable "allowed_cidrs" {
  type        = set(string)
  default     = []
  description = <<EOF
A list of CIDR ranges that are allowed to access the Route53 Resolver.
EOF
}
