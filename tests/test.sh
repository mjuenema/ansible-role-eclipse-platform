#!/bin/sh -x 
#
# Setup LXC containers to test the Ansible playbook.
#

UUID=`uuidgen`

GITURL=`git remote -v | head -1 | cut -f 2 | cut -d' ' -f 1`


# Create the LXC containers.
#
lxc-create --name=centos7-$UUID --template=centos -- --release=7 --arch=x86_64 --fqdn=centos7.ansible.local 2>&1 | tee /tmp/centos7-$UUID.log


# Generate list of LXC containers we just created.
#
CONTAINERS=`lxc-ls | grep $UUID`


# Start all containers
#
for CONTAINER in $CONTAINERS; do
    lxc-start --name=$CONTAINER 2>&1 | tee -a /tmp/$CONTAINER.log
done
sleep 10


# Wait for all containers to become active
#
for CONTAINER in $CONTAINERS; do
    # Is container running?
    while [ `lxc-ls --active | grep -c $CONTAINER` -eq 0 ]; do
        sleep 5
    done
done


# Upload and execute setup script inside the containers.
#        
for CONTAINER in $CONTAINERS; do

    # Display environment in container
    #
    lxc-attach -n $CONTAINER -- /bin/sh -c "set" 2>&1 | tee -a /tmp/$CONTAINER.log

    # Upload and execute setup script 
    #
    cat _setup.sh    | lxc-attach -n $CONTAINER -- /bin/sh -c "/bin/cat > /tmp/setup.sh" 2>&1 | tee -a /tmp/$CONTAINER.log
    lxc-attach -n $CONTAINER -- /bin/sh /tmp/setup.sh 2>&1 | tee -a /tmp/$CONTAINER.log

    # Upload playbook and create /etc/ansible/hosts
    #
    lxc-attach -n $CONTAINER -- mkdir -p /etc/ansible/roles 2>&1 | tee -a /tmp/$CONTAINER.log
    echo localhost   | lxc-attach -n $CONTAINER -- /bin/sh -c "/bin/cat > /etc/ansible/hosts" 2>&1 | tee -a /tmp/$CONTAINER.log
    cat playbook.yml | lxc-attach -n $CONTAINER -- /bin/sh -c "/bin/cat > /etc/ansible/playbook.yml" 2>&1 | tee -a /tmp/$CONTAINER.log

    # Clone repository
    #
    lxc-attach -n $CONTAINER -- /bin/sh -c "cd /etc/ansible/roles && git clone $GITURL" 2>&1 | tee -a /tmp/$CONTAINER.log

    # Run playbook
    #
    lxc-attach -n $CONTAINER -- /bin/sh -c "http_proxy=$http_proxy ansible-playbook -vvvv -c local -i /etc/ansible/hosts /etc/ansible/playbook.yml" 2>&1 | tee -a /tmp/$CONTAINER.log
    echo "$?    $CONTAINER" >> /tmp/$UUID.results

done


# Finally stop and destroy all containers
#
for CONTAINER in $CONTAINERS; do
    lxc-stop --name=$CONTAINER --kill 2>&1 | tee -a /tmp/$CONTAINER.log
    lxc-destroy --name=$CONTAINER --force 2>&1 | tee -a /tmp/$CONTAINER.log
done

echo
echo
echo "OUTPUT"
echo "======"
ls -l /tmp/*$UUID.log
echo
echo

echo "RESULTS"
echo "======="
cat /tmp/$UUID.results
echo


