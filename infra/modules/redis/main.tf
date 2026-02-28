resource "aws_elasticache_subnet_group" "this" {

    name = "${var.redis_cluster_name}-redis-subnet-group"

    # a list of subnet ids
    subnet_ids = var.redis_private_subnet_ids
  
}


resource "aws_elasticache_cluster" "this" {

    cluster_id = "${var.redis_cluster_name}-redis"
    
    engine = "redis"

    # default 6439
    port = var.redis_port

    # By Default: cache.t3.micro
    node_type = var.redis_node_type 

    num_cache_nodes = var.redis_num_cache_nodes

    subnet_group_name = aws_elasticache_subnet_group.this.name

    security_group_ids = [var.redis_security_group_id]

    apply_immediately = var.apply_immediately

    tags = var.tags

}