Assemble
=========
This installs the docker-compose.yml which ties all the services together. It configures the dependencies and makes sure the services restart automatically.

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-post_assemble-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo/)

Requirements
------------
The only requirement you need a clean base image of CentOS or Redhat => 7, Debian >= 10 or Ubuntu >= 20.04.

Role Variables
--------------
No variables are needed for this role.

Dependencies
------------
No direct dependencies for this role

Example Playbook
----------------
You can include the post_assemble-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: post_assemble
                   
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org