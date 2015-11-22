#!/bin/bash
for i in "$@"
do
case $i in
    -t=*|--type=*)
    TYPE="${i#*=}"
    shift # past argument=value
    ;;
    -l=*|--locale=*)
    LOCALE="${i#*=}"
    shift # past argument=value
    ;;
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

locale-gen ${LOCALE}

if [ "${TYPE}" == "php" ]; then

    apt-get update
    apt-get install -y python-software-properties
    apt-get update
    apt-get install -y php5

    if [ "${FRAMEWORK}" == "laravel" ]; then
        echo "Framework: Laravel"
    fi
    if [ "${FRAMEWORK}" == "wordpress" ]; then
        echo "Framework: Wordpress"
    fi

    echo "#!/bin/bash
        set -e
        rm -f /var/run/apache2/apache2.pid
        exec apache2 -DFOREGROUND" > /webmaker/install
    fi
if [ "${TYPE}" == "node" ]; then

    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
    apt-get update
    apt-get install -y mongodb-org git curl build-essential openssl libssl-dev pkg-config wget g++ python nodejs npm

    if [ "${FRAMEWORK}" == "mean" ]; then
        echo "#!/bin/bash
        npm install -g bower grunt-cli
        cd ~
        git clone https://github.com/meanjs/mean.git ${APPNAME}
        cd ${APPNAME}
        npm install
        bower --allow-root --config.interactive=false install
        grunt" > /webmaker/install
    fi
    if [ "${FRAMEWORK}" == "sails" ]; then
        echo "#!/bin/bash
        npm -g install sails
        cd ~
        sails new ${APPNAME}
        cd ${APPNAME}
        sails lift" > /webmaker/install
    fi
    if [ "${FRAMEWORK}" == "meteor" ]; then
        echo "#!/bin/bash
        cd ~
        /usr/bin/curl https://install.meteor.com/ | /bin/sh
        meteor create ${APPNAME}
        cd ${APPNAME}
        mkdir -p tests/jasmine/server/unit
        mkdir -p tests/jasmine/client/integration
        meteor add sanjo:jasmine
        meteor" > /webmaker/install
    fi
fi

chmod +x /webmaker/install

echo 'install script created...'
