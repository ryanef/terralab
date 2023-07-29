module "network" {
    source = "./network"
    
}

module "compute" {
    source = "./compute"
    AWS_REGION = var.AWS_REGION
    public_subnets = module.network.public_subnets
    vpc_id = module.network.vpc_id
    target_group_arn = module.loadbalancer.target_group_arn
}

module "loadbalancer" {
    source = "./loadbalancer"
    vpc_id = module.network.vpc_id
    public_subnets = module.network.public_subnets
}
