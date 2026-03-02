[
    {
      "name": "airflow-celery-worker",
      "image": "373901294251.dkr.ecr.eu-west-2.amazonaws.com/airflow-image-repo/airflow:latest",
      "essential": true,
      "user": "50000:50000",
      "portMappings": [
        {
            "name": "worker-logs",
            "containerPort": 8793,
            "protocol": "tcp"
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
        },
        { 
            "name": "AIRFLOW__CELERY__WORKER_CONCURRENCY",  
            "value": "2"  
        },
        { 
            "name": "AIRFLOW__CELERY__WORKER_PREFETCH_MULTIPLIER",  
            "value": "1"  
        },
        { 
            "name": "AIRFLOW__CELERY__WORKER_MAX_TASKS_PER_CHILD",  
            "value": "50" 
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

        },
        {
            "name": "AIRFLOW__CORE__FERNET_KEY",
            "valueFrom": "${airflow_web_secrets_arn}:airflow_core_fernet_key::"
        },
        {
          "name": "AIRFLOW__API__SECRET_KEY",
          "valueFrom": "${airflow_web_secrets_arn}:airflow_core_api_secret_key::}"
        },
        {
          "name": "AIRFLOW__API_AUTH__JWT_SECRET",
          "valueFrom": "${airflow_web_secrets_arn}:airflow_api_auth_jwt_secret::}"
        }
      ],
      "mountPoints": ${mount_points},
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/aede/airflow",
          "awslogs-region": "eu-west-2",
          "awslogs-stream-prefix": "airflow-celery-worker"
        }
      },
      "command": ["celery", "worker"]
    }
]
