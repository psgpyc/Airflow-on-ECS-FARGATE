# Airflow on AWS ECS (Fargate)
Infrastructure as Code using Terraform

---

## Overview

This repository contains the full Terraform infrastructure required to deploy **Apache Airflow on AWS ECS (Fargate)**

The goal of this project is to design and provision a secure, scalable, multi-AZ container platform for Airflow while following modern cloud engineering best practices:

- Infrastructure as Code (Terraform)
- Private networking with controlled ingress
- Container orchestration using ECS (Fargate)
- Shared persistent storage via EFS
- Secrets management via AWS Secrets Manager
- Secure IAM role separation

---

## Architecture Overview

### Networking

- Custom VPC
- Public subnets (for ALB)
- Private subnets (for ECS, RDS, EFS)
- Internet Gateway
- NAT Gateway
- Route tables and subnet associations
- Security groups with least-privilege rules

### Compute

- ECS Cluster (Fargate launch type)
- Modular ECS Task Definitions
- ECS Services (to attach to ALB)
- ECR repository for container images

### Load Balancing

- Application Load Balancer (ALB)
- Target Groups
- HTTP listener

### Storage

- Amazon EFS (encrypted at rest)
- Mount targets in private subnets (multi-AZ)
- Dedicated EFS security group allowing NFS (TCP 2049)
- EFS Access Point for Airflow DAGs
  - Enforced POSIX UID/GID
  - Root directory creation
  - Mounted into containers at /opt/airflow/dags

### Database

- RDS PostgreSQL (Airflow metadata database)
- Private subnet deployment
- Restricted security group access from ECS only

### Secrets & IAM

- AWS Secrets Manager for RDS credentials
- Separate Task Execution Role (ECR + CloudWatch access)
- Separate Task Role (runtime permissions)
- Policy templates stored under policies/

### Logging

- CloudWatch Log Groups for ECS containers
- Centralised logging configuration via task definitions

---

## Security Model

Security is implemented at multiple layers.

### Network Security

- ECS tasks run in private subnets.
- Only the ALB is internet-facing.
- EFS mount targets only allow TCP 2049 from Airflow security groups.
- RDS only allows inbound from ECS task security groups.

### Storage Security

- EFS encrypted at rest.
- Transit encryption enabled for NFS.
- Access Points restrict directory access and enforce POSIX identity.

### IAM Separation

- Execution role for platform-level permissions.
- Task role for runtime application permissions.
- Secrets retrieved securely via Secrets Manager.

---

## Current Status

Provisioned components:

- VPC and networking
- ALB
- ECS cluster
- ECR repository
- EFS with mount targets and access point
- CloudWatch log groups
- Secrets Manager integration
- IAM role scaffolding

Next steps:

- Finalise ECS services
- Deploy Airflow webserver, scheduler, and workers
- Attach services to ALB
- Validate DAG loading from EFS

