Run-Docker-Containers
=========

This role copies and runs the Docker-Container definitions on remote host.

Requirements
------------

The following packages must be installed in remote host:  
Python3  
Docker  
Docker-Compose

Role Variables
--------------

*docker_container_definitions_remote_location*: Location on remote host where Docker-Container definition-files should be copied.  

Dependencies
------------

* bootstrap/setup-docker

Example Playbook
----------------

```yaml
- name: Copy Docker-Container definitions like there's no tomorrow
  copy:
    src: "{{ playbook_dir }}/docker"
    dest: "{{ docker_container_definitions_remote_location }}"
```

License
-------

WTFPL

Author Information
------------------

Jaskaranbir Dhillon - Some random developer guy.
