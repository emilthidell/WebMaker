#!/bin/bash
for i in "$@"
do
case $i in
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
    -fp=*|--frameworkpack=*)
    FRAMEWORKPACK="${i#*=}"
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
        mkdir ${APPNAME}
        cp -r /tmp/app/* /webmaker/${APPNAME}
        cd ${APPNAME}
        ${FRAMEWORKPACK}
        meteor" > /webmaker/run
    else
        echo "#!/bin/bash
        cd /webmaker
        /usr/bin/curl https://install.meteor.com/ | /bin/sh
        cd /webmaker/${APPNAME}
        meteor" > /webmaker/run
    fi
fi

chmod +x /webmaker/run

echo 'run script created...'

/webmaker/run
