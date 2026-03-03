![Terraform CI](https://github.com/psgpyc/Airflow-on-ECS-FARGATE/actions/workflows/terraform.yml/badge.svg)  
![Terraform](https://img.shields.io/badge/Terraform-1.11.3-623CE4?style=flat-square&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Fargate%20%7C%20RDS%20%7C%20EFS-FF9900?style=flat-square&logo=amazonaws&logoColor=white)
![Airflow](https://img.shields.io/badge/Apache%20Airflow-3.1.7-017CEE?style=flat-square&logo=apacheairflow&logoColor=white)
![CI/CD](https://img.shields.io/badge/GitHub%20Actions-OIDC%20Deploy-2088FF?style=flat-square&logo=githubactions&logoColor=white)

> Live Airflow UI: [Airflow UI](http://aede-lb-13273499.eu-west-2.elb.amazonaws.com)

# AEDE: Airflow on AWS ECS Fargate

This repository is intentionally production-shaped.    
    
I set up Apache Airflow on AWS ECS Fargate with a secure network boundary, shared storage for DAGs/logs, and AWS-managed secrets — designed to be a stable foundation for running real pipelines.

## Architecture overview

Airflow runs as ECS services in private subnets, fronted by an Application Load Balancer (ALB) for the web UI.      
    
DAGs and logs are shared via EFS access points, and metadata is stored in RDS PostgreSQL.       
  
Sensetive configuration and credentials are stored in Secrets Manager, with least-privilege access via IAM roles/policies.      
    
All infrastructure is provisioned using **Terraform**, with state stored remotely in **S3**.

### List of AWS Services:

- Running **Apache Airflow on AWS ECS Fargate** (containerised webserver/scheduler/Triggers/workers)   
- **VPC networking**: Public subnets for **ALB**, private subnets for **ECS Services**
- **Amazon EFS** for shared **DAGs, plugins, config, and logs**
- **Amazon RDS PostgreSQL** as the Airflow metadata database 
- **Amazon ElastiCache (Redis)** as message broker for Celery executor
- **AWS Secrets Manager** for sensitive configuration (DB creds, fernet key, webserver secret key)
- **IAM roles/policies** for ECS task execution and runtime permissions 
- **AWS KMS encryption** for data at rest (S3/EFS/RDS/Secrets where applicable)
- **Security groups** designed around “only what is needed” (ALB→ECS, ECS→RDS/EFS/Redis)
- **Terraform remote state** stored in **S3** (Terraform S3 backend)

## Security model (IAM, KMS, security groups)

### Public vs private subnets
Public subnets host the Application Load Balancer (ALB). A subnet is “public” because its route table sends `0.0.0.0/0` traffic to an Internet Gateway (IGW).       
                
Private subnets host the ECS Fargate tasks (Airflow components) plus RDS (PostgreSQL) and ElastiCache (Redis). These subnets don’t have a direct inbound route from the internet.  

### Inbound traffic 
1. The IGW provides a path for inbound internet traffic into the VPC.  
2. The ALB sits in public subnets and receives HTTP/HTTPS requests.  
3. The ALB forwards requests to the Airflow webserver service running on ECS Fargate in private subnets.  
4. ECS tasks aren’t publicly reachable — only the ALB can reach them.  

### Outbound traffic 
ECS tasks in private subnets sometimes need outbound access (e.g., pulling container images, calling external APIs).  
- Outbound access is provided via a NAT Gateway placed in a public subnet.  
- Private subnet route tables send `0.0.0.0/0` traffic to the NAT, which then egresses through the IGW.  

### IAM 
- ECS task execution role: allows ECS to pull images and write logs (for example, to CloudWatch).
- ECS task runtime role: scoped permissions for the running containers (for example, reading specific Secrets Manager secrets, accessing S3/EFS if required).  

### KMS (encryption at rest). 
KMS is used to encrypt data at rest where supported:  
- S3 (Terraform remote state) via SSE-KMS   
- Secrets Manager  
- EFS encryption at rest  
- RDS PostgreSQL encryption at rest      
- ElastiCache encryption at rest / in transit       






