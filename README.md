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


## Tools used

#### Cloud
- [AWS](https://aws.amazon.com/)

#### Microservices
- [Docker](https://www.docker.com/)
- [Kubernetes](https://kubernetes.io/)

#### Infrastructure as Code
- [Terraform](https://www.terraform.io/)
- [Ansible](https://www.ansible.com/)
- [Vagrant](https://www.vagrantup.com/)
