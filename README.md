# IaC Microservices Deployment


## Introduction

This project is for learning purposes, in order to compare the level of complexity of the code when:
- deploying a microservice infrastructure **locally** versus **on the Cloud**;
- deploying a microservice infrastructure **without Kubernetes** versus **with Kubernetes**.

There are therefore four microservice infrastructures which will be deployed and compared:
- [Local infrastructure without Kubernetes](/local-installation/without-kubernetes/);
- [Local infrastructure with Kubernetes](/local-installation/with-kubernetes/);
- [Cloud infrastructure without Kubernetes](/cloud-installation/without-kubernetes/);
- [Cloud infrastructure with Kubernetes](/cloud-installation/with-kubernetes/).

MySQL and phpMyAdmin microservices will be deployed into the infrastructure to verify that:
- The infrastructure deployment is functional;
- The microservices manage to interact together.

All these infrastructures will be deployed using **Infrastructure as Code**.

## Tools used

### Cloud
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)

### Microservices
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)

### Infrastructure as Code
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)
![Vagrant](https://img.shields.io/badge/vagrant-%231563FF.svg?style=for-the-badge&logo=vagrant&logoColor=white)
