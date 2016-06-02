mjuenema.eclipse
================

An Ansible Role that installs Eclipse Platform on recent versions of CentOS, Fedora and Debian.


Requirements
------------

This role only works with Ansible 2.1 as it uses the ```extra_opts``` parameter
of the ```unarchive``` module to extract the Eclipse code into its release
specific directory in ```/opt```.

Any pre-requsites will be installed through the distribution's native package manager, e.g.
*apt*, *yum*, *dnf*.


Role Variables
--------------

The release variable must be set to select the Eclipse version to be installed. Valid values are
listed below. See the Example Playbook below for details.

* ```eclipse_release```
  * ```4.5.2```
  * ```4.4.2```

Dependencies
------------

There are no dependencies.


Example Playbook
----------------

```
---
- hosts: servers

  vars:
    eclipse_release: 4.5.2

  roles:
    - mjuenema.eclipse

```

License
-------

BSD

Author Information
------------------

Markus Juenemann
markus@jueneman.net
16-May-2016

