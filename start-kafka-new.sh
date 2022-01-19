#!/bin/bash -e

BROKER_ID=(${HOSTNAME##*-})
cp -vf /tmp/server.properties ${KAFKA_HOME}/config/server.properties
sed -i -e "s/{{BROKER_ID}}/${BROKER_ID}/g" ${KAFKA_HOME}/config/server.properties

exec "$KAFKA_HOME/bin/kafka-server-start.sh" "$KAFKA_HOME/config/server.properties"