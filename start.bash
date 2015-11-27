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
    mup setup
fi

chmod +x /webmaker/run
