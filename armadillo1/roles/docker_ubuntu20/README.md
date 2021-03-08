Docker
=========
This installs the Docker on your system. This allows you to run Rserver on the system.

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-docker-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo1/)

Requirements
------------
The only requirement you need a clean base image of Ubuntu > 20.04.

Role Variables
--------------
No variables are needed for this role.

Dependencies
------------
No direct dependencies for this role

Example Playbook
----------------
You can include the podman-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: docker_ubuntu10
                   
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org