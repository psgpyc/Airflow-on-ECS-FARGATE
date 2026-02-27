[
    {
      "name": "airflow-web",
      "image": "373901294251.dkr.ecr.eu-west-2.amazonaws.com/airflow-image-repo/airflow:latest",
      "essential": true,
      "user": "50000:50000",
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080,
          "protocol": "tcp",
          "name": "${port_name}"
        }
      ],
      "environment": [
        {
          "name": "AIRFLOW__CORE__EXECUTOR",
          "value": "CeleryExecutor"
        },
        {
            "name": "AIRFLOW__CORE__AUTH_MANAGER",
            "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
        },
        {
          "name": "AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION",
          "value": "true"
        }

      ],
      "secrets": [
        {
            "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
            "valueFrom": "${airflow_sql_alchemy_conn_arn}:sql_alchemy_conn::"
        }
      ],
      "mountPoints": ${mount_points},
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/aede/airflow",
          "awslogs-region": "eu-west-2",
          "awslogs-stream-prefix": "airflow-web"
        }
      },
      "command": ["api-server"]
    }
]
