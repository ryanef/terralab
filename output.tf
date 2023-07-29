output "public-subnets" {
    value = module.network.public_subnets
}

output "private-subnets"{
    value = module.network.private_subnets
}