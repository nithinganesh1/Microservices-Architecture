# Microservices Architecture on AWS with Kubernetes, Terraform, and Prometheus

This project demonstrates the implementation of a highly available and scalable microservices architecture on AWS. It uses Kubernetes for orchestration, Terraform for infrastructure provisioning, Jenkins for CI/CD, and Prometheus/Grafana for monitoring. The architecture supports blue/green deployments and autoscaling for high availability and reliability.

---

## Table of Contents
1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Pipeline Steps](#pipeline-steps)
4. [Blue-Green Deployment](#blue-green-deployment)
5. [Technologies Used](#technologies-used)
6. [Setup Instructions](#setup-instructions)
7. [Key Features](#key-features)
8. [Repository Structure](#repository-structure)

---

## Overview
This project implements a microservices architecture for an e-commerce application. It provisions AWS infrastructure using Terraform and orchestrates multiple microservices with Kubernetes. Continuous deployment is achieved using Jenkins pipelines, and application health is monitored with Prometheus and Grafana. Blue/green deployments are implemented for seamless updates without downtime.

---

## Requirements
- **Terraform**: Provisions AWS infrastructure, including VPC, subnets, security groups, and EKS cluster.
- **Kubernetes**: Orchestrates microservices and handles load balancing and service discovery.
- **Jenkins**: Automates the CI/CD pipeline.
- **Prometheus and Grafana**: Monitors system performance and health.
- **Docker**: Containerizes microservices.
- **AWS**: Provides cloud infrastructure for high availability and scalability.

---

## Pipeline Steps

### 1. Clone Repository
Pulls the latest code from the GitHub repository.
```groovy
stage('Clone') {
    steps {
        git url: 'https://github.com/nithinganesh1/Microservices-Architecture.git', branch: 'main'
    }
}
```

### 2. Docker Build
Builds Docker images for the microservices.
```groovy
stage('Docker Build') {
    steps {
        script {
            sh "docker build -f docker/docker-auth -t authimg ."
            sh "docker build -f docker/docker-order -t orderimg ."
            sh "docker build -f docker/docker-product -t productimg ."
        }
    }
}
```

### 3. Tag and Push Docker Images
Tags and pushes the Docker images to Docker Hub.
```groovy
stage('Tag and Push Docker Images') {
    steps {
        script {
            sh "docker tag productimg:latest nithingganesh/productimg:latest"
            sh "docker tag orderimg:latest nithingganesh/orderimg:latest"
            sh "docker tag authimg:latest nithingganesh/authimg:latest"

            sh "docker push nithingganesh/productimg:latest"
            sh "docker push nithingganesh/orderimg:latest"
            sh "docker push nithingganesh/authimg:latest"
        }
    }
}
```

### 4. Deploy Microservices with Blue-Green Deployment
Deploys both blue and green versions of each service and configures traffic switching.

#### Auth Service
```groovy
stage('Deploy Blue-Green for authservice') {
    steps {
        script {
            sh "kubectl apply -f k8s/auth_deployment_blue.yaml --namespace p3"
            sh "kubectl apply -f k8s/auth_deployment_green.yaml --namespace p3"
            sh "kubectl apply -f k8s/auth_service.yaml --namespace p3"
        }
    }
}
```

#### Order Service
```groovy
stage('Deploy Blue-Green for orderservice') {
    steps {
        script {
            sh "kubectl apply -f k8s/order_deployment_blue.yaml --namespace p3"
            sh "kubectl apply -f k8s/order_deployment_green.yaml --namespace p3"
            sh "kubectl apply -f k8s/order_service.yaml --namespace p3"
        }
    }
}
```

#### Product Service
```groovy
stage('Deploy Blue-Green for productservice') {
    steps {
        script {
            sh "kubectl apply -f k8s/product_deployment_blue.yaml --namespace p3"
            sh "kubectl apply -f k8s/product_deployment_green.yaml --namespace p3"
            sh "kubectl apply -f k8s/product_service.yaml --namespace p3"
        }
    }
}
```

### 5. Restart Deployments
Optionally restarts deployments after traffic switch.
```groovy
stage('Restart Deployments') {
    steps {
        script {
            sh "kubectl rollout restart deployment authservice --namespace p3"
            sh "kubectl rollout restart deployment orderservice --namespace p3"
            sh "kubectl rollout restart deployment productservice --namespace p3"
        }
    }
}
```

---

## Blue-Green Deployment
Blue-green deployment minimizes downtime during updates by maintaining two separate environments (blue and green). Traffic can be switched between these environments using Kubernetes services, ensuring smooth transitions and rollback capabilities if needed.

---

## Technologies Used
- **Terraform**: Infrastructure provisioning.
- **Kubernetes**: Container orchestration and service discovery.
- **Jenkins**: CI/CD automation.
- **Prometheus and Grafana**: Performance monitoring.
- **Docker**: Containerization.
- **AWS**: Cloud infrastructure (EKS, VPC, etc.).

---

## Setup Instructions

### Prerequisites
- Install Docker, Kubernetes (kubectl), Jenkins, Terraform, and AWS CLI.
- Configure AWS credentials for Terraform and EKS access.
- Deploy Prometheus and Grafana in the Kubernetes cluster.

### Terraform Setup
- Use the Terraform scripts to provision the AWS infrastructure.

### Jenkins Setup
- Create a Jenkins pipeline and paste the provided Groovy script.
- Configure credentials for Docker Hub and AWS.

### Kubernetes Setup
- Deploy Kubernetes manifests for blue/green deployments.
- Configure Ingress for service discovery and load balancing.

---

## Key Features
- **Highly Available Microservices**: Deployed on AWS EKS with autoscaling.
- **Blue/Green Deployments**: Ensures zero downtime during updates.
- **Scalable Architecture**: Handles dynamic workloads.
- **Continuous Deployment**: Automates the build, test, and deployment process.
- **Monitoring and Alerts**: Tracks application performance with Prometheus and Grafana.
- **Secure Deployment**: Implements IAM roles, network policies, and secrets management.

---

## Repository Structure
```
Microservices-Architecture
├── docker
│   ├── docker-auth
│   ├── docker-order
│   └── docker-product
├── k8s
│   ├── auth_deployment_blue.yaml
│   ├── auth_deployment_green.yaml
│   ├── auth_service.yaml
│   ├── order_deployment_blue.yaml
│   ├── order_deployment_green.yaml
│   ├── order_service.yaml
│   ├── product_deployment_blue.yaml
│   ├── product_deployment_green.yaml
│   └── product_service.yaml
└── Jenkinsfile
```

---

## Contributors
- [nithingganesh](https://github.com/nithinganesh1)

