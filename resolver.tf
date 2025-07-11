resource "aws_route53_resolver_endpoint" "inbound" {
  name               = local.resource_name
  direction          = "INBOUND"
  security_group_ids = [aws_security_group.this.id]
  tags               = local.tags

  dynamic "ip_address" {
    for_each = toset(local.private_subnet_ids)

    content {
      subnet_id = ip_address.value
    }
  }
}

locals {
  resolver_ips = join(",", aws_route53_resolver_endpoint.inbound.ip_address.*.ip)
}
