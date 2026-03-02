locals {
  bucket_name_global = "${var.bucket_name}-${random_id.bucket_suffix.hex}"
}


data "aws_kms_key" "state" {
    key_id = "alias/${var.kms_key_alias}"
}

resource "random_id" "bucket_suffix" {
    byte_length = 3
}

module "s3" {

    source = "./modules/s3"

    bucket_name = local.bucket_name_global

    bucket_tags = var.bucket_tags

    bucket_force_destroy = var.bucket_force_destroy

    bucket_versioning_status = var.bucket_versioning_status

    noncurrent_v_lifecycle_rules = var.noncurrent_v_lifecycle_rules

    sse_algorithm = var.sse_algorithm

    kms_master_key_id = data.aws_kms_key.state.arn

}
