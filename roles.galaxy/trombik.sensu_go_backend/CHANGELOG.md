## Release 1.6.1

* 1103e9a bugfix: fix unreliable sensu-backend init

## Release 1.6.0

* 4efa4d2 feature: support mutator
* 94f4b58 bugfix: place modules in order of dependencies

## Release 1.5.0

* 2c14f73 imp: introduce sensu_go_backend_handler_sets
* 2a1c0f9 bugfix: use other URL for the key

## Release 1.4.0

* 4a3cd65 feature: introduce sensu_go_backend_extra_config_files
* e3a0453 bugfix: lint
* 0638861 feature: support configuration fragments

## Release 1.3.0

* 576010f bugfix: get FreeBSD back to the build
* e059aab bugfix: switch to virtualbox
* ee6d408 feature: support ruby gem plugins

## Release 1.2.1

* 3b548ba bugfix: wait_for the backend

## Release 1.2.0

* cf45731 doc: update the example
* 46f1b9c feature: support cluster_role and cluster_role_binding

## Release 1.1.1

* 07a798c bugfix: add proxy_requests and proxy_entity_name

## Release 1.1.0

* 776091b feature: support entity
* 8a25f61 feature: support filter
* 4cc9786 feature: support hook
* 0b06ee8 feature: support tessen
* 7317b20 feature: support socket_handler
* 3e002c4 feature: support pipe_handler
* 436d6a9 bugfix: remove `case`, 5.20.0 is now in package tree
* 9d0a80f bugfix: version 5.20.0 stop warning
* 8437d57 feature: support bonsai_asset module
* 907836b feature: support role_binding
* 5a23a8c feature: support user resource
* 69dc1de feature: support role
* 98a19fe feature: support namespace
* 712cd89 doc: update README
* bd2b2d6 bugfix: new image with the fix has been published
* f2f1f78 feature: enable kitchen test in Travis CI
* 083ebd8 bugfix: remove kitchen-verifier-shell
* 465b618 bugfix: ignore .kitchen.yml too
* 7a9e154 feature: support different provider
* 843f578 bugfix: ignore collections
* b190c82 bugfix: set ANSIBLE_COLLECTIONS_PATHS
* 911bd3b bugfix: install collections, temporarily disable qansible
* fc9375d bugfix: lint
* 30f3ec7 feature: support checks
* b92d4f4 feature: support assets with sensu.sensu_go collection
* bc0e8d1 imp: use kitchen-ansible with collections patch

## Release 1.0.2

* 9a26905 bugfix: use sysutils/sensu-go-backend for FreeBSD

## Release 1.0.1

* e179f6d bugfix: fix a link
* bfe2b9c imp: add trombik.sensu_go_agent to the tests

## Release 1.0.0

* Initial release
