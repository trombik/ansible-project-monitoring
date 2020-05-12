# `trombik.sensu_go_backend`

[![Build Status](https://travis-ci.com/trombik/ansible-role-sensu_go_backend.svg?branch=master)](https://travis-ci.com/trombik/ansible-role-sensu_go_backend)

`ansible` role for `sensu-go` version of `sensu-backend`.

## Notes for users

This role uses [`sensu-go` `ansible` collection](https://sensu.github.io/sensu-go-ansible/). The collection must be
installed by `ansible-galaxy`.

```yaml
---
# requirements.yml

collections:
  - name: sensu.sensu_go
```

```console
> ansible-galaxy collection install -r requirements.yml -p collections
```

## Notes for FreeBSD users

As of this writing (2020/04/16), the official FreeBSD ports tree does not have
the latest version of `sensu-go`. The available version of the port does not
install `sensu-backend`. You have to fix the port yourself, or install my port
from
[freebsd-ports-sensu-go](https://github.com/trombik/freebsd-ports-sensu-go),
and place the package somewhere.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `sensu_go_backend_user` | user of `sensu-backend` | `{{ __sensu_go_backend_user }}` |
| `sensu_go_backend_group` | group of `sensu-backend` | `{{ __sensu_go_backend_group }}` |
| `sensu_go_backend_package` | package name of `sensu-backend` | `{{ __sensu_go_backend_package }}` |
| `sensu_go_backend_extra_packages` | list of extra packages to install | `{{ __sensu_go_backend_extra_packages }}` |
| `sensu_go_backend_log_dir` | path to log directory | `/var/log/sensu` |
| `sensu_go_backend_state_dir` | path to `state-dir` | `{{ __sensu_go_backend_state_dir }}` |
| `sensu_go_backend_cache_dir` | path of `cache-dir` | `{{ __sensu_go_backend_cache_dir }}` |
| `sensu_go_backend_service` | service name of `sensu-backend` | `{{ __sensu_go_backend_service }}` |
| `sensu_go_backend_conf_dir` | path to base directory of `sensu_go_backend_conf_file` | `{{ __sensu_go_backend_conf_dir }}` |
| `sensu_go_backend_conf_file` | path to `sensu-backend.yml` | `{{ sensu_go_backend_conf_dir }}/sensu-backend.yml` |
| `sensu_go_backend_config` | content of `sensu-backend.yml` | `""` |
| `sensu_go_backend_flags` | see below | `""` |
| `sensu_go_backend_admin_account` | name of admin account | `""` |
| `sensu_go_backend_admin_password` | password of admin account | `""` |
| `sensu_go_backend_flush_handlers` | if true, run `meta` `ansible` action during the play | `true` |
| `sensu_go_backend_assets` | list of `sensu-go` `asset` (see below) | `[]` |
| `sensu_go_backend_checks` | list of `sense-go` `check` (see below) | `[]` |

## `sensu_go_backend_flags`

This variable is used to configure startup options for the service. What it
does depends on platform.

## `sensu_go_backend_assets`

This is a list of dict. The dict requires the following keys and values.

| Key | Description | Mandatory? |
|-----|-------------|------------|
| `asset` | a dict of arguments passed to `asset` module in [`sensu-go` `ansible` collection](https://sensu.github.io/sensu-go-ansible/). | yes |

## `sensu_go_backend_checks`

This is a list of dict. The dict requires the following keys and values.

| Key | Description | Mandatory? |
|-----|-------------|------------|
| `check` | a dict of arguments passed to `check` module in [`sensu-go` `ansible` collection](https://sensu.github.io/sensu-go-ansible/). | yes |


### FreeBSD

`sensu_go_backend_flags` is the content of `/etc/rc.conf.d/sensu_backend`.

### Debian

`sensu_go_backend_flags` is the content of `/etc/default/sensu-backend`.

### RedHat

`sensu_go_backend_flags` is the content of `/etc/sysconfig/sensu-backend`.

## Debian

| Variable | Default |
|----------|---------|
| `__sensu_go_backend_user` | `sensu` |
| `__sensu_go_backend_group` | `sensu` |
| `__sensu_go_backend_package` | `sensu-go-backend` |
| `__sensu_go_backend_extra_packages` | `[]` |
| `__sensu_go_backend_state_dir` | `/var/lib/sensu/sensu-backend` |
| `__sensu_go_backend_cache_dir` | `/var/cache/sensu/sensu-backend` |
| `__sensu_go_backend_service` | `sensu-backend` |
| `__sensu_go_backend_conf_dir` | `/etc/sensu` |
| `__sensu_go_backend_conf_file` | `{{ __sensu_go_backend_conf_dir }}/backend.yml` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__sensu_go_backend_user` | `sensu` |
| `__sensu_go_backend_group` | `sensu` |
| `__sensu_go_backend_package` | `sysutils/sensu-go-backend` |
| `__sensu_go_backend_extra_packages` | `[]` |
| `__sensu_go_backend_state_dir` | `/var/db/sensu/sensu-backend` |
| `__sensu_go_backend_cache_dir` | `/var/cache/sensu/sensu-backend` |
| `__sensu_go_backend_service` | `sensu-backend` |
| `__sensu_go_backend_conf_dir` | `/usr/local/etc` |
| `__sensu_go_backend_conf_file` | `{{ __sensu_go_backend_conf_dir }}/sensu-backend.yml` |

## RedHat

| Variable | Default |
|----------|---------|
| `__sensu_go_backend_user` | `sensu` |
| `__sensu_go_backend_group` | `sensu` |
| `__sensu_go_backend_package` | `sensu-go-backend` |
| `__sensu_go_backend_extra_packages` | `[]` |
| `__sensu_go_backend_state_dir` | `/var/lib/sensu/sensu-backend` |
| `__sensu_go_backend_cache_dir` | `/var/cache/sensu/sensu-backend` |
| `__sensu_go_backend_service` | `sensu-backend` |
| `__sensu_go_backend_conf_dir` | `/etc/sensu` |
| `__sensu_go_backend_conf_file` | `{{ __sensu_go_backend_conf_dir }}/backend.yml` |

# Dependencies

[`sensu-go` `ansible` collection](https://sensu.github.io/sensu-go-ansible/)

# Example Playbook

```yaml
---
- hosts: localhost
  roles:
    - role: trombik.freebsd_pkg_repo
      when: ansible_os_family == 'FreeBSD'
    - role: trombik.apt_repo
      when: ansible_os_family == 'Debian'
    - role: trombik.redhat_repo
      when: ansible_os_family == 'RedHat'

    - role: trombik.sensu_go_agent
    - role: ansible-role-sensu_go_backend
  vars:

    # __________________________________________agent
    sensu_go_agent_config:
      backend-url: ws://localhost:8081
      cache-dir: "{{ sensu_go_agent_cache_dir }}"
      subscriptions:
        - system

    os_sensu_go_agent_flags:
      FreeBSD: ""
      Debian: ""
      RedHat: ""
    sensu_go_agent_flags: "{{ os_sensu_go_agent_flags[ansible_os_family] }}"

    # __________________________________________backend
    os_sensu_go_backend_extra_packages:
      FreeBSD: sysutils/sensu-go-cli
      Debian: sensu-go-cli
      RedHat: sensu-go-cli
    sensu_go_backend_extra_packages: "{{ os_sensu_go_backend_extra_packages[ansible_os_family] }}"
    sensu_go_backend_admin_account: admin
    sensu_go_backend_admin_password: P@ssw0rd!
    sensu_go_backend_config:
      state-dir: "{{ sensu_go_backend_state_dir }}"
      cache-dir: "{{ sensu_go_backend_cache_dir }}"
      log-level: debug
      agent-host: "[::]"
      api-listen-address: "[::]:8080"
      dashboard-host: "[::]"
      dashboard-port: 3000

    os_sensu_go_backend_flags:
      FreeBSD: ""
      Debian: ""
      RedHat: ""
    sensu_go_backend_flags: "{{ os_sensu_go_backend_flags[ansible_os_family] }}"
    sensu_go_backend_checks:
      - check:
          name: check
          command: sensu-go-uptime-check -w 72h -c 168h
          subscriptions:
            - system
          interval: 60
          publish: yes
          runtime_assets:
            - sensu-go-uptime-check
    sensu_go_backend_assets:
      - asset:
          name: sensu-go-uptime-check
          auth:
            user: "{{ sensu_go_backend_admin_account }}"
            password: "{{ sensu_go_backend_admin_password }}"
          builds:
            - sha512: 30d7ac78e314e83558891b6115b18d7f89d129f9d7e163af254e8f8e3a45f7b51efe648c45c827426b8be273974c3f63b934afb946a989cbdf11e5f576537b2b
              filters:
                - entity.system.os == 'freebsd'
                - entity.system.arch == 'amd64'
              url: https://github.com/asachs01/sensu-go-uptime-check/releases/download/1.0.2/sensu-go-uptime-check_1.0.2_freebsd_amd64.tar.gz

    # __________________________________________package
    freebsd_pkg_repo:

      # disable the default package repository
      FreeBSD:
        enabled: "false"
        state: present

      # enable my own package repository, where the latest package is
      # available
      FreeBSD_devel:
        enabled: "true"
        state: present
        url: "http://pkg.i.trombik.org/{{ ansible_distribution_version | regex_replace('\\.', '') }}{{ansible_architecture}}-default-default/"
        mirror_type: http
        signature_type: none
        priority: 100

    # see https://packagecloud.io/install/repositories/sensu/stable/script.deb.sh
    apt_repo_keys_to_add:
      - https://packagecloud.io/sensu/stable/gpgkey
    apt_repo_to_add:
      - deb https://packagecloud.io/sensu/stable/ubuntu/ bionic main
    apt_repo_enable_apt_transport_https: True

    redhat_repo_extra_packages:
      - epel-release

    # see https://packagecloud.io/install/repositories/sensu/stable/config_file.repo?os=centos&dist=7&source=script
    redhat_repo:
      sensu:
        baseurl: "https://packagecloud.io/sensu/stable/el/{{ ansible_distribution_major_version }}/$basearch"

        # Package sensu-go-cli-5.19.1-10989.x86_64.rpm is not signed
        gpgcheck: no
        enabled: yes
      epel:
        mirrorlist: "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-{{ ansible_distribution_major_version }}&arch={{ ansible_architecture }}"
        gpgcheck: yes
        enabled: yes
```

# License

```
Copyright (c) 2020 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [qansible](https://github.com/trombik/qansible)
