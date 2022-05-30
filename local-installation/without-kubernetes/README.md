## Infrastructure plan

(infrastructure_plan.png)


## Prerequisites

### Hardware requirements

RAM: 8 GB minimum | 16 GB recommended

Disk space: 50 GB

### Software requirements

Install [Vagrant](https://www.vagrantup.com/downloads) & [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)


## Commands

Provision Vagrant nodes and execute Ansible playbook:
```
vagrant up
```

## Verification

### From node 1

Connect to Vagrant node named **node1**:

`vagrant ssh node1`

Access to phpMyAdmin from 192.168.42.2:8080 :

`curl 192.168.42.2:8080`

### From node 2

Connect to Vagrant node named **node2**:

`vagrant ssh node2`

Access to phpMyAdmin from localhost:8080 :

`curl localhost:8080`


## Once finished

Destroy provisioned resources:
```
vagrant destroy
```
