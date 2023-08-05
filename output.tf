output "public-subnets" {
    value = module.network.public_subnets
}

output "private-subnets"{
    value = module.network.private_subnets
}

output "instance_ips" {
    value = module.compute.instance_ips
}

output "instance_ids" {
    value = module.compute.instance_ids
}