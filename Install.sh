interface=$(ip -o link show | awk -F': ' '{print $2}' | awk -F 'lo' '{print $1}')
ip=$(hostname --all-ip-addresses | awk '{print $1}'  )
check=$(route -n | grep 'UG[ \t]' | awk '{print $2}')
gateway=$(echo $check | awk '{print $1}')
echo
echo -e "  \e[1;31m[*] ================================= [*]\e[0m	"
echo -e "  \e[1;31m[+]         Static IP Changer         [+]\e[0m	"
echo -e "  \e[1;31m[*] ================================= [*]\e[0m	"
echo
echo -e "         \e[1;36mInterfaces\e[0m :" $interface
echo -e "     \e[1;36mCurrent Gatway\e[0m :" $gateway
echo -e " \e[1;36mCurrent IP Address\e[0m :" $ip
echo
echo -e "  \e[1;31m[*] ================================= [*]\e[0m      "
echo
read -p "  Choose Interface : " int
read -p " Change IP Address : " ip
read -p "   Default Gateway : " gatway
echo
echo -e "  \e[1;31m[*] ================================= [*]\e[0m      "
rm -rf /etc/netplan/*
echo "network:"					>> /etc/netplan/network-manager.yaml
echo "  version: 2"				>> /etc/netplan/network-manager.yaml
echo "  renderer: NetworkManager"		>> /etc/netplan/network-manager.yaml
echo "  ethernets:"				>> /etc/netplan/network-manager.yaml
echo "   "$int":"				>> /etc/netplan/network-manager.yaml
echo "      dhcp4: no"				>> /etc/netplan/network-manager.yaml
echo "      addresses: ["$ip"/24]"		>> /etc/netplan/network-manager.yaml
echo "      gateway4: "$gatway			>> /etc/netplan/network-manager.yaml
echo "      nameservers:"			>> /etc/netplan/network-manager.yaml
echo "        addresses: [9.9.9.9, 8.8.8.8]"	>> /etc/netplan/network-manager.yaml
sudo netplan apply
echo
echo -e " \e[1;31mNow, Your IP Address Is\e[0m :" "\e[1;36m"$ip"\e[0m"
echo
read -p " Press [ENTER] to continue and reboot system ... "
echo
reboot
