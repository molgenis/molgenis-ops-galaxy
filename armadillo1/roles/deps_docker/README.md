Docker
=========
This installs the Docker on your system. This allows you to run Rserver and or the Authentication service on the system.

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-deps_docker-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo/)

Requirements
------------
The only requirement you need a clean base image of Debian >= 10 or Ubuntu >= 20.

Role Variables
--------------
No variables are needed for this role.

Dependencies
------------
No direct dependencies for this role.

Example Playbook
----------------
You can include the deps_docker-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: deps_docker
                   
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org