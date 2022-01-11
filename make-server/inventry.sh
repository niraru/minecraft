#!/bin/sh
if [ -e $PWD/terraform.tfstate ]; then
    ip=`cat $PWD/terraform.tfstate | jq '.resources[].instances[].attributes["default_ip_address"]' 2> /dev/null | sed -e 's/"//g' | sed -ze 's/\n/,/g' | sed -ze 's/null,//g'`
    cat <<EOS
{
    "servers"  : [ $ip ]
}
EOS
fi
