#! /bin/bash
HOST_ADDR=`ip -f inet -o addr show $(ip route | grep default | awk '{print $NF}') | cut -d" " -f 7 | cut -d/ -f 1`
if [ "$(hostname -i)" = "" ]; then
    echo $HOST_ADDR    $(hostname) >> /etc/hosts
fi

echo $(hostname -i)
/opt/jboss/docker-entrypoint.sh $@ -Djboss.bind.address.private=$HOST_ADDR -Djboss.bind.address.management=$HOST_ADDR -Djgroups.bind.address=$HOST_ADDR

