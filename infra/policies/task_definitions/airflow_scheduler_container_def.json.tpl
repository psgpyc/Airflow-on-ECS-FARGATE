[
    {
      "name": "airflow-scheduler",
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
        }, 
        {
          "name": "AIRFLOW__CELERY__BROKER_URL",
          "value": "${celery_broker_url}"
        }, 
        {
          "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
          "value": "${execution_api_server_url}"
        }
      ],
      "secrets": [
        {
            "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
            "valueFrom": "${airflow_sql_alchemy_conn_arn}:sql_alchemy_conn::"
        },
        {
          "name": "AIRFLOW__CELERY__RESULT_BACKEND",
          "valueFrom": "${airflow_sql_alchemy_conn_arn}:celery_backend_conn::"

        }
      ],
      "mountPoints": ${mount_points},
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/aede/airflow",
          "awslogs-region": "eu-west-2",
          "awslogs-stream-prefix": "airflow-scheduler"
        }
      },
      "command": ["scheduler"]
    }
]
