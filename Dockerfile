FROM openjdk:11-jre-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        awscli curl groff-base jq less unzip wget zip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /jmeter \
    && cd /jmeter \
    && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.0.tgz \
    && tar --strip-components=1 -xvf apache-jmeter-5.0.tgz \
    && rm apache-jmeter-5.0.tgz

ENV JMETER_HOME /jmeter

ENV PATH $JMETER_HOME/bin:$PATH

WORKDIR /work

ADD senarios /work/senarios
ADD start-slave.sh /usr/local/bin
ADD run-master.sh /usr/local/bin

ENTRYPOINT []
CMD ["start-slave.sh"]
