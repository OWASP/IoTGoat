#!/bin/sh
echo -e "#############\nPlease ensure Dnsmasq network setup has been followed. See https://tinyurl.com/iotdnsmasq."\nTo set back to default, use -d default \nUsage: sh ./dnsmasq_setup.sh\n 
echo -e "\n#############"


netbak=/etc/config/network.bak
netog=/etc/config/network.og
dnsbak=/etc/dnsmasq.conf.bak
dnsog=/etc/dnsmasq.conf.og


while getopts ":d:" o; do
    case "${o}" in
        d)
            default=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND - 1))


if [ -z "${default}" ]; then
   cp $netbak /etc/config/network && cp $dnsbak /etc/dnsmasq.conf && ifup lan && ifup wan;echo -e "\n [+] Done! \n"; exit 1;
fi
echo "Setting network configs back to default"
cp $netog /etc/config/network && cp $dnsog /etc/dnsmasq.conf && ifup lan
echo -e "\n [+] Done! \n"
