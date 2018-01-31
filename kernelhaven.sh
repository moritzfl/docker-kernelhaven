#!/bin/sh -e
#
# Script to allow for data-persistence in the /data-directory and run fiduswriter

echo "*** Running as user $(whoami) ..."

mkdir /data
mkdir /data/plugins

# Handle fiduswriter.sql
if [ ! -f /data/autoupdate-root.txt ]; then
    echo "autoupdate-root.txt did not exist, creating default file"
    cp /scripts/autoupdate-root.txt /data/autoupdate-root.txt
fi

if [ ! -f /data/autoupdate-plugins.txt ]; then
    echo "autoupdate-plugins.txt did not exist, creating default file"
    cp /scripts/autoupdate-plugins.txt /data/autoupdate-plugins.txt
fi

echo "*** Updating KernelHaven ..."
cd /data

file="/data/autoupdate-root.txt"
cat $file | egrep -v '^#' | xargs wget -N

echo "*** Updating Plugins ..."
cd /data/plugins

file="/data/autoupdate-plugins.txt"
cat $file | egrep -v '^#' | xargs wget -N

cd /data
echo '*** Running KernelHaven ...'
java -jar KernelHaven.jar configuration.properties

exit 0
