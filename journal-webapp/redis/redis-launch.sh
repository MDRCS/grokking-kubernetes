#!/bin/sh

PASSWORD=$(cat /etc/redis-passwd/passwd)

if [[ "${HOSTNAME}" == "redis-0" ]]; then
  redis-server --requirepass ${PASSWORD}
else
  redis-server --slaveof redis-0.redis 6379 --masterauth ${PASSWORD} --requirepass ${PASSWORD}
fi

# give permission to user to execute ops.
# chmod 755 redis-launch.sh

#You can create this script as a ConfigMap:
#kubectl create configmap redis-config --from-file=redis-launch.sh=redis-launch.sh
