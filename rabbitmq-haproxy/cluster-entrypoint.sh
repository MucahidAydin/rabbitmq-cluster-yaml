#!/bin/bash
set -e

chmod 400 /var/lib/rabbitmq/.erlang.cookie

HOSTNAME=$(env hostname)
echo "Starting RabbitMQ Server For host: " "$HOSTNAME"

if [ -z "$JOIN_CLUSTER_HOST" ]; then
    /usr/local/bin/docker-entrypoint.sh rabbitmq-server &
    sleep 5
    rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@"$HOSTNAME".pid
else
    /usr/local/bin/docker-entrypoint.sh rabbitmq-server -detached
    sleep 5
    rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@"$HOSTNAME".pid
    rabbitmqctl stop_app
    rabbitmqctl join_cluster rabbit@"$JOIN_CLUSTER_HOST"
    rabbitmqctl start_app
    
    # rabbitmq-plugins enable rabbitmq_federation 
    rabbitmq-plugins enable rabbitmq_federation
    rabbitmq-plugins enable rabbitmq_federation_management
    rabbitmq-plugins enable rabbitmq_shovel
    rabbitmq-plugins enable rabbitmq_shovel_management

    rabbitmqctl stop_app
    rabbitmqctl start_app

    # rabbitmqctl set_policy ha-fed \
    # ".*" '{"federation-upstream-set":"all", "ha-mode":"nodes", "ha-params":["rabbit@rabbit1","rabbit@rabbit2","rabbit@rabbit3","rabbit@rabbit4","rabbit@rabbit5","rabbit@rabbit6"]}' \
    # --priority 1 \
    # --apply-to queues

    rabbitmqctl set_policy federate-me \
    "^federated\." '{"federation-upstream-set":"all"}' \
    --priority 1 \
    --apply-to exchanges

    rabbitmqctl set_policy Lazy "lazy-queue" '{"queue-mode":"lazy"}' --priority 10 --apply-to queues

    # rabbitmqctl set_policy zgrab2_worker "zgrab2_worker" '{"ha-mode":"all","ha-sync-mode":"automatic"}' --priority 9 --apply-to queues
    # rabbitmqctl eval 'application:set_env(rabbit, consumer_timeout, 36000000).'
    # rabbitmq-plugins enable rabbitmq_shovel rabbitmq_shovel_management

    rabbitmqctl stop_app
    rabbitmqctl start_app
fi

# Keep container running
tail -f /dev/null
