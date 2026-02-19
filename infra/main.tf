module "vpc_subnet" {

    source = "./modules/vpc"

    name = var.name

    cidr_block = var.cidr_block

    subnet_config = var.subnet_config

}

module "security_groups" {

    source = "./modules/security"

    for_each = var.sec_group_config

    sec_group_name = each.value.sec_group_name

    sec_group_description = each.value.sec_group_description

    sec_group_vpc_id = module.vpc_subnet.vpc_id
  
}

