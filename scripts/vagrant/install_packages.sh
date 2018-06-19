TERRAFORM_VERSION=0.11.7

# Package Repositories
sudo apt-add-repository ppa:deadsnakes/ppa -y
sudo apt-add-repository ppa:ansible/ansible

sudo apt-get update
sudo apt-get install -y ansible \
                        python3.7 \
                        unzip

# Install Terraform
wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/

rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
