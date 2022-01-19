FROM openjdk:8-jdk-alpine

ARG kafka_version=2.8.1
ARG scala_version=2.13
ARG glibc_version=2.31-r0

ENV KAFKA_VERSION=$kafka_version \
    SCALA_VERSION=$scala_version \
    KAFKA_HOME=/opt/kafka \
    GLIBC_VERSION=$glibc_version

ENV PATH=${PATH}:${KAFKA_HOME}/bin

COPY download-kafka.sh start-kafka.sh broker-list.sh create-topics.sh versions.sh start-kafka-new.sh server.properties /tmp/

RUN apk add --no-cache bash curl jq docker \
 && chmod a+x /tmp/*.sh \
 && chmod 777 /tmp/server.properties \
 && mv /tmp/start-kafka.sh /tmp/start-kafka-new.sh /tmp/broker-list.sh /tmp/create-topics.sh /tmp/versions.sh /tmp/server.properties /usr/bin \
 && sync && /tmp/download-kafka.sh \
 && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
 && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
 && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} \
 && rm /tmp/* \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
 && apk add --no-cache --allow-untrusted glibc-${GLIBC_VERSION}.apk \
 && rm glibc-${GLIBC_VERSION}.apk

COPY overrides /opt/overrides

VOLUME ["/kafka"]

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka-new.sh"]