#!/bin/bash
MyV6Int=$(awk 'BEGIN { IGNORECASE=1 } /^00000000000000000000000000000000 00 00000000000000000000000000000000 00 [1-9a-f]/ { print $10 }' /proc/net/ipv6_route | sort -u)
ALIVE=$(ping6 -w 1 -c 1 plugbase.gci.net 2>&1)
if [ -z "${MyV6Int}" -o $? -eq 1 ]
then
        echo "def_int=null"
        echo "int_ip6=::0::"
        echo "ext_ip6=::0::"
        exit 1
fi
MyV6Int=${MyV6Int##*default*dev }
MyV6Int=${MyV6Int%% *}

#########

MyIntIPv6=$(ip -6 addr show dev $MyV6Int scope global | grep -v temporary)
MyIntIPv6=${MyIntIPv6#*inet6 }
MyIntIPv6=${MyIntIPv6%%/*}

#
MyExtIPv6=$(curl -stderr /dev/null -6 http://plugbase.gci.net/cgi-bin/whatsmyip.cgi)

MyExtIPv6="${MyExtIPv6#*target*http*=}"
MyExtIPv6=${MyExtIPv6%%\"*}

echo def_int=${MyV6Int}
echo int_ip6=${MyIntIPv6}
echo ext_ip6=${MyExtIPv6}
