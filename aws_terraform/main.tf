#--------------------------------------------------------------------
# This module creates all resources required for base OS for Ansible.
# Ansible then provisions LoraServer on the setup.
#--------------------------------------------------------------------

resource "aws_key_pair" "aws-ssh-key" {
  key_name   = "aws-ssh-key"
  public_key = "${var.ssh_public_key}"
}

resource "aws_security_group" "loraserver_security_group" {
  name        = "${var.name}"
  description = "Security Group for LoraServer"
  vpc_id      = "${aws_vpc.loraserver_vpc_main.id}"

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1700
    to_port     = 1700
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1883
    to_port     = 1883
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}"
  }
}

resource "aws_vpc" "loraserver_vpc_main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}_vpc_main"
  }
}

# Public subnet for internet-connection
resource "aws_subnet" "loraserver_subnet_public_1_ca_central_1a" {
  vpc_id                  = "${aws_vpc.loraserver_vpc_main.id}"
  count                   = "${length(split(",", var.private_subnets))}"
  cidr_block              = "${element(split(",", var.private_subnets), count.index)}"
  map_public_ip_on_launch = true

  availability_zone = "${element(split(",", var.availability_zones), count.index)}"

  tags = {
    Name = "${var.name}_${element(split(",", var.availability_zones), count.index)}"
  }
}

resource "aws_internet_gateway" "loraserver_gw_main" {
  vpc_id = "${aws_vpc.loraserver_vpc_main.id}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_route" "loraserver_internet_access" {
  route_table_id         = "${aws_vpc.loraserver_vpc_main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.loraserver_gw_main.id}"
}

resource "aws_eip" "loraserver_eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.loraserver_gw_main"]
}

resource "aws_nat_gateway" "loraserver_nat" {
  allocation_id = "${aws_eip.loraserver_eip.id}"
  subnet_id     = "${element(aws_subnet.loraserver_subnet_public_1_ca_central_1a.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.loraserver_gw_main"]
}

# Route-Table entries
resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.loraserver_vpc_main.id}"

  tags {
    Name = "private-route-table"
  }
}

# Add entries to route-table
resource "aws_route" "private_route" {
  route_table_id         = "${aws_route_table.private_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.loraserver_nat.id}"
}

# Associate subnet loraserver_subnet_public_1_ca_central_1a to public route table
resource "aws_route_table_association" "loraserver_subnet_public_1_ca_central_1a_association" {
  subnet_id      = "${element(aws_subnet.loraserver_subnet_public_1_ca_central_1a.*.id, count.index)}"
  route_table_id = "${aws_vpc.loraserver_vpc_main.main_route_table_id}"
}

# Create EC2 Instance
resource "aws_instance" "loraserver" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  associate_public_ip_address = "true"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.aws-ssh-key.key_name}"
  subnet_id                   = "${aws_subnet.loraserver_subnet_public_1_ca_central_1a.id}"
  vpc_security_group_ids      = ["${aws_security_group.loraserver_security_group.id}"]

  provisioner "remote-exec" {
    inline = "${var.bootstrap_file_path}"

    connection {
      user        = "${var.ssh_remote_user}"
      private_key = "${var.ssh_private_key}"
    }
  }

  # Provision further using Ansible
  provisioner "local-exec" {
    command = <<EOF
    cd ansible
    ansible-playbook loraserver.yml -e ansible_host=${self.public_ip} -vvv
    EOF
  }

  tags {
    Name = "${var.name}"
  }
}

output "public_ips" {
  value = "${join(",", aws_instance.loraserver.*.public_ip)}"
}

output "private_ips" {
  value = "${join(",", aws_instance.loraserver.*.private_ip)}"
}
