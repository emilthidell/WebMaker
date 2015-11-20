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

locale-gen en_US.UTF-8

if [ "${FRAMEWORK}" == "mean" ]; then
    echo "#!/bin/bash \
    npm install -g bower grunt-cli
    cd ~
    git clone https://github.com/meanjs/mean.git ${APPNAME}
    cd ${APPNAME}
    npm install
    bower --allow-root --config.interactive=false install
    grunt" > /webmaker/install
fi
if [ "${FRAMEWORK}" == "sails" ]; then
    echo "#!/bin/bash \
    npm -g install sails
    cd ~
    sails new ${APPNAME}
    cd ${APPNAME}
    sails lift" > /webmaker/install
fi
if [ "${FRAMEWORK}" == "meteor" ]; then
    echo "#!/bin/bash \
    cd ~ \
    curl https://install.meteor.com/ | /bin/sh \
    meteor create ${APPNAME} \
    cd ${APPNAME} \
    meteor" > /webmaker/install
fi

echo 'install script created...'
