# Usage

### Make sure you have ansible installed on the machine

## With inline module

### `ansible all -i inventory -m user -a "name=testUser shell=/bin/bash"`

## With playbook (for multiple modules)

### `ansible-playbook -i inventory {ansible-playbook-file.yml}`
