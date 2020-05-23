#!/bin/bash

# ==================================================
# Initializing Var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";


# Root Directory
cd


# Install Screenfetch
apt-get -y install lsb-release scrot
wget -O screenfetch "https://raw.githubusercontent.com/Dreyannz/AutoScriptVPS/master/Files/Others/screenfetch"
chmod +x screenfetch

# Download Commands
cd /usr/bin
wget https://github.com/kangdaqiq/debian/raw/master/automenu.tar.gz
tar -xzvf automenu.tar.gz
rm automenu.tar.gz
sed -i -e 's/\r$//' accounts
sed -i -e 's/\r$//' bench-network
sed -i -e 's/\r$//' clearcache
sed -i -e 's/\r$//' connections
sed -i -e 's/\r$//' create
sed -i -e 's/\r$//' create_random
sed -i -e 's/\r$//' create_trial
sed -i -e 's/\r$//' delete_expired
sed -i -e 's/\r$//' diagnose
sed -i -e 's/\r$//' edit_dropbear
sed -i -e 's/\r$//' edit_openssh
sed -i -e 's/\r$//' edit_openvpn
sed -i -e 's/\r$//' edit_ports
sed -i -e 's/\r$//' edit_squid3
sed -i -e 's/\r$//' edit_stunnel4
sed -i -e 's/\r$//' locked_list
sed -i -e 's/\r$//' menu
sed -i -e 's/\r$//' options
sed -i -e 's/\r$//' ram
sed -i -e 's/\r$//' reboot_sys
sed -i -e 's/\r$//' reboot_sys_auto
sed -i -e 's/\r$//' restart_services
sed -i -e 's/\r$//' server
sed -i -e 's/\r$//' set_multilogin_autokill
sed -i -e 's/\r$//' set_multilogin_autokill_lib
sed -i -e 's/\r$//' show_ports
sed -i -e 's/\r$//' speedtest
sed -i -e 's/\r$//' user_delete
sed -i -e 's/\r$//' user_details
sed -i -e 's/\r$//' user_details_lib
sed -i -e 's/\r$//' user_extend
sed -i -e 's/\r$//' user_list
sed -i -e 's/\r$//' user_lock
sed -i -e 's/\r$//' user_unlock

# AutoReboot Tools
echo "10 0 * * * root /usr/local/bin/reboot_sys" > /etc/cron.d/reboot_sys
echo "0 1 * * * root delete_expired" > /etc/cron.d/delete_expired
echo "*0 */2 * * * root clearcache" > /etc/cron.d/clearcache

# Set Permissions
cd /usr/bin
chmod +x create
chmod +x accounts
chmod +x create
chmod +x create_random
chmod +x create_trial
chmod +x user_list
chmod +x user_details
chmod +x user_details_lib
chmod +x user_extend
chmod +x user_delete
chmod +x user_lock
chmod +x user_unlock
chmod +x connections
chmod +x delete_expired
chmod +x locked_list
chmod +x options
chmod +x set_multilogin_autokill
chmod +x set_multilogin_autokill_lib
chmod +x restart_services
chmod +x edit_ports
chmod +x show_ports
chmod +x edit_openssh
chmod +x edit_dropbear
chmod +x edit_stunnel4
chmod +x edit_openvpn
chmod +x edit_squid3
chmod +x reboot_sys
chmod +x reboot_sys_auto
chmod +x clearcache
chmod +x server
chmod +x ram
chmod +x diagnose
chmod +x bench-network
chmod +x speedtest

# Finishing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
rm -f /root/AutoScriptVPS.sh
echo "unset HISTFILE" >> /etc/profile

# grep ports 
opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
stunnel4port="$(netstat -nlpt | grep -i stunnel | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
squidport="$(cat /etc/squid3/squid.conf | grep -i http_port | awk '{print $2}')"
nginxport="$(netstat -nlpt | grep -i nginx| grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

# Info
clear
echo -e ""
echo -e "\e[94m[][][]======================================[][][]"
echo -e "\e[0m                                                   "
echo -e "\e[94m           AutoScriptVPS by  KangDaQiQ            "
echo -e "\e[94m                                                  "
echo -e "\e[94m                    Services                      "
echo -e "\e[94m                                                  "
echo -e "\e[94m    OpenSSH        :   "$opensshport
echo -e "\e[94m    Dropbear       :   "$dropbearport
echo -e "\e[94m    SSL            :   "$stunnel4port
echo -e "\e[94m    OpenVPN        :   "$openvpnport
echo -e "\e[94m    Port Squid     :   "$squidport
echo -e "\e[94m    Nginx          :   "$nginxport
echo -e "\e[94m                                                  "
echo -e "\e[94m              Other Features Included             "
echo -e "\e[94m                                                  "
echo -e "\e[94m    Timezone       :   Asia/Manila (GMT +7)       "
echo -e "\e[94m    Webmin         :   http://$MYIP:10000/        "
echo -e "\e[94m    IPV6           :   [OFF]                      "
echo -e "\e[94m    Cron Scheduler :   [ON]                       "
echo -e "\e[94m    Fail2Ban       :   [ON]                       "
echo -e "\e[94m    DDOS Deflate   :   [ON]                       "
echo -e "\e[94m    LibXML Parser  :   {ON]                       "
echo -e "\e[0m                                                   "
echo -e "\e[94m[][][]======================================[][][]\e[0m"
echo -e "\e[0m                                                   "
read -n1 -r -p "          Press Any Key To Show Commands          "
menu
cd
