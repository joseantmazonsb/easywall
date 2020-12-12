#!/bin/bash

ROOT_PATH="/easywall"
EXPORTED_PATH="/config"
SCRIPTS_PATH="$ROOT_PATH/scripts"
WEB_PATH="$ROOT_PATH/easywall/web"

function install {
    echo "[INSTALLING EASYWALL]"
    $SCRIPTS_PATH/install-core.sh
    $SCRIPTS_PATH/install-web.sh
    mv $ROOT_PATH/* $EXPORTED_PATH
    rm -rf $ROOT_PATH
}

function run {
    echo "[RUNNING EASYWALL]"
    # Copy conf files
    cp -R /config/* $ROOT_PATH/
    # Start core and web
    python3 -m easywall &
    $WEB_PATH/easywall_web.sh
}

flag_file="/times_ran"
count=1
if [ ! -f "$flag_file" ]; then
    install
else
    count=$(cat $flag_file)
    let "count++"
fi
echo $count > $flag_file
run