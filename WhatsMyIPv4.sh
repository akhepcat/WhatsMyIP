#!/bin/bash
MyV4Int=$(awk 'BEGIN { IGNORECASE=1 } /^[a-z0-9:.-]+[ \t]+00000000/ { print $1 }' /proc/net/route 2>/dev/null | head -1)
[[ -n "${MyV4Int}" ]] && ALIVE=$(ping -w 1 -c 1 ip4.me 2>&1)

if [ -z "${MyV4Int}" -o $? -eq 1 ]
then
        echo "def_int=null"
        echo "int_ip4=0.0.0.0"
        echo "ext_ip4=0.0.0.0"
        exit 1
fi

MyV4Int=${MyV4Int##*default*dev }
MyV4Int=${MyV4Int%% *}

#########

MyIntIPv4=$(ip -4 addr show dev $MyV4Int scope global)
MyIntIPv4=${MyIntIPv4##*inet }
MyIntIPv4=${MyIntIPv4%%brd*}
MyIntIPv4=${MyIntIPv4%%/*}

# 
MyExtIPv4=$(curl --connect-timeout 2 --max-time 3 --retry 0 --stderr /dev/null -4 http://ip4.me/api/ | cut -f2 -d,)

echo def_int=${MyV4Int}
echo int_ip4=${MyIntIPv4}
echo ext_ip4=${MyExtIPv4}
