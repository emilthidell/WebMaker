#!/bin/bash
for i in "$@"
do
case $i in
    -f=*|--framework=*)
    FRAMEWORK="${i#*=}"
    shift # past argument=value
    ;;
    -n=*|--name=*)
    APPNAME="${i#*=}"
    shift # past argument=value
    ;;
    *)
            # unknown option
    ;;
esac
done

if [ "${FRAMEWORK}" == "mean" ]; then
    npm install -g bower grunt-cli
    cd ~
    git clone https://github.com/meanjs/mean.git ${APPNAME}
    cd ${APPNAME}
    npm install
    bower --allow-root --config.interactive=false install
    grunt
fi
if [ "${FRAMEWORK}" == "sails" ]; then
    npm -g install sails
    cd ~
    sails new ${APPNAME}
    cd ${APPNAME}
    sails lift
fi
if [ "${FRAMEWORK}" == "meteor" ]; then
    cd ~
    curl https://install.meteor.com/ | /bin/sh
    meteor create ${APPNAME}
    cd ${APPNAME}
    meteor
fi

echo 'file ended'
