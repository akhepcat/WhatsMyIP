#!/bin/bash
MyINTv4=$(awk 'BEGIN { IGNORECASE=1 } /^[a-z0-9]+[ \t]+00000000/ { print $1 }' /proc/net/route)
ALIVE=$(ping -w 1 -c 1 plugbase.gci.net 2>&1)
if [ -z "${MyINTv4}" -o $? -eq 1 ]
then
        echo "def_int=null"
        echo "int_ip4=0.0.0.0"
        echo "ext_ip4=0.0.0.0"
        exit 1
fi

MyExtIPv4=$(curl -stderr /dev/null -4 http://plugbase.gci.net/cgi-bin/whatsmyip.cgi)

MyINTv4=${MyINTv4##*default*dev }
MyINTv4=${MyINTv4%% *}

MyIntIPv4=$(ip addr show dev $MyINTv4)
MyIntIPv4=${MyIntIPv4##*inet }
MyIntIPv4=${MyIntIPv4%%brd*}
MyIntIPv4=${MyIntIPv4%%/*}

MyExtIPv4=${MyExtIPv4##*queryinput=}
MyExtIPv4=${MyExtIPv4%%\"*}

echo def_int=${MyINTv4}
echo int_ip4=${MyIntIPv4}
echo ext_ip4=${MyExtIPv4}
