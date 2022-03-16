Compose
=========
This installs the docker-compose or podman-compose to run the Armadillo stack

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-deps_compose-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo/)

Requirements
------------
The only requirement you need a clean base image of Centos or Redhat >= 7, Debian >= 10 or Ubuntu >= 20.

Role Variables
--------------
No variables are needed for this role.

Dependencies
------------
No direct dependencies for this role.

Example Playbook
----------------
You can include the deps_compose-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: deps_compose
                   
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org