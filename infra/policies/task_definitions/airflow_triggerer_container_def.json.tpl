[
    {
      "name": "airflow-dag-processor",
      "image": "373901294251.dkr.ecr.eu-west-2.amazonaws.com/airflow-image-repo/airflow:latest",
      "essential": true,
      "user": "50000:50000",
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
            "name": "AIRFLOW__CORE__FERNET_KEY",
            "value": "04f8e6c390b0f5c458bb3dee989b1baa6849d8bb5988c5688146282126f425f6"
        },
        {
          "name": "AIRFLOW__API__SECRET_KEY",
          "value": "7798b22c9ceeb2806dab7624acaaac687a0db68fdc9ad7777052dd4190356085"
        },
        {
            "name": "AIRFLOW__API_AUTH__JWT_SECRET",
            "value": "fdbc63752230429f60aaa26c644e23d9c7a036ca96a4f1ce7ffa64b788fb8682"
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
          "awslogs-stream-prefix": "airflow-triggerer"
        }
      },
      "command": ["triggerer"]
    }
]
