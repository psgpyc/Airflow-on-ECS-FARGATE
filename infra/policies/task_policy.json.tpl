{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "ReadSecretForContainerInjection",
        "Effect": "Allow", 
        "Action": [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
        ],
        "Resource": [
            "${secrets_arn}"
        ]
    }]
}