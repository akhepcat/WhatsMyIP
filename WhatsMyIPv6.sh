#!/bin/bash
MyINTv6=$(awk 'BEGIN { IGNORECASE=1 } /^00000000000000000000000000000000 00 00000000000000000000000000000000 00 [1-9a-f]/ { print $10 }' /proc/net/ipv6_route)

ALIVE=$(ping6 -w 1 -c 1 plugbase.gci.net 2>&1)

if [ -z "${MyINTv6}" -o $? -eq 1 ]
then
        echo "def_int=null"
        echo "int_ip6=::0::"
        echo "ext_ip6=::0::"
        exit 1
else
        MyExtIPv6=$(curl -stderr /dev/null -6 http://plugbase.gci.net/cgi-bin/whatsmyip.cgi)

        MyINTv6=${MyINTv6##*default*dev }
        MyINTv6=${MyINTv6%% *}

        MyIntIPv6=$(ip -6 addr show dev $MyINTv6)
        MyIntIPv6=${MyIntIPv6#*inet6 }
        MyIntIPv6=${MyIntIPv6%%/*}

        MyExtIPv6=${MyExtIPv6##*queryinput=}
        MyExtIPv6=${MyExtIPv6%%\"*}

        echo def_int=${MyINTv6}
        echo int_ip6=${MyIntIPv6}
        echo ext_ip6=${MyExtIPv6}
fi
