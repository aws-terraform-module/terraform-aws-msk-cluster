# Define Security Group
module "security_group" {
  count = var.create_security_group ? 1 : 0

  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = data.aws_subnet.this.vpc_id

  # ingress
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks

  tags = var.tags
}