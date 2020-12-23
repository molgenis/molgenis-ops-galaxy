# MOLGENIS Galaxy suite
We support galaxy collections for several services that the MOLGENIS suite provide. 
## Usage
We have several services deployed at the moment. The detail instructions to deploy the services are on galaxy:
- [MOLGENIS](https://galaxy.ansible.com/molgenis/molgenis8)
- [Armadillo](https://galaxy.ansible.com/molgenis/armadillo1)
## Development
When you want to contribute on the galaxy collections please be aware of the following contribution guide lines.
### Naming convention
Each playbook needs to adhere to the following name convention:
<letter>_<optional_version_restrictions>_<explanary_name>.yml

The first part is a single letter that indicates the playbooks use:
- e stands for extra add-on playbook that extends the default image with non default features (like extra domain names and corresponding SSL certificates)
- i stands for initial install playbook that sets up a working MOLGENIS server from a empty CENTOS 6 image
- s stands for single task playbook
- r stands for report playbook
- v stands for validation playbook that does not change a thing, it only reports on the state of a VM image and give no output unless something is wrong.
### Ansible Galaxy
Developing on the MOLGENIS and Armadillo collection using Ansible Galaxy requires the ansible-galaxy program. It is installed when you install ansible on your system.

You can locally build your collection using:

`ansible-galaxy collection build`

You can locally install the collection by executing:

`ansible-galaxy collection install -f molgenis-armadillo-x.x.x.tar.gz`

When you are satifisfied you can publish your collection using

`ansible-galaxy collection publish *.tar.gz`
### Best practices
- Please enforce [idempotancy](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html)
- A playbook should give no output if "ok"
- Use [ansible-lint](https://ansible-lint.readthedocs.io/en/latest) to check the styling
- Create valid playbooks for all major components of the software stack


