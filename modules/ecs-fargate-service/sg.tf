resource "aws_security_group" "allow-internal" {
  description = "Allows all traffic within the VPC"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
    from_port   = "0"
    protocol    = "tcp"
    self        = "false"
    to_port     = "65535"
  }

  name   = "${var.project}-${var.environment}_allow-internal"
  vpc_id = data.aws_vpc.selected.id
}