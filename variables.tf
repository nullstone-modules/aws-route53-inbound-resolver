variable "allowed_cidrs" {
  type        = set(string)
  default     = []
  description = <<EOF
A list of CIDR ranges that are allowed to access the Route53 Resolver.
EOF
}
