#!/bin/bash
### NLNog MRTG Ping Network Status
###    By: Alferez
###        www.alferez.es

echo " ******************************************************************"
echo " **               NLNog MRTG Ping Network Status                 **"
echo " **                                                              **"
echo " **                    Only for NLNog Members                    **"
echo " **                                                              **"
echo " **                                                              **"
echo " **                 BY: Alferez - www.alferez.es                 **"
echo " **                                                              **"
echo " ******************************************************************"

if [ -z $NLNOGUSER ]
then
	echo "ERROR: No NLNOGUSER variable defined"
	exit 1
fi
sed -i "s/NLNOGUSER/$NLNOGUSER/g" ~/.ssh/config

if [ ! -f /config/ring.nlnog.net ]
then
	echo "ERROR: File /config/ring.nlnog.net not found"
	exit 1
fi

if [ ! -f /config/nodes ]
then
        echo "ERROR: File /config/nodes not found"
        exit 1
fi

if [ ! -f /config/destination ]
then
        echo "ERROR: File /config/destination not found"
        exit 1
fi

if [ ! -d /data ]
then
	echo "ERROR: Data directory not found."
	exit 1
fi

if [ ! -d /data/html ]
then
	mkdir /data/html
fi

if [ ! -d /data/html/images ]
then
        mv /images /data/html/images
fi


if [ ! -d /data/logs ]
then
	mkdir /data/logs
fi

/usr/bin/supervisord > /data/logs/supervisord.log

/scripts/generatecfg

while true
do
	env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /data/logs/mrtg.log
	rm /data/html/index.html
	indexmaker --output=/data/html/index.html /etc/mrtg.cfg
	sleep 300
done
