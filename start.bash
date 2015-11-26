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
        echo "Creating first time script..."
        echo "#!/bin/bash
        cd /webmaker
        /usr/bin/curl https://install.meteor.com/ | /bin/sh
        meteor create ${APPNAME}
        cd ${APPNAME}
        rm ${APPNAME}.*
        cp -rfp /tmp/app/* /webmaker/${APPNAME}
        ${FRAMEWORKPACK}
        sh prebuild/scripts/prebuild.bash
        meteor" > /webmaker/run
    else
        echo "The app already exists, sync /tmp/app with /webmaker/${APPNAME}..."
        echo "#!/bin/bash
        cd /webmaker
        /usr/bin/curl https://install.meteor.com/ | /bin/sh
        cd /webmaker/${APPNAME}
        meteor" > /webmaker/run
    fi
fi

chmod +x /webmaker/run

echo 'Run script created successfully...'

echo 'Executing script...'

/webmaker/run
