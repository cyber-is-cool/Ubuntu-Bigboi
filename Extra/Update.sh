#! /bin/bash

# Global variables
DISTRO=$(lsb_release -i | cut -d: -f2 | sed "s/\\t//g")
CODENAME=$(lsb_release -c | cut -d: -f2 | sed "s/\\t//g")

main_apt () {

    local ubuntu_sources="
deb http://us.archive.ubuntu.com/ubuntu/ CHANGEME main restricted\n
deb http://us.archive.ubuntu.com/ubuntu/ CHANGEME-updates main restricted\n
deb http://us.archive.ubuntu.com/ubuntu/ CHANGEME universe\n
deb http://us.archive.ubuntu.com/ubuntu/ CHANGEME-updates universe\n
deb http://us.archive.ubuntu.com/ubuntu/ CHANGEME multiverse\n
deb http://us.archive.ubuntu.com/ubuntu/ CHANGEME-updates multiverse\n
deb http://us.archive.ubuntu.com/ubuntu/ CHANGEME-backports main restricted universe multiverse\n
deb http://security.ubuntu.com/ubuntu CHANGEME-security main restricted\n
deb http://security.ubuntu.com/ubuntu CHANGEME-security universe\n
deb http://security.ubuntu.com/ubuntu CHANGEME-security multiverse\n

deb-src http://us.archive.ubuntu.com/ubuntu/ CHANGEME main restricted\n
deb-src http://us.archive.ubuntu.com/ubuntu/ CHANGEME-updates main restricted\n
deb-src http://us.archive.ubuntu.com/ubuntu/ CHANGEME universe\n
deb-src http://us.archive.ubuntu.com/ubuntu/ CHANGEME-updates universe\n
deb-src http://us.archive.ubuntu.com/ubuntu/ CHANGEME multiverse\n
deb-src http://us.archive.ubuntu.com/ubuntu/ CHANGEME-updates multiverse\n
deb-src http://us.archive.ubuntu.com/ubuntu/ CHANGEME-backports main restricted universe multiverse\n
deb-src http://security.ubuntu.com/ubuntu CHANGEME-security main restricted\n
deb-src http://security.ubuntu.com/ubuntu CHANGEME-security universe\n
deb-src http://security.ubuntu.com/ubuntu CHANGEME-security multiverse\n
"

    local debian_sources="
deb http://deb.debian.org/debian CHANGEME main\n
deb-src http://deb.debian.org/debian CHANGEME main\n
deb http://deb.debian.org/debian-security/ CHANGEME/updates main\n
deb-src http://deb.debian.org/debian-security/ CHANGEME/updates main\n
deb http://deb.debian.org/debian CHANGEME-updates main\n
deb-src http://deb.debian.org/debian CHANGEME-updates main\n
"

    sudo cp -r /etc/apt/sources.list* backup/apt/ 
    sudo rm -f /etc/apt/sources.list 
    case $DISTRO in 
        Debian)
            echo -e $debian_sources | sed "s/ deb/deb/g; s/CHANGEME/${CODENAME}/g" | sudo tee /etc/apt/sources.list > /dev/null
            ;;
        Ubuntu)
            echo -e $ubuntu_sources | sed "s/ deb/deb/g; s/CHANGEME/${CODENAME}/g" | sudo tee /etc/apt/sources.list > /dev/null
            ;;
        *)  
            sudo cp backup/apt/sources.list /etc/apt/sources.list
            clear
            echo "Distro BAD"
            exit 1
            ;;

    esac
    
    sudo apt install -y unattended-upgrades apt-listchanges
    
    # Set automatic updates
    echo 'APT::Periodic::Update-Package-Lists "1";'             | sudo tee /etc/apt/apt.conf.d/10periodic > /dev/null
    echo 'APT::Periodic::Download-Upgradeable-Packages "1";'    | sudo tee -a /etc/apt/apt.conf.d/10periodic > /dev/null
    echo 'APT::Periodic::Unattended-Upgrade "1";'               | sudo tee -a /etc/apt/apt.conf.d/10periodic > /dev/null
    echo 'APT::Periodic::AutocleanInterval "7";'                | sudo tee -a /etc/apt/apt.conf.d/10periodic > /dev/null

    echo 'APT::Periodic::Update-Package-Lists "1";'             | sudo tee /etc/apt/apt.conf.d/20auto-upgrades > /dev/null
    echo 'APT::Periodic::Download-Upgradeable-Packages "1";'    | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades > /dev/null
    echo 'APT::Periodic::Unattended-Upgrade "1";'               | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades > /dev/null
    echo 'APT::Periodic::AutocleanInterval "7";'                | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades > /dev/null
    clear
    sudo apt install -y ufw
    
    clear
    sudo apt install -y tmux
    
    clear
    sudo apt install -y vim
    
    clear
    sudo apt install -y unhide
    
    clear
    sudo apt install -y auditd
    
    clear
    sudo apt install -y psad
    
    clear
    sudo apt install -y fail2ban
    
    clear
    sudo apt install -y aide
    
    clear
    sudo apt install -y tcpd
    
    clear
    sudo apt install -y libpam-cracklib
    
    clear
    sudo apt install -y tree
    
    clear
    sudo apt update && sudo apt upgrade -y
    
    clear

    arr=(john
abc
sqlmap
aria2
aquisition
bitcomet
bitlet
bitspirit
endless-sky
zenmap
minetest
minetest-server
armitage
crack
apt pureg knocker
aircrack-ng
airbase-ng
hydra
freeciv
wireshark
tshark
hydra-gtk
netcat
netcat-traditional
netcat-openbsd
netcat-ubuntu
netcat-minimal
qbittorrent
ctorrent
ktorrent
rtorrent
deluge
transmission-common
transmission-bittorrent-client
tixati
frostwise
vuse
irssi
transmission-gtk
utorrent
kismet
medusa
telnet
exim4
telnetd
bind9
crunch
tcpdump
tomcat
tomcat6
vncserver
tightvnc
tightvnc-common
tightvncserver
vnc4server
nmdb
dhclient
telnet-server
ophcrack
cryptcat
cups
cupsd
tcpspray
ettercap
wesnoth
snort
pryit
weplab
wireshark
nikto
lcrack
postfix
snmp
icmp
dovecot
pop3
p0f
dsniff
hunt
ember
nbtscan
rsync
freeciv-client-extras
freeciv-data
freeciv-server
freeciv-client-gtk
xinetd
apport
autofs
avahi
beep
git
pastebinit
popularity-contest
rsh
rsync
talk
telnet
whoopsie
yp-tools
ypbind
                    )

    for i in "${arr[@]}"
    do
        sudo apt purge -y $i
        sleep .5
        clear
    done

    sudo apt autoremove
}


# Function to run everything
main () {
    clear
    # Make the backup directories

    mkdir -p backup/apt

    echo apt fast install
    
    # Apt fast install (different for ubuntu and debian)
    case $DISTRO in 
        Ubuntu)
            sudo apt install -y software-properties-common
            sudo add-apt-repository ppa:apt-fast/stable -y
            ;;
        Debian)
            sudo rm -f /etc/apt/sources.list.d/*
            echo "deb http://ppa.launchpad.net/apt-fast/stable/ubuntu bionic main" | sudo tee /etc/apt/sources.list.d/apt-fast.list > /dev/null
            echo "deb-src http://ppa.launchpad.net/apt-fast/stable/ubuntu bionic main" | sudo tee -a /etc/apt/sources.list.d/apt-fast.list > /dev/null
            sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A2166B8DE8BDC3367D1901C11EE2FF37CA8DA16B
            ;;
    esac

    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt install -y apt-fast && APT=apt-fast

    # Each main section
    main_apt

}
main
