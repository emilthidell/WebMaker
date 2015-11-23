# WebMaker is configured with several frameworks, use this image as a base image
# for your web projects. Environment vars is required in the app image
#
# Todo:
# Nginx
# Apache
# PHP
#  - Wordpress
#  - Laravel
#  - Phalcon
#
# NodeJS
#  - Angular
#  - Meteor #DONE
#  - Sails
#  - Mean
#  - Ghost
#

# FROM Baseimage ubuntu
FROM ubuntu

# ENV-TYPE: node/php
ENV TYPE node

# ENV-FRAMEWORK: wordpress/laravel/phalcon/meteor/sails/mean
ENV FRAMEWORK meteor

# ENV-APPNAME
ENV APPNAME testapp

# HTTPD: apache/nginx
ENV HTTPD apache

# ENV-LOCALE
ENV LOCALE en_US.UTF-8

VOLUME /webmaker

# Add files.
ADD start.bash /start

RUN chmod +x /start

# Expose ports. Ghost,Meteor:3000 Sails:1337
EXPOSE 3000 1337

# Start the install
CMD /start --framework=$FRAMEWORK --type=$TYPE --appname=$APPNAME --locale=$LOCALE
