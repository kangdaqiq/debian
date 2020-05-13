#!/bin/bash
#

echo "==========  ... mulai install ssh , dropbear , stunnel , squid , badvpn ... =========="
echo "======================================================================================"

echo "......................................................................................"
echo "......................................................................................"

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

#detail nama perusahaan
country=ID
state=Jawa Timur
locality=Jember
organization=KangDaQiQSSH
organizationalunit=IT
commonname=KangDaQiQSSH
email=kangdaqiq@gmail.com

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install apache2
# apt-get -y -f install apache2

# Edit port apache2 ke 8090
# wget -O /etc/apache2/ports.conf "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/apache2.conf"

# Edit port virtualhost apache2 ke 8090
# wget -O /etc/apache2/sites-enabled/000-default.conf "https://github.com/whitevps2/sshtunnel/raw/master/debian8/virtualhost.conf"

# restart apache2
# /etc/init.d/apache2 restart

# install wget and curl & php5
apt-get -y update
apt-get -y install wget curl
apt-get -y install php5-cgi
apt-get -y install php5-cli 
apt-get -y install php5-common 
apt-get -y install php5-curl 
apt-get -y install php5-dbg 
apt-get -y install php5-dev 
apt-get -y install php5-enchant
apt-get -y install php5-fpm 
apt-get -y install php5-gd 
apt-get -y install php5-gmp 
apt-get -y install php5-imap 
apt-get -y install php5-interbase
apt-get -y install php5-intl 
apt-get -y install php5-ldap 
apt-get -y install php5-mcrypt 
apt-get -y install php5-mysql 
apt-get -y install php5-mysqlnd 
apt-get -y install php5-odbc 
apt-get -y install php5-pgsql 
apt-get -y install php5-pspell 
apt-get -y install php5-recode
apt-get -y install php5-snmp 
apt-get -y install php5-sqlite 
apt-get -y install php5-sybase 
apt-get -y install php5-tidy 
apt-get -y install php5-xmlrpc 
apt-get -y install php5-xsl 
apt-get -y install php5-librdf 
apt-get -y install php5-remctl 
apt-get -y install php5-xcache 
apt-get -y install php5-xdebug

# install essential package
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart

# set repo
wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/sources.list.debian8"
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -

# update
apt-get -y update
apt-get -y install ca-certificates

# install neofetch
git clone https://github.com/dylanaraps/neofetch
cd neofetch
make install
make PREFIX=/usr/local install
make PREFIX=/boot/home/config/non-packaged install
gmake install
make -i install
apt-get -y update
apt-get -y install neofetch
cd
echo "clear" >> .bash_profile
echo "neofetch" >> .bash_profile

# install webserver
cd
apt-get -y install nginx
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/nginx.conf"
mkdir -p /home/vps/public_html
echo "<?php header("location:https://www.portalssh.com"); ?>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/vps.conf"
/etc/init.d/nginx restart


# setting port ssh
cd
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port  22/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=1080/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 443"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/ssh restart
/etc/init.d/dropbear restart

# install squid3
cd
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
/etc/init.d/squid3 restart

# setting Banner 
wget -O /etc/issue.net "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/banner"

# install webmin
cd
apt-get -y update && apt-get -y upgrade
apt-get -y install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python
wget http://prdownloads.sourceforge.net/webadmin/webmin_1.910_all.deb
dpkg --install webmin_1.910_all.deb
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm -f webmin_1.910_all.deb
/etc/init.d/webmin restart

# install stunnel
apt-get -y install stunnel4
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1


[dropbear]
accept = 444
connect = 127.0.0.1:1080

END

#membuat sertifikat
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

#konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

# common password debian 
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/common-password-deb8"
chmod +x /etc/pam.d/common-password

# update repo
apt-get -y update
apt-get -y install build-essential screen

# 1. Ketikan Perintah untuk install Make
apt-get -y install unzip

# install badvpn debian 8
wget https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2.tar.gz
tar xvzf cmake*.tar.gz
cd cmake*
./bootstrap --prefix=/usr
make
make install

# buat directory badvpn
mkdir badvpn-build
cd badvpn-build
wget https://github.com/whitevps2/sshtunnel/raw/master/debian8/badvpn.tar.gz
tar xvzf badvpn*.tar.gz
cmake -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
make install

# aut start badvpn
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 > /dev/null &' /etc/rc.local
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/null &' /etc/rc.local
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 > /dev/null &
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/null &
cd

# cek badvpn
# netstat -ntlp | grep :7200

# install fail2ban
apt-get -y install fail2ban;service fail2ban restart


# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/hapus.sh"
wget -O cek "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/user-login.sh"
wget -O member "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/user-list.sh"
wget -O jurus69 "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/resvis.sh"
wget -O speedtest "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/info.sh"
wget -O about "https://raw.githubusercontent.com/whitevps2/sshtunnel/raw/master/debian8/about.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

# permition rc local
chmod +x /etc/rc.local
chmod +x /etc/rc.d/rc.local
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x cek
chmod +x member
chmod +x jurus69
chmod +x speedtest
chmod +x info
chmod +x about

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/stunnel4 restart
/etc/init.d/squid3 restart
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo "Autoscript Include:" | tee log-install.txt
echo "===========================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenSSH   : 22, 143"  | tee -a log-install.txt
echo "Dropbear  : 109, 443"  | tee -a log-install.txt
echo "SSL       : 444"  | tee -a log-install.txt
echo "Squid3    : 80, 8080, 3128 (limit to IP SSH)"  | tee -a log-install.txt
echo "OpenVPN   : TCP 1194 (client config : http://$MYIP:81/client=tcp.ovpn)"  | tee -a log-install.txt
echo "badvpn    : badvpn-udpgw port 7200"  | tee -a log-install.txt
echo "nginx     : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "menu      : Menampilkan daftar perintah yang tersedia"  | tee -a log-install.txt
echo "usernew   : Membuat Akun SSH"  | tee -a log-install.txt
echo "trial     : Membuat Akun Trial"  | tee -a log-install.txt
echo "hapus     : Menghapus Akun SSH"  | tee -a log-install.txt
echo "cek       : Cek User Login"  | tee -a log-install.txt
echo "member    : Cek Member SSH"  | tee -a log-install.txt
echo "jurus69   : Restart Service dropbear, webmin, squid3, stunnel4, vpn, ssh)"  | tee -a log-install.txt
echo "reboot    : Reboot VPS"  | tee -a log-install.txt
echo "speedtest : Speedtest VPS"  | tee -a log-install.txt
echo "info      : Menampilkan Informasi Sistem"  | tee -a log-install.txt
echo "about     : Informasi tentang script auto install"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Fitur lain"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin    : http://$MYIP:10000/"  | tee -a log-install.txt
echo "Timezone  : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "IPv6      : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Original Script by partner white-vps.com"  | tee -a log-install.txt
echo "Modified by KangDaqiQ"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Log Instalasi --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "VPS AUTO REBOOT TIAP JAM 12 MALAM"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==========================================="  | tee -a log-install.txt
cd


echo "==========  ... Selesai install ssh , dropbear , stunnel , squid , badvpn ... =========="
echo "======================================================================================"

echo "......................................................................................"
echo "......................................................................................"

echo "==========================  ... mulai install OpenVPN ... ============================"
echo "======================================================================================"

echo "......................................................................................"
echo "......................................................................................"

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# update repository
apt-get -y update

# Install OpenVPN dan Easy-RSA
apt-get -y install openvpn easy-rsa

# copykan script generate Easy-RSA ke direktori OpenVPN
cp -r /usr/share/easy-rsa/ /etc/openvpn

# Buat direktori baru untuk easy-rsa keys
mkdir /etc/openvpn/easy-rsa/keys

# Kemudian edit file variabel easy-rsa
# nano /etc/openvpn/easy-rsa/vars
wget -O /etc/openvpn/easy-rsa/vars "https://raw.githubusercontent.com/whitevps2/sshtunnel/master/debian8/vars.conf"
# edit projek export KEY_NAME="white-vps"
# Save dan keluar dari editor

# generate Diffie hellman parameters
openssl dhparam -out /etc/openvpn/dh2048.pem 2048

# inialisasikan Public Key
cd /etc/openvpn/easy-rsa
. ./vars
./clean-all
# Certificate Authority (CA)
./build-ca

# buat server key name yang telah kita buat sebelum nya yakni "white-vps"
./build-key-server white-vps

# generate ta.key
openvpn --genkey --secret keys/ta.key

# Buat config server UDP
cd /etc/openvpn

cat > /etc/openvpn/server-udp.conf <<-END
port 1194
proto udp
dev tun
ca easy-rsa/keys/ca.crt
cert easy-rsa/keys/white-vps.crt
key easy-rsa/keys/white-vps.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
client-cert-not-required
username-as-common-name
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 30
comp-lzo
persist-key
persist-tun
status server-udp.log
verb 3
END

# Buat config server TCP
cd /etc/openvpn

cat > /etc/openvpn/server-tcp.conf <<-END
port 1194
proto tcp
dev tun
ca easy-rsa/keys/ca.crt
cert easy-rsa/keys/white-vps.crt
key easy-rsa/keys/white-vps.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
client-cert-not-required
username-as-common-name
server 10.9.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 30
comp-lzo
persist-key
persist-tun
status server-tcp.log
verb 3
END

cp /etc/openvpn/easy-rsa/keys/{white-vps.crt,white-vps.key,ca.crt,ta.key} /etc/openvpn
ls /etc/openvpn

# nano /etc/default/openvpn
sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn
# Cari pada baris #AUTOSTART=”all” hilangkan tanda pagar # didepannya sehingga menjadi AUTOSTART=”all”. Save dan keluar dari editor

# restart openvpn dan cek status openvpn
/etc/init.d/openvpn restart
/etc/init.d/openvpn status

# aktifkan ip4 forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
# edit file sysctl.conf
# nano /etc/sysctl.conf
# Uncomment hilangkan tanda pagar pada #net.ipv4.ip_forward=1

# firewall untuk memperbolehkan akses UDP dan akses jalur TCP
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.9.0.0/24 -o eth0 -j MASQUERADE
iptables-save

# iptables-persistent
apt-get -y install iptables-persistent
/etc/init.d/openvpn restart

# Konfigurasi dan Setting untuk Client
mkdir clientconfig
cp /etc/openvpn/easy-rsa/keys/{white-vps.crt,white-vps.key,ca.crt,ta.key} clientconfig/
cd clientconfig


# Buat 2 file berektensi .ovpn
# nano config-udp.ovpn
# Buat config server TCP 1194
cd /etc/openvpn

cat > /etc/openvpn/client-udp.ovpn <<-END
##### WELCOME TO KangDaQiQSSH #####
##### FREE & GRATIS #####
##### DONT FORGET TO DOAKAN SAYA #####
client
dev tun
proto udp
# proto tcp ===>> hapus uncomment tanda # jika ingin menggunakan proto tcp
remote 13.76.47.110 1194
resolv-retry infinite
route-method exe
resolv-retry infinite
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/client-udp.ovpn;

# pada tulisan xxx ganti dengan alamat ip address VPS anda
# Buat config server TCP 1194

cd /etc/openvpn

cat > /etc/openvpn/client-tcp.ovpn <<-END
##### WELCOME TO KangDaQiQSSH #####
##### FREE & GRATIS #####
##### DONT FORGET TO DOAKAN SAYA #####
client
dev tun
proto tcp
# proto udp ===>> hapus uncomment tanda # jika ingin menggunakan proto udp
remote 13.76.47.110 1194
resolv-retry infinite
route-method exe
resolv-retry infinite
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/client-tcp.ovpn;

# masukkan certificatenya ke dalam config client TCP 1194
echo '<ca>' >> /etc/openvpn/client-tcp.ovpn
cat /etc/openvpn/ca.crt >> /etc/openvpn/client-tcp.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp.ovpn

# masukkan certificatenya ke dalam config client UDP 1194
echo '<ca>' >> /etc/openvpn/client-udp.ovpn
cat /etc/openvpn/ca.crt >> /etc/openvpn/client-udp.ovpn
echo '</ca>' >> /etc/openvpn/client-udp.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( TCP 1194 )
cp /etc/openvpn/client-tcp.ovpn /home/vps/public_html/client-tcp.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( UDP 1194 )
cp /etc/openvpn/client-udp.ovpn /home/vps/public_html/client-udp.ovpn

# pada tulisan xxx ganti dengan alamat ip address VPS anda 
/etc/init.d/openvpn restart

# hapus file .sh
cd
rm -f /root/ssh-vpn-debian8.sh

echo "========================  ... Selesai install OpenVPN ... ============================"
echo "======================================================================================"

echo "......................................................................................"
echo "......................................................................................"
