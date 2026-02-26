[{
    "name": "airflow-init",
    "image": "373901294251.dkr.ecr.eu-west-2.amazonaws.com/airflow-image-repo/airflow:latest",
    "cpu": 0,
    "portMappings": [],
    "essential": true,
    "entryPoint": [
        "/bin/bash", "-lc"
    ],
    "command": [
        "set -e; echo 'Waiting for DB...'; airflow db check; echo 'Running migrations...'; airflow db migrate; echo 'Creating admin user...'; airflow users create --username \"$AIRFLOW_ADMIN_USERNAME\" --firstname \"$AIRFLOW_ADMIN_FIRSTNAME\" --lastname \"$AIRFLOW_ADMIN_LASTNAME\" --role Admin --email \"$AIRFLOW_ADMIN_EMAIL\" --password \"$AIRFLOW_ADMIN_PASSWORD\" || true; echo 'Init complete.'"
    ],
    "environment": [
        {
            "name": "AIRFLOW_ADMIN_EMAIL",
            "value": "psgpyc@gmail.com"
        },
        {
            "name": "AIRFLOW_ADMIN_FIRSTNAME",
            "value": "Paritosh"
        },
        {
            "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
            "value": "false"
        },
        {
            "name": "AIRFLOW__CORE__EXECUTOR",
            "value": "LocalExecutor"
        },
        {
            "name": "AIRFLOW__CORE__AUTH_MANAGER",
            "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
        },
        {
            "name": "AIRFLOW_ADMIN_LASTNAME",
            "value": "Ghimire"
        }
    ],
    "secrets": [
        {
            "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
            "valueFrom": "${airflow_sql_alchemy_conn_arn}:sql_alchemy_conn::"
        },
        {
            "name": "AIRFLOW_ADMIN_USERNAME",
            "valueFrom": "${airflow_web_secrets_arn}:airflow_admin_username::"

        },
        {
            "name": "AIRFLOW_ADMIN_PASSWORD",
            "valueFrom": "${airflow_web_secrets_arn}:airflow_admin_password::"

        }
    ],
    "mountPoints": [],
    "volumesFrom": [],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "/ecs/aede/airflow",
            "awslogs-region": "eu-west-2",
            "awslogs-stream-prefix": "airflow-init"
        }
    },
    "systemControls": []
}]
   