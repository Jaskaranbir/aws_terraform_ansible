AWS-Docker provisioning using Terraform and Ansible
===================================================

## Tools and Usage:

* **Vagrant**: Initialize a development VM with pre-installed required components (Ansible, Python, Terraform etc.).

* **Terraform**: Provision AWS components such as EC2 instances, security-groups, VPCs, subnets, route-tables, internet-gateway etc.

* **Ansible**: Provision the EC2 instance (setup Docker/Docker-Compose, run Docker containers, install required packages etc.).

* **Docker/Docker-Compose**: Actually running the application. In this case, we are deploying a loraserver.

#### Note: It is recommended to familiarize yourself with Ansible, Terraform, Docker, and Docker-Compose to (at least) a basic level (if you plan on developing using this code-base).

## Setup local environment

### Using Vagrant and Virtualbox

* First, generate an SSH key pair, and name the key-pair as "aws-ssh-key" (or edit the configuration files and replace this with whatever name you prefer).  
These key (private and public SSH keys) should be present in the root of this project before you begin the development.  
Also, if you are using Linux, **make sure that the private key (`aws-ssh-key`) has permissions set to 400**.
* Install Vagrant and VirtualBox in your system, and then run `vagrant up` in the root directory of this project.  
* This will provision a VM with all the required tools pre-installed.

* Then you can just SSH into VM using `vagrant ssh` and continue the development from within VM.

### Manually setting up the environment (no VM)

Install the following on your system:

Ansible  
Python  
Terraform

And to locally test your application (your host needs to be Linux, else use VM), install:  
Docker  
Docker-Compose

## How to provision

* In project directory, initialize Terraform:  
`terraform init`

* You'll have to edit Terraform and Ansible variables (all Terraform variables are defined under `terraform.tfvars`, and all Ansible variables are defined under `group_vars` and `host_vars`).
  - Begin by copying/renaming `terraform.tfvars.sample` to `terraform.tfavars`, and `ansible/host_vars/aws-loraserver.sample` to `ansible/host_vars/aws-loraserver`. You will have to edit the required variables in both files.
  - This will require you to add your AWS access key and secret key to Terraform variables.
  - You will also have to generate an SSH keypair, and add the private/public keys as required to both Terraform and Ansible.

 * To test if the Terraform and Ansible can connect to your AWS account successfully, run `terraform plan` in the project-root directory, and run `ansible all -m ping` in `ansible` directory.  
Both should succeed without errors.

* You might wanna review the changes that will be made to your provider. You can do that using:  
`terraform plan`

* Finally, when the changes are as required, apply the changes:
  `terraform apply`
