resource "aws_route53_resolver_endpoint" "inbound" {
  name               = local.resource_name
  direction          = "INBOUND"
  security_group_ids = [aws_security_group.inbound_resolver.id]
  tags               = local.tags

  dynamic "ip_address" {
    for_each = toset(local.private_subnet_ids)

    content {
      subnet_id = ip_address.value
    }
  }
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

resource "aws_security_group" "inbound_resolver" {
  name   = "${local.resource_name}-inbound-resolver"
  vpc_id = local.vpc_id
  tags   = local.tags

  ingress {
    from_port = 53
    to_port   = 53
    protocol  = "udp"
    cidr_blocks = [
      "172.31.0.0/16",
      "10.0.0.0/8",
    ]
  }

  ingress {
    from_port = 53
    to_port   = 53
    protocol  = "tcp"
    cidr_blocks = [
      "172.31.0.0/16",
      "10.0.0.0/8",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
