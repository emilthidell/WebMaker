# WebMaker is configured with several frameworks for NodeJS, use this image as a base image
# for your nodejs projects
#
# Todo:
# NodeJS
#  - Angular
#  - Meteor #DONE
#  - Sails
#  - Mean
#  - Ghost
#

# FROM Baseimage ubuntu
FROM ubuntu

# ENV-FRAMEWORK: meteor/sails/mean
ENV FRAMEWORK meteor

ENV NODEVER 0.12.6

# ENV-FRAMEWORKVER: 1.0
ENV FRAMEWORKVER 1.0

# ENV-FRAMEWORKPACKS: <frameworks pack install script>
ENV FRAMEWORKPACK "meteor add aldeed:collection2 && meteor add aldeed:simple-schema && meteor add aldeed:autoform"

# ENV-APPNAME
ENV APPNAME testapp

# ENV-LOCALE
ENV LOCALE en_US.UTF-8

VOLUME /webmaker

# Add files.
ADD start.bash /start

# Add app folder.
ADD app /tmp/app

RUN chmod +x /start

# Expose ports. Ghost,Meteor:3000 Sails:1337
EXPOSE 22 3000 1337

RUN apt-get -y update && apt-get -y install \
    wget \
    git \
    python \
    make \
    build-essential \
    curl

RUN wget https://nodejs.org/dist/v0.12.6/node-v0.12.6-linux-x64.tar.gz && \
    tar -zxf node-v0.12.6-linux-x64.tar.gz -C /usr/local && \
    ln -sf node-v0.12.6-linux-x64 /usr/local/node && \
    ln -sf /usr/local/node/bin/npm /usr/local/bin/ && \
    ln -sf /usr/local/node/bin/node /usr/local/bin/ && \
    rm node-v0.12.6-linux-x64.tar.gz

RUN curl https://install.meteor.com/ | /bin/sh
# Start the install
CMD /start --framework=$FRAMEWORK --type=$TYPE --appname=$APPNAME --locale=$LOCALE
