Setup-Docker
=========

This role installs Docker and Docker-Compose.

Requirements
------------

The remote system should have Python3 installed (or change the host_vars accordingly).

Role Variables
--------------

*docker_compose_version*: Version of Docker-Compose to install.  
*docker_compose_install_location*: Location where docker-compose binary is downloaded.

Dependencies
------------

None

Example Playbook
----------------

```yaml
- name: Setup Docker and Docker-Compose
  hosts: test-host
  become: true
  roles:
    - roles/bootstrap/setup-docker
  tags:
    - docker
    - docker-compose
```

License
-------

WTFPL

Author Information
------------------

Jaskaranbir Dhillon - Some random developer guy.
