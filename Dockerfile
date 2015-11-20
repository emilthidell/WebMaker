# NodeJS configured for several frameworks, use this image as a base image
# for NodeJS projects. Environment vars is required in the app image
FROM ubuntu

ENV NODE_VERSION v4.2.2
ENV FRAMEWORK meteor
ENV APPNAME testapp

# Add files.
ADD start.bash /start

# Install NodeJS
RUN \

  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list && \
  apt-get update && \
  apt-get install -y mongodb-org git curl build-essential openssl libssl-dev pkg-config wget g++ python nodejs npm

VOLUME ["~"]

RUN chmod +x /start

# Expose ports. Ghost,Meteor:3000 Sails:1337
EXPOSE 3000 1337

# Start the install
CMD /start --framework=$FRAMEWORK
