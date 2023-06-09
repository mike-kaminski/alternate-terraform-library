resource "aws_security_group" "db-sg" {
  description = "Security Group for the ${var.environment} Aurora cluster"
  name        = "RDS Security group for  ${var.environment} Aurora cluster"
  vpc_id      = var.vpc_id

  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress = [
    {
      cidr_blocks      = values(data.aws_subnet.subnet-private).*.cidr_block
      description      = "VPC CIDR Block"
      from_port        = 3306
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 3306
    },
  ]

}

