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

resource "aws_ram_resource_share" "this" {
  name                      = local.resource_name
  allow_external_principals = true
  tags                      = local.tags
}

resource "aws_ram_principal_association" "this" {
  for_each = var.aws_account_ids

  resource_share_arn = aws_ram_resource_share.this.arn
  principal          = each.value
}

resource "aws_ram_resource_association" "this" {
  resource_share_arn = aws_ram_resource_share.this.arn
  resource_arn       = aws_route53_resolver_endpoint.inbound.arn
}
