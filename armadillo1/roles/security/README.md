Security
=========
Configures some default security best practices such as diabling password authentication.

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-security-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo1/)

Requirements
------------
The only requirement you need a clean base image of CentOS >= 7.x or >= 8.x, Ubuntu >= 20.x or Debian >= 10.x.

Role Variables
--------------
| Variable              | Required | Default                           | Choices  | Comments                                                                                                                         |
|-----------------------|----------|-----------------------------------|----------| -------------------------------------------------------------------------------------------------------------------------------- | 
| enabled               | yes      | 2020-11-12T22-33-34Z              | na       | Security role is ment for server which are not part of IT infrastrucyure of the institute for example external hosting providers |


Dependencies
------------
No direct dependencies for this role

Example Playbook
----------------
You can include the security-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: security
         vars:
           enabled: true
                   
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org