data "aws_caller_identity" "current" {}
data "aws_vpc" "vpc_id" {
  id = var.vpc_id
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.vpc_id.id
  filter {
    name   = "tag:subnet-type"
    values = ["private"]
  }
}

data "aws_subnet" "subnet-private" {

  for_each = data.aws_subnet_ids.private_subnets.ids
  id       = each.value
}

data "aws_kms_key" "basic" {
  key_id = "alias/basic-data-kms-key"
}

