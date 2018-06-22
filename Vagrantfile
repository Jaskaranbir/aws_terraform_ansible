# -*- mode: ruby -*-
# vi: set ft=ruby :

plugin_dependencies = [
  "vagrant-docker-compose",
  "vagrant-host-shell",
  "vagrant-vbguest"
]

# Paths inside VM. Changing these will NOT change the actual path.
$home_path = "/home/vagrant"
$tmp_files_path = "/var/tmp"

needsRestart = false

# Install plugins if required
plugin_dependencies.each do |plugin_name|
  unless Vagrant.has_plugin? plugin_name
    system("vagrant plugin install #{plugin_name}")
    needsRestart = true
    puts "#{plugin_name} installed"
  end
end

# Restart vagrant if new plugins were installed
if needsRestart === true
  exec "vagrant #{ARGV.join(' ')}"
end

Vagrant.configure(2) do |config|
  config.vm.define :loravm do |loravm|
    loravm.vm.hostname = "lora"
    loravm.vm.box = "bento/ubuntu-16.04"

    loravm.vm.provider :virtualbox do |vb|
      vb.name = "lora_vm"
      vb.gui = false
      vb.memory = "1024"
      vb.cpus = 2

      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end

    loravm.vm.network :forwarded_port,
        guest: 8080,
        host: 8080,
        auto_correct: true

    # Run as non-login shell, sourcing it to /etc/profile instead of /root/.profile
    # Due to clashing configurations for vagrant and base box.
    # See: https://github.com/mitchellh/vagrant/issues/1673#issuecomment-28288042
    loravm.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # Automatically run during vagrant-vbguest install
    # Otherwise uncomment and run manually
    # loravm.vm.provision :shell, inline: "apt-get update"

    # Automatically set current-dir to /vagrant on vagrant ssh
    loravm.vm.provision :shell,
        inline: "echo 'cd /vagrant' >> /home/vagrant/.bashrc"

    # Copy loraserver ssh key to home directory in Vagrant
    # This is required because AWS doesn't accept keys whose
    # permissions are not 400. Shared folders in Windows/Vagrant
    # do not allow for the correct 400 permission.
    # We copy to temporary directory first since SCP doesn't support
    # "sudo" mode, and is unable to overwrite already existing file
    # with "400" permissions.
    loravm.vm.provision "file",
        source: "aws-ssh-key",
        destination: "#{$tmp_files_path}/aws-ssh-key"
    loravm.vm.provision :shell,
        inline: "cp #{$tmp_files_path}/aws-ssh-key #{$home_path}/.ssh/aws-ssh-key"
    loravm.vm.provision :shell,
        inline: "chmod 400 #{$home_path}/.ssh/aws-ssh-key"
    loravm.vm.provision :shell,
        inline: "rm #{$tmp_files_path}/aws-ssh-key"

    # When running "terraform init", Terraform will create symlinks
    # to modules inside its init directory. Since VirtualBox symlinks
    # are not supported on shared directories, this will fail with error.
    # So we create a directory for terraform elsewhere, and mount it
    # on top of our shared directory to get past this issue.
    loravm.vm.provision :shell,
        inline: "mkdir -p #{$home_path}/.terraform_vagrant",
        privileged: false
    loravm.vm.provision :shell,
        inline: "mkdir -p /vagrant/.terraform",
        privileged: false
    loravm.vm.provision :shell,
        inline: "mount --bind #{$home_path}/.terraform_vagrant /vagrant/.terraform",
        privileged: true,
        run: "always"

    loravm.vm.provision :shell,
        path: "scripts/vagrant/install_packages.sh",
        privileged: true

    # Setup docker/docker-compose and run docker-compose script
    loravm.vm.provision :docker
    loravm.vm.provision :docker_compose,
        compose_version: "1.21.2",
        project_name: "lora",
        yml: ["/vagrant/ansible/docker/docker-compose.yml"],
        # options: "--verbose",
        run: "always",
        # Comment out lines below to prevent rebuilding
        # Docker containers at every boot
        command_options: { build: "--force-rm" },
        rebuild: true

    loravm.vm.provision :shell,
        path: "scripts/vagrant/deploy-wait_message.sh",
        run: "always",
        privileged: false

    # This script tells you what address the application is hosted at
    # If everything was successfull
    loravm.vm.provision :host_shell,
        inline: "scripts/vagrant/post-deploy_message.sh",
        run: "always"
  end
end
