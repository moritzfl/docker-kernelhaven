#!/bin/sh -e
#
# Script to allow for data-persistence in the /data-directory and run kernelhaven

echo "*** Running as user $(whoami) ..."

mkdir /data
mkdir /data/plugins

# Handle the autoupdate files. If they do not exist, copy templates
# Users can deactivate autoupdate by removing entries from the files.
# A deletion of the autoupdate files will however only result in the recreation of thos efiles.
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

MAX_RAM=$(cgget -nvr memory.limit_in_bytes /)
if [ $MAX_RAM -le 137438953472 ] ; then
    JVM_MIN_HEAP=$(printf "%.0f" $(echo "${MAX_RAM} * 0.1" | bc))
    JVM_MAX_HEAP=$(printf "%.0f" $(echo "${MAX_RAM} * 0.8" | bc))
    
    echo '*** Running KernelHaven ...'
    exec java "-Xms${JVM_MIN_HEAP}" "-Xmx${JVM_MAX_HEAP}" -jar KernelHaven.jar configuration.properties
else
    echo "You must specify the amount of RAM for this container when first starting it (eg. docker run --memory=64G ...)"
    exit 1
fi

exit 0
