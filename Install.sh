#!/bin/bash
set -e

 if cat /etc/*release | grep ^NAME | grep CentOS; then
    clear
    echo
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo -e "  \e[1;31m[+]                OS Detection [CentOS]                [+]\e[0m	"
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo
    read -p " Press [ENTER] to continue ... "
    clear

    interface=$(ip -o link show | awk -F': ' '{print $2}' | awk -F 'lo' '{print $1}')
    ip=$(hostname --all-ip-addresses | awk '{print $1}'  )
    check=$(route -n | grep 'UG[ \t]' | awk '{print $2}')
    list=$(ls /etc/sysconfig/network-scripts)
    gateway=$(echo $check | awk '{print $1}')

    echo
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo -e "  \e[1;31m[+]         Static IP Changer [Ubuntu & CentOS]         [+]\e[0m	"
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo
    echo -e "             \e[1;36mDirectory List\e[0m :" $list
    echo -e "                 \e[1;36mInterfaces\e[0m :" $interface
    echo -e "             \e[1;36mCurrent Gatway\e[0m :" $gateway
    echo -e "         \e[1;36mCurrent IP Address\e[0m :" $ip
    echo
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo
    read -p "           Choose Interface : " int
    read -p "          Change IP Address : " change_ip
    read -p "            Default Gateway : " gatway
    read -p "      Choose Interface File : " file

    type=$(cat /etc/sysconfig/network-scripts/$file | grep ^TYPE | awk -F'TYPE=' '{print $2}')
    uuid=$(cat /etc/sysconfig/network-scripts/$file | grep ^UUID | awk -F'UUID=' '{print $2}')

    rm -rf cat /etc/sysconfig/network-scripts/$file
    echo
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo
    
    touch /etc/sysconfig/network-scripts/$file
    
    echo "TYPE=$type
    PROXY_METHOD=none
    BROWSER_ONLY=no
    BOOTPROTO=none
    DEFROUTE=yes
    IPV4_FAILURE_FATAL=no
    IPV6INIT=yes
    IPV6_AUTOCONF=yes
    IPV6_DEFROUTE=yes
    IPV6_FAILURE_FATAL=no
    NAME=$int
    UUID=$uuid
    DEVICE=$int
    ONBOOT=yes
    IPADDR=$change_ip
    PREFIX=24
    GATEWAY=$gatway
    DNS1=8.8.8.8
    DNS2=9.9.9.9" >> /etc/sysconfig/network-scripts/$file

    echo -e "    \e[1;31mNow, Your IP Address Is\e[0m :" "\e[1;36m"$change_ip"\e[0m"
    echo
    read -p " Press [ENTER] to continue and reboot system ... "
    echo
    reboot

 elif cat /etc/*release | grep ^NAME | grep Ubuntu; then
    clear
    echo
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo -e "  \e[1;31m[+]                OS Detection [Ubuntu]                [+]\e[0m	"
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo
    read -p " Press [ENTER] to continue ... "
    echo
    clear
    interface=$(ip -o link show | awk -F': ' '{print $2}' | awk -F 'lo' '{print $1}')
    ip=$(hostname --all-ip-addresses | awk '{print $1}'  )
    check=$(route -n | grep 'UG[ \t]' | awk '{print $2}')
    gateway=$(echo $check | awk '{print $1}')
    echo
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo -e "  \e[1;31m[+]         Static IP Changer [Ubuntu & CentOS]         [+]\e[0m	"
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo
    echo -e "                 \e[1;36mInterfaces\e[0m :" $interface
    echo -e "             \e[1;36mCurrent Gatway\e[0m :" $gateway
    echo -e "         \e[1;36mCurrent IP Address\e[0m :" $ip
    echo
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo
    read -p "           Choose Interface : " int
    read -p "          Change IP Address : " ip
    read -p "            Default Gateway : " gatway
    echo
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    rm -rf /etc/netplan/*
    echo "network:
    version: 2
    renderer: NetworkManager
    ethernets:
       $int:
          dhcp4: no
          addresses: [$ip/24]
          gateway4: $gatway
          nameservers:
           addresses: [9.9.9.9, 8.8.8.8]"  >> /etc/netplan/network-manager.yaml
    sudo netplan apply
    echo
    echo -e "    \e[1;31mNow, Your IP Address Is\e[0m :" "\e[1;36m"$ip"\e[0m"
    echo
    read -p " Press [ENTER] to continue and reboot system ... "
    echo
    reboot
 else
    echo
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo -e "  \e[1;31m[+]      OS NOT DETECTED [Support Ubuntu & CentOS]      [+]\e[0m	"
    echo -e "  \e[1;31m[*] =================================================== [*]\e[0m	"
    echo
    read -p " Press [ENTER] to continue ... "
    echo
    clear
    exit 1;
 fi

exit 0