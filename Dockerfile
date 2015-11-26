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
ENV FRAMEWORKPACK "meteor add meteor-platform && meteor add autopublish && meteor add insecure && meteor add accounts-password && meteor add iron:router && meteor add zimme:iron-router-active && meteor add anti:fake && meteor add matb33:collection-hooks && meteor add aldeed:collection2 && meteor add aldeed:autoform && meteor add meteoric:ionic-sass@0.3.0 && meteor add meteoric:ionicons-sass@0.1.7 && meteor add meteoric:ionic@0.1.19 && meteor add meteoric:autoform-ionic && meteor add useraccounts:ionic"

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
EXPOSE 3000 1337

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

# Start the install
CMD /start --framework=$FRAMEWORK --type=$TYPE --appname=$APPNAME --locale=$LOCALE
