---
name: idempotent-package-install
language: ansible
tags: [ansible, package, install, idempotent, apt, yum]
use-case: Install packages idempotently across Debian/RHEL
created: 2026-07-31
---

## Description

Installs system packages idempotently, detecting the package manager
(apt or yum) automatically. Runs cleanly multiple times without side
effects.

## Usage

Include the task list in a role's tasks/main.yml. Pass `packages` list
as a variable.

## Code

```yaml
---
- name: Install required packages
  ansible.builtin.package:
    name: "{{ item }}"
    state: present
  loop: "{{ packages }}"
  when: packages is defined
```

## Notes

- `ansible.builtin.package` abstracts apt/yum/dnf — no need for
  separate OS-family conditionals.
- Set `packages` in vars/ or group_vars/, not defaults/.
- For version pinning: `name: "{{ item.name }}={{ item.version }}"`.
