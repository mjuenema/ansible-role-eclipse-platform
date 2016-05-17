#
# This script is to be executed inside the LXC container
# to install and configure Ansible.
#
# This script only works on distributions that have a
# /etc/os-release or /usr/lib/os-release file.
#
# MJ, 17-May-2016


# Read information about the distribution.
#
if [ -e /etc/os-release ]; then
    source /etc/os-release
else
    if [ -e /usr/lib/os-release ]; then
        source /usr/lib/os-release
    else
        echo "Unable to read /etc/os-relase or /usr/lib/os-release, terminating!"
        exit 1
    fi
fi

# At least the following variables will now be set:
# NAME=Fedora
# VERSION="23 (Twenty Three)"
# ID=fedora
# VERSION_ID=23
# PRETTY_NAME="Fedora 23 (Twenty Three)"


# Prepare package manager
#
case $ID in 
    centos|fedora|rhel)   if [ -x /bin/dnf ]; then
                              PKGMAN=dnf
                          else
                              PKGMAN=yum
                          fi
                          ;;
esac


# Install packages
#
case $ID in
    centos|fedora|rhel)	$PKGMAN -y install python-setuptools gcc git libffi-devel redhat-rpm-config python-devel openssl-devel git
    ;;
esac


# Install Ansible and dependencies
#
easy_install pip
pip install --upgrade ansible

