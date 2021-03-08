# MOLGENIS Galaxy suite
We support galaxy collections for several services that the MOLGENIS suite provide. 

## Usage
We have several services deployed at the moment. The detail instructions to deploy the services are on galaxy:
- [MOLGENIS](https://galaxy.ansible.com/molgenis/molgenis8)
- [Armadillo](https://galaxy.ansible.com/molgenis/armadillo1)

## Development
When you want to contribute on the galaxy collections please be aware of the following contribution guide lines.

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


