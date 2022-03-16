Upgrade
=========
This install a scrips which is run in cron every week and will pull the newest images and stops and starts the stack.

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-tools_upgrade-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo/)

Requirements
------------
The only requirement you need a clean base image of CentOS or Redhat => 7, Debian >= 10 or Ubuntu >= 20.04.

Role Variables
--------------
| Variable  | Required | Default | Choices    | Comments                                                                |
|-----------|----------|---------|------------|-------------------------------------------------------------------------|
| enabled   | yes      | true    | true/false | Update each Sunday based upon the major tag of the analysis environment |

Dependencies
------------
No direct dependencies for this role

Example Playbook
----------------
You can include the tools_upgrade-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: tools_upgrade
         vars:
           enabled: true
                   
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org