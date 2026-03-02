locals {
  efs_file_system_id = module.efs.efs_file_system_id

  airflow_webserver_efs_volume_config = {
    for k,v in module.efs.efs_access_point_ids: k => {
      file_system_id = local.efs_file_system_id
      access_point_id = v
    }

  }  

  mount_points = [
    for k, _ in local.airflow_webserver_efs_volume_config: {
      sourceVolume = k
      containerPath = "/opt/airflow/${k}" # dags/logs/plugins/config
      readOnly = false
    }
  ]

}
