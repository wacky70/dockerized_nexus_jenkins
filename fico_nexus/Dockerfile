FROM ubuntu:16.04
MAINTAINER "Arindam.Banerjee@fico.com"
USER root
RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
RUN apt-get update && apt-get install -y python
RUN DEBIAN_FRONTEND=noninteractive apt-get update && curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && python get-pip.py
RUN apt-get install -y sudo \
 && apt-get install -y curl \
 && apt-get install -y wget
RUN apt-get update -y
RUN curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash - && apt-get install -y --no-install-recommends apt-utils
RUN add-apt-repository main
RUN apt-get update && apt-get install -y \
    nodejs \
    python \
    python-virtualenv
RUN wget  https://npmjs.org/install.sh  \
    && chmod +x install.sh \
    && sh install.sh
RUN apt-get install -y --no-install-recommends \
    apt-utils \
    graphviz \
 &&  apt-get  install -y ruby make \
 && apt-get  install -y vim \
 && apt-get  install -y nano \
 && apt-get  install -y ntp
RUN apt-get -qq update
RUN apt-get -qq install openjdk-8-jdk
RUN apt-get -qq install openjdk-8-jre
RUN apt-get -qq install wget
RUN mkdir -p /opt/sonatype-nexus /opt/sonatype-work /opt/sonatype-work/nexus
RUN ["wget", "-O", "/tmp/nexus-latest-bundle.tar.gz", "http://www.sonatype.org/downloads/nexus-latest-bundle.tar.gz"]
RUN tar -zxvf /tmp/nexus-latest-bundle.tar.gz -C /opt/sonatype-nexus --strip-components=1
RUN useradd --user-group --system --home-dir /opt/sonatype-nexus nexus
RUN chown -R nexus:nexus /opt/sonatype-work /opt/sonatype-nexus /opt/sonatype-work/nexus

USER nexus

CMD ["/opt/sonatype-nexus/bin/nexus","console"]
VOLUME /opt/sonatype-work
EXPOSE 8081
