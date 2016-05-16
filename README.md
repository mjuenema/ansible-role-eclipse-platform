gole Name
=========

An Ansible Role that installs Eclipse Platform on recent versions of CentOS, Fedora and Debian.


Requirements
------------

Any pre-requsites will be installed through the distribution's native package manager, e.g.
apt, yum, dnf.


Role Variables
--------------

The release variable must be set to select the Eclipse version to be installed. Valid values are
listed below. See the Example Playbook below for details.

* ```Juno```
* ```Kepler```
* ```Luna```
* ```Mars```


Dependencies
------------

There are no dependencies.


Example Playbook
----------------

```
    - hosts: myhosts
      roles:
         - mjuenema.eclipse-platform
```

License
-------

BSD

Author Information
------------------

Markus Juenemann
markus@jueneman.net
16-May-2016

