Cleanup version 1 environment
=========
This cleans up the version 1 environment so version 2 can be installed properly.

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-tools_cleanup-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo/)

Requirements
------------
The only requirement you need a clean base image of CentOS or Redhat => 7, Debian >= 10 or Ubuntu >= 20.04.

Role Variables
--------------


Dependencies
------------
No direct dependencies for this role

Example Playbook
----------------
You can include the tools_cleanup-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: tools_cleanup
                   
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org