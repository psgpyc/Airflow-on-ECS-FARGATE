resource "aws_security_group" "this" {

    name = var.sec_group_name

    description = var.sec_group_description

    vpc_id = var.sec_group_vpc_id

    tags = merge(
        var.tags,
        { Name = var.sec_group_name }
    )

}

