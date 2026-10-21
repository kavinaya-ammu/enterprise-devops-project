# Ansible

Run the non-mutating validation playbook:

```bash
ansible-playbook -i inventories/local.ini playbooks/validate-host.yml --check
```

`linux-baseline.yml` is an example for a separately defined `[linux]` inventory group and uses privilege escalation. Review target hosts and package policy before running. Store secrets with `ansible-vault`; never put passwords in plain-text inventories.
