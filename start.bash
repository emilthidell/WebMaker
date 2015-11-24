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
    -fv=*|--frameworkver=*)
    FRAMEWORKVER="${i#*=}"
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
        exec apache2 -DFOREGROUND" > /webmaker/run
    fi
if [ "${TYPE}" == "node" ]; then

    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
    apt-get update
    apt-get install -y mongodb-org git curl build-essential openssl libssl-dev pkg-config wget g++ python nodejs npm

    if [ "${FRAMEWORK}" == "mean" ]; then
        echo "#!/bin/bash
        npm install -g bower grunt-cli
        cd /webmaker
        git clone https://github.com/meanjs/mean.git ${APPNAME}
        cd ${APPNAME}
        npm install
        bower --allow-root --config.interactive=false install
        grunt" > /webmaker/run
    fi
    if [ "${FRAMEWORK}" == "sails" ]; then
        echo "#!/bin/bash
        npm -g install sails
        cd /webmaker
        sails new ${APPNAME}
        cd ${APPNAME}
        sails lift" > /webmaker/run
    fi
    if [ "${FRAMEWORK}" == "meteor" ]; then
        if [ ! -d "/webmaker/${APPNAME}" ]; then
            echo "#!/bin/bash
            cd /webmaker
            /usr/bin/curl https://install.meteor.com/ | /bin/sh
            meteor create ${APPNAME}
            cd ${APPNAME}
            cp -r /tmp/app/* /webmaker/${APPNAME}/
            meteor" > /webmaker/run
        else
            echo "#!/bin/bash
            cd /webmaker
            /usr/bin/curl https://install.meteor.com/ | /bin/sh
            cd /webmaker/${APPNAME}
            meteor" > /webmaker/run
        fi
    fi
fi

chmod +x /webmaker/run

echo 'run script created...'

/webmaker/run
