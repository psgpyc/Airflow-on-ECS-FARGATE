resource "aws_efs_file_system" "this" {
    # a unique name for efs, to ensure idempotent file system creastion
    creation_token = var.creation_token

    # sane defaults
    encrypted = true
    # general purpose or max io
    performance_mode = "generalPurpose"

    # elastic, brust or provisioned
    throughput_mode = "elastic"

    kms_key_id = var.kms_key_id

    dynamic "lifecycle_policy" {
        
        for_each = var.lifecycle_policy == null ? [] : [var.lifecycle_policy]

        content {
          transition_to_archive = lifecycle_policy.value.transition_to_archive
          transition_to_ia = lifecycle_policy.value.transition_to_ia
        }
      
    }

    tags = merge(var.tags, { Name = "${var.creation_token}-efs"})

}


resource "aws_efs_mount_target" "this" {

    for_each = toset(var.mount_target_subnet_ids)

    file_system_id = aws_efs_file_system.this.id

    # one mount target in subnet of same AZ to avoid cross AZ charges.
    subnet_id = each.value

    # must be a list in vars and allow TCP on 2049
    security_groups = var.mount_target_sec_group_id

}



resource "aws_efs_access_point" "this" {

  # a map of access point path
  for_each = length(var.access_point_config) > 0 ? var.access_point_config : {}

  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = var.airflow_uid
    gid = var.airflow_gid
  }

  root_directory {
    path = each.value

    creation_info {
      owner_uid   = var.airflow_uid
      owner_gid   = var.airflow_gid
      permissions = var.access_permissions
    }
  }

  tags = merge(var.tags, { Name = "${var.creation_token}-${each.key}" })

  depends_on = [aws_efs_mount_target.this]

}
