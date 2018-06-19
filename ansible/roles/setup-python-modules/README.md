Run-Docker-Containers
=========

This role Installs PIP3 and necessary Python modules.

Requirements
------------

The following packages must be installed in remote host:
Python3

Role Variables
--------------

None.

Dependencies
------------

None.

Example Playbook
----------------

```yaml
- name: Setup python and python-modules
  hosts: test-host
  become: true
  roles:
    - setup-python-modules
```

License
-------

WTFPL

Author Information
------------------

Jaskaranbir Dhillon - Some random developer guy.
