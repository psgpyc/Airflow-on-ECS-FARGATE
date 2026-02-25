{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowGetEcrAuthToken",
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken"
            ], 
            "Resource": "*"
        }, 
        {
            "Sid": "AllowEcrPullImages",
            "Effect": "Allow",
            "Action": [

                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage"
            ],
            "Resource": "${ecr_repo_arn}"

        },
        {
            "Sid": "AllowCloudWatchLogWrite",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "${cloudwatch_log_group_arn}:*"
        },
        {
          "Sid" : "ReadDbSecret",
          "Effect":  "Allow",
          "Action": [
            "secretsmanager:GetSecretValue"
          ],
          "Resource": "${secrets_manager_arn}"
        }
]
}