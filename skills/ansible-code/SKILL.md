---
name: ansible-code
description: Ansible playbook and role production — idempotency, structure, and testing
license: MIT
compatibility: opencode
metadata:
  language: ansible
---

# Ansible Coding Standards

Strong defaults, not rigid rules. Use engineering judgement where context warrants it.

## Strong Defaults

1. **Every task must be idempotent.** Running it twice produces the same state. This is a hard requirement.

2. **Use module-native idempotency** — `state: present/absent`, `lineinfile`, `template`, `copy`, `systemd_service`. Not `command`/`shell`.

3. **When `command`/`shell` is unavoidable, add explicit `changed_when` and `failed_when`.** Never assume a shell command's exit code means "changed".

4. **Every task gets a clear `name:` that explains the intent.** Not just the module name.

5. **Use `become: true` only where elevated privileges are required.** Not globally.

6. **Store variables in `defaults/` or `vars/`.** Never inline magic values. Never put secrets in `defaults/` — use `ansible-vault`.

7. **Use `handlers:` for service restarts and one-time reactions.** Notify from tasks; do not inline restarts.

8. **Use `tags:` where they support meaningful operational workflows** — deployment stages, OS families, maintenance activities. Not every task needs a tag.

9. **Use the standard role layout** — `tasks/`, `handlers/`, `templates/`, `files/`, `vars/`, `defaults/`, `meta/`. Templates end in `.j2`.

10. **Run `ansible-playbook --syntax-check` and `ansible-lint` before reporting done.** Fix genuine problems; document justified exceptions where necessary. For tasks that change production or OT systems, make the expected impact and rollback procedure explicit.

## Verification Order

1. Syntax: `ansible-playbook --syntax-check playbook.yml`
2. Lint: `ansible-lint playbook.yml`
3. Dry-run: `ansible-playbook --check --diff playbook.yml`
4. Test: `molecule test` for role changes
5. Idempotency: run twice, confirm no changes on second run
