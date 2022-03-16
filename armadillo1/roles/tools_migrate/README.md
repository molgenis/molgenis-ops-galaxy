Migration Opal workspaces
=========
This script will migrate Opal user workspaces to Armadillo user workspaces. Run this by executing the following playbook: `pb_migrate-workspaces.yml`. Check the full documentation here: https://github.com/molgenis/molgenis-ops-galaxy/blob/main/armadillo1/docs/MIGRATION.md.

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-tools_migrate-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo/)

Requirements
------------
The only requirement you need a clean base image of CentOS or Redhat => 7, Debian >= 10 or Ubuntu >= 20.04.

Role Variables
--------------
| Variable  | Required | Default | Choices  | Comments                                          |
|-----------|----------|---------|----------|---------------------------------------------------|
| users     | yes      | na      | na       | Specify an array of source users and target_users |

Dependencies
------------
No direct dependencies for this role

Example Playbook
----------------
You can include the tools_migrate-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: tools_migrate
         vars:
           users:
             - { source_user: "firstname.givenname", target_user: "user-abcde" }
                   
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org