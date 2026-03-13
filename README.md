![Terraform CI](https://github.com/psgpyc/Airflow-on-ECS-FARGATE/actions/workflows/terraform.yml/badge.svg)
![Terraform](https://img.shields.io/badge/Terraform-1.11.3-623CE4?style=flat-square&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Fargate%20%7C%20RDS%20%7C%20EFS-FF9900?style=flat-square&logo=amazonwebservices&logoColor=white)
![Airflow](https://img.shields.io/badge/Apache%20Airflow-3.1.7-017CEE?style=flat-square&logo=apacheairflow&logoColor=white)
![CI/CD](https://img.shields.io/badge/GitHub%20Actions-OIDC%20Deploy-2088FF?style=flat-square&logo=githubactions&logoColor=white)

> **Live Airflow UI:** [http://aede-lb-13273499.eu-west-2.elb.amazonaws.com](http://aede-lb-13273499.eu-west-2.elb.amazonaws.com)
>
> **Reviewing this repo?** Jump to the [reviewer guide](#how-to-review-this-repo)

# AEDE: Apache Airflow on AWS ECS Fargate

I built this as the execution layer for my [restaurant reservation pipeline](https://github.com/psgpyc/Data-Engineering-Pipeline-Restaurant-Reservation-Data-Management).

Everything here is Terraform-managed. It provisions from scratch, stores state remotely in S3, and deploys through CI using OIDC with no static credentials anywhere in the pipeline.

---


## Architecture

Airflow runs entirely in private subnets. The only public-facing component is the Application Load Balancer, which sits in a public subnet and forwards HTTP traffic to the webserver service. ECS tasks are not reachable from the internet directly.

```
Internet
    |
    v
Application Load Balancer       [public subnets]
    |
    v
Airflow Webserver                [private subnets]
Airflow Scheduler
Airflow Triggerer
Airflow Workers (Celery)
    |              |           |
   RDS           Redis        EFS
(PostgreSQL)  (ElastiCache) (DAGs/Logs)
```

DAGs and logs live on EFS and are mounted into every container via access points. DAG updates are visible to all services without rebuilding or redeploying any images.

Secrets are stored in AWS Secrets Manager and injected at runtime. Nothing sensitive is hardcoded in task definitions or Terraform variable files.

---

## AWS services

| Service | Role |
|---|---|
| ECS Fargate | Serverless container runtime for all Airflow components |
| Application Load Balancer | Public entry point, routes HTTP to the webserver |
| Amazon EFS | Shared filesystem for DAGs, plugins, config, and logs |
| Amazon RDS PostgreSQL | Airflow metadata database |
| ElastiCache Redis | Celery message broker |
| AWS Secrets Manager | DB credentials, Fernet key, webserver secret key |
| AWS KMS | Encryption at rest across S3, EFS, RDS, Secrets Manager, ElastiCache |
| IAM | Least-privilege roles for task execution and runtime |
| NAT Gateway | Outbound internet access for private subnet containers |
| S3 | Remote Terraform state backend |

---

## Design decisions

**Fargate over EC2**

No cluster management, no AMI patching, no capacity planning for the Airflow host itself. Fargate tasks are stateless and billed per vCPU/memory second. The trade-off is slightly higher cold-start latency, which is acceptable for a pipeline orchestrator where tasks are not latency-sensitive.

**CeleryExecutor over KubernetesExecutor**

KubernetesExecutor gives better per-task isolation and resource bin-packing, but adds significant operational complexity. For the workload this infrastructure targets, Celery with Redis is the right call.

**EFS for DAG sharing**

The alternative is baking DAGs into a custom Docker image and redeploying containers on every change. EFS access points give all Fargate tasks a consistent view of the DAG folder without a redeployment cycle.

**Separate IAM roles for execution and runtime**

The task execution role is used by the ECS control plane to pull images and write logs. The task runtime role is assumed by the running container and is scoped only to what the DAGs actually need. Conflating the two is a common mistake that results in over-privileged containers.

---

## Security model

ECS tasks sit in private subnets with no direct inbound route from the internet. Security groups enforce strict trust chains: ALB to webserver, ECS to RDS, ECS to Redis, ECS to EFS. Nothing else is permitted.

KMS customer-managed keys are used for encryption at rest across S3, EFS, RDS, ElastiCache, and Secrets Manager.

GitHub Actions authenticates to AWS via OIDC. No long-lived access keys are stored as GitHub secrets. The OIDC provider is scoped to this repository.

---

## Repository structure

```
.
├── infra/
│   ├── networking/             VPC, subnets, IGW, NAT, route tables
│   ├── ecs/                    Cluster, task definitions, services
│   ├── rds/                    PostgreSQL instance and subnet group
│   ├── elasticache/            Redis cluster and subnet group
│   ├── efs/                    Filesystem and access points
│   ├── alb/                    Load balancer and target groups
│   ├── iam/                    Execution and runtime roles
│   ├── secrets/                Secrets Manager resources
│   └── kms/                    KMS keys and aliases
├── tfstate-backend-bootstrap/  One-time S3 backend setup
└── .github/workflows/
    └── terraform.yml           Plan on PR, apply on merge to master
```

---

## What runs on this

This is the execution layer for a multi-platform restaurant reservation pipeline that consolidates bookings from OpenTable, SevenRooms, and Resy into Snowflake. DAGs are currently being authored and will handle scheduled extraction, normalisation, and dbt-triggered transformation.

See: [Data-Engineering-Pipeline-Restaurant-Reservation-Data-Management](https://github.com/psgpyc/Data-Engineering-Pipeline-Restaurant-Reservation-Data-Management)

---

## How to review this repo

| What to look at | Where |
|---|---|
| Network topology | `infra/networking/` |
| ECS task definitions and services | `infra/ecs/` |
| IAM role separation | `infra/iam/` |
| KMS and secrets setup | `infra/kms/`, `infra/secrets/` |
| CI/CD pipeline | `.github/workflows/terraform.yml` |
| Live deployment | [Airflow UI](http://aede-lb-13273499.eu-west-2.elb.amazonaws.com) |

---

## Related projects

- [WASH Analytics Engineering Project](https://github.com/psgpyc/WASH-Analytics-Engineering-Project) — dbt + Snowflake + event-driven ingestion on AWS
- [Restaurant Reservation Pipeline](https://github.com/psgpyc/Data-Engineering-Pipeline-Restaurant-Reservation-Data-Management) — the DAG workload this infrastructure will run

---

## Licence

MIT
