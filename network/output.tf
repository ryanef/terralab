# network/outputs.tf

output "public_subnets"  {
    value= aws_subnet.tl-public-sn[*].id
}

output "private_subnets"  {
    value= aws_subnet.tl-private-sn[*].id
}

output "vpc_id" {
    value = aws_vpc.terralab.id
}