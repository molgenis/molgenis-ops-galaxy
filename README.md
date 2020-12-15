MOLGENIS Galaxy suite
We support galaxy collections for several services that the MOLGENIS suite provide. 

## Usage
We have several services deployed at the moment. The detail instructions to deploy the services are on galaxy:
- [MOLGENIS](https://galaxy.ansible.com/molgenis/molgenis8)

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
- v stands for validation playbook that does not change a thing, it only reports on the state of a VM image and give no output unless something is wrong

### Best practices
- Please enforce [idempotancy](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html)
- A playbook should give no output if "ok"
- Use [ansible-lint](https://ansible-lint.readthedocs.io/en/latest) to check the styling
- Create valid playbooks for all major components of the software stack


