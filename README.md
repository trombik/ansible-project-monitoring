# Monitoring system at `i.trombik.org`

This project manages the monitoring system at `i.trombik.org`.

This file explains general overview of the project. Please see [docs](docs/)`
directory for details.

The project is managed by a `Rakefile`, which provides most of common
operations, such as deploying and testing. Available targets can be shown by:

```console
> bundle exec rake -T
```

## Requirements

* nodejs and npm
* ruby 2.6.x
* bundler
* Virtualbox
* Vagrant
* python 3
* [ChromeDriver](https://chromedriver.chromium.org/getting-started)

## Environments

The project has two environments. To choose environment, set
`ANSIBLE_ENVIRONMENT` variable. If the environment variable is not defined, it
defaults to `virtualbox`.

### `virtualbox`

The `virtualbox` environment is a test environment on `virtualbox`. The
environment is isolated from external network, completely running on your
local machine.

### `prod`

The `prod` environment is the live, production environment.

## Usage

To deploy in an environment run `up` and `provision` targets.

```console
> bundle exec rake up provision
```

To perform all test from scratch, run `test` target.

```console
> bundle exec rake test
```

To perform unit tests, run `test:serverspec:all` target.

```console
> bundle exec rake test:serverspec:all
```

To perform integration tests, run `test:integration:all` target.

```console
> bundle exec rake test:integration:all
```

## Overview of nodes

### `virtualbox` environment

#### `mon.i.trombik.org`

The core system of the monitoring system. It has the following services:

* `sensu-backend`
* `sensu-agent`

The Web UI of `sensu-backend` is
[http://172.16.100.254:3000](http://172.16.100.254:3000).

The administrator account is `admin`, the password is `P@ssw0rd!`.

### `target1.i.trombik.org`

An example subject of monitoring. It has the following services enabled:

* `sensu-agent`
* `nginx`
