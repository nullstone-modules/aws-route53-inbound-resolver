output "resolver_arn" {
  value       = aws_route53_resolver_endpoint.inbound.arn
  description = "string ||| The ARN of the Route53 Resolver nameservers."
}

output "resolver_ips" {
  value       = aws_route53_resolver_endpoint.inbound.ip_address.*.ip
  description = "list(string) ||| A list of IP addresses for the Route53 Resolver nameservers."
}
