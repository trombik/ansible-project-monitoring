# `trombik.language_ruby`

Installs `ruby` and `gem`.

## Notes for Debian/Ubuntu

Use
[`ansible-role-apt-repo`](https://github.com/reallyenglish/ansible-role-apt-repo)
to install
[`ruby-ng`](https://launchpad.net/~brightbox/+archive/ubuntu/ruby-ng) PPA if
the version of the `ruby` is not in the apt repository.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `language_ruby_package` | package name of `ruby` | `{{ __language_ruby_package }}` |

## Debian

| Variable | Default |
|----------|---------|
| `__language_ruby_package` | `ruby` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__language_ruby_package` | `lang/ruby26` |


## OpenBSD

| Variable | Default |
|----------|---------|
| `__language_ruby_package` | `ruby%2.6` |

## RedHat

| Variable | Default |
|----------|---------|
| `__language_ruby_package` | `ruby` |

# Facts

The role sets `language_ruby_version` fact with the following keys when ruby
version is `2.3.4`:

| Key           | Value   |
|---------------|---------|
| `full`        | `2.3.4` |
| `short`       | `23`    |
| `major`       | `2`     |
|` minor`       | `3`     |
| `patch_level` | `4`     |

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-language-ruby
  vars:
    language_ruby_package: "{% if ansible_os_family == 'FreeBSD' %}lang/ruby24{% elif ansible_os_family == 'OpenBSD' %}ruby%2.3{% elif ansible_os_family == 'Debian' and ansible_distribution_release == 'trusty' %}ruby2.0{% elif ansible_os_family == 'Debian' and ansible_distribution_release == 'xenial' %}ruby2.3{% elif ansible_os_family == 'RedHat' %}ruby{% endif %}"
```

# License

```
Copyright (c) 2017 Tomoyuki Sakurai <y@trombik.org>

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
