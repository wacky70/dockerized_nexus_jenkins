FROM jenkins:2.60.2
MAINTAINER "Arindam.Banerjee@fico.com"
## we will copy the plugins from the plugins.txt to jenkins directory#
## Then set the env variable for Jenkins_home.
## Under user root we can install all the lib and tools which needs root priveledge.

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN rm -rf /usr/share/jenkins/ref/plugins/*
COPY install-plugins.sh /usr/local/bin/install-plugins.sh

ENV HOME $JENKINS_HOME
USER root
RUN apt-get update -y \
 && apt-get install -y sudo \
 && curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - \
 && apt-get install -y software-properties-common  \
    nodejs \   
 && wget https://npmjs.org/install.sh \
 && chmod +x install.sh \
 && ./install.sh \
 && apt-get install -y --no-install-recommends \
    apt-utils \
    graphviz \
 && apt-get  install -y ruby make \
 && apt-get  install -y vim \
 && apt-get  install -y nano \
 && apt-get  install -y ntp \ 
 && apt-get  install -y git
RUN  rm -rf /var/lib/apt/lists/*
RUN apt-get install -y sudo && \
    echo "jenkins ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins
RUN adduser admin && \
    echo "admin ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/admin && \
    chmod 0440 /etc/sudoers.d/admin

USER jenkins

