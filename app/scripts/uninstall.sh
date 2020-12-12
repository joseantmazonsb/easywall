#!/bin/bash

SCRIPTNAME=$(basename "$0")
SCRIPTSPATH=$(dirname "$(readlink -f "$0")")

if [ "$EUID" -ne 0 ]; then
    read -r -d '' NOROOT <<EOF
To remove easywall, you need administration rights.
You can use the following commands:

# sudo -H bash ${SCRIPTSPATH}/${SCRIPTNAME}
or
# su root -c "${SCRIPTSPATH}/${SCRIPTNAME}"
EOF
    echo "$NOROOT"
    exit 1
fi

FILE="/lib/systemd/system/easywall.service"
if test -f "$FILE"; then
    systemctl --no-pager stop easywall.service
    rm -vf $FILE
    rm -vf /etc/systemd/system/multi-user.target.wants/easywall.service
    systemctl --no-pager daemon-reload
fi

FILE="/lib/systemd/system/easywall-web.service"
if test -f "$FILE"; then
    systemctl --no-pager stop easywall-web.service
    rm -vf $FILE
    rm -vf /etc/systemd/system/multi-user.target.wants/easywall-web.service
    systemctl --no-pager daemon-reload
fi

if id "easywall" >/dev/null 2>&1; then
    deluser easywall
    rm -rvf /home/easywall
fi

rm -rvf /var/log/easywall*
rm -rvf /opt/easywall-backup

# Finished.
echo "" && echo ""
read -r -d '' INSTRUCTIONS <<EOF
\\e[33m------------------------------\\e[39m
easywall was successfully uninstalled!

For the next steps, please follow our uninstallation instructions on GitHub.
https://github.com/jpylypiw/easywall/blob/master/docs/UNINSTALL.md

EOF
echo -e "${INSTRUCTIONS}"
