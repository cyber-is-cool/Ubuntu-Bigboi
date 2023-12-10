#! /bin/bash


cp /etc/login.defs login.copy.defs
mv login.defs /etc/login.defs

# Global variables
USERS=$(grep -E "/bin/.*sh" /etc/passwd | grep -v -e root -e `whoami` -e speech-dispatcher | cut -d":" -f1)

DISTRO=$(lsb_release -i | cut -d: -f2 | sed "s/\\t//g")
CODENAME=$(lsb_release -c | cut -d: -f2 | sed "s/\\t//g")

sys_accounts() {

l_output=""
l_output2=""
l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
a_users=(); a_ulock=() # initialize arrays
while read -r l_user; do # change system accounts that have a valid login shell to nolog shell
echo -e " - System account \"$l_user\" has a valid logon shell, changing shell to \"$(which nologin)\""
usermod -s "$(which nologin)" "$l_user"
done < <(awk -v pat="$l_valid_shells" -F: '($1!~/(root|sync|shutdown|halt|^\+)/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $(NF) ~ pat) { print $1 }' /etc/passwd)
while read -r l_ulock; do # Lock system accounts that aren't locked
echo -e " - System account \"$l_ulock\" is not locked, locking account"
usermod -L "$l_ulock"
done < <(awk -v pat="$l_valid_shells" -F: '($1!~/(root|^\+)/ && $2!~/LK?/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $(NF) ~ pat) {print $1 }' /etc/passwd)

}





sudo apt install -y libpam-cracklib fail2ban
clear

    ## remove guest
    sudo mkdir -p /etc/lightdm/lightdm.conf.d
    sudo touch /etc/lightdm/lightdm.conf.d/myconfig.conf

    echo "[SeatDefaults]"                   | sudo tee /etc/lightdm/lightdm.conf.d/myconfig.conf > /dev/null
    echo "autologin-user=``"                | sudo tee -a /etc/lightdm/lightdm.conf.d/myconfig.conf > /dev/null
    echo "allow-guest=false"                | sudo tee -a /etc/lightdm/lightdm.conf.d/myconfig.conf > /dev/null
    echo "greeter-hide-users=true"          | sudo tee -a /etc/lightdm/lightdm.conf.d/myconfig.conf > /dev/null
    echo "greeter-show-manual-login=true"   | sudo tee -a /etc/lightdm/lightdm.conf.d/myconfig.conf > /dev/null
    echo "greeter-allow-guest=false"        | sudo tee -a /etc/lightdm/lightdm.conf.d/myconfig.conf > /dev/null
    echo "autologin-guest=false"            | sudo tee -a /etc/lightdm/lightdm.conf.d/myconfig.conf > /dev/null
    echo "AutomaticLoginEnable=false"       | sudo tee -a /etc/lightdm/lightdm.conf.d/myconfig.conf > /dev/null
    echo "xserver-allow-tcp=false"          | sudo tee -a /etc/lightdm/lightdm.conf.d/myconfig.conf > /dev/null
    
    sudo lightdm --test-mode --debug 2> lightdm_setup.log
    CONFIGSET=$(grep myconfig.conf lightdm_setup.log)  
    if [[ -z CONFIGSET ]] 
    then 
        echo "LightDM config not set, please check manually"
        read -rp "Press <enter> to continue"
    fi

    service lightdm restart
    
    
    # UID 0

    UIDS=$(cut /etc/passwd -d: -f1,3 | grep -v root)
    for i in $UIDS
    do 
        username=$(echo $i | cut -d: -f1)
        user_uid=$(echo $i | cut -d: -f2)
        if [[ $user_uid -eq "0" ]]
        then 
            echo "Found a root UID user ${username}"
            read -rp $'Press <enter> to continue\n'
        fi
    done

    #empty password
    SHADOW=$(sudo cat /etc/shadow)
    for line in $SHADOW
    do 
        password_hash=$(echo $line | cut -d: -f2)
        account=$(echo $line | cut -d: -f1)
        if [[ -z $password_hash  ]];
        then 
            echo "{account}"
            read -rp $'Press <enter> to continue\n'
        fi
    done


    # disable_guests
    

    # Replace the arguments
    
    sudo sed -ie "s/PASS_MAX_DAYS.*/PASS_MAX_DAYS\\t90/" /etc/login.defs
    sudo sed -ie "s/PASS_MIN_DAYS.*/PASS_MIN_DAYS\\t10/" /etc/login.defs
    sudo sed -ie "s/PASS_WARN_AGE.*/PASS_WARN_AGE\\t7/" /etc/login.defs
    sudo sed -ie "s/FAILLOG_ENAB.*/FAILLOG_ENAB\\tyes/" /etc/login.defs
    sudo sed -ie "s/LOG_UNKFAIL_ENAB.*/LOG_UNKFAIL_ENAB\\tyes/" /etc/login.defs
    sudo sed -ie "s/LOG_OK_LOGINS.*/LOG_OK_LOGINS\\tyes/" /etc/login.defs
    sudo sed -ie "s/SYSLOG_SU_ENAB.*/SYSLOG_SU_ENAB\\tyes/" /etc/login.defs
    sudo sed -ie "s/SYSLOG_SG_ENAB.*/SYSLOG_SG_ENAB\\tyes/" /etc/login.defs
    sudo sed -ie "s/LOGIN_RETRIES.*/LOGIN_RETRIES\\t5/" /etc/login.defs
    sudo sed -ie "s/ENCRYPT_METHOD.*/ENCRYPT_METHOD\\tSHA512/" /etc/login.defs
    sudo sed -ie "s/LOGIN_TIMEOUT.*/LOGIN_TIMEOUT\\t60/" /etc/login.defs
    sudo sed -ie "s/UMASK.*/UMASK\\t027/" /etc/login.defs
    useradd -D -f 30
    #sudo sed -ie "s/# difok.*/difok\\t60/" /etc/security/pwquality.conf
    #sudo sed -ie "s/difok.*/difok\\t60/" /etc/security/pwquality.conf
    
   #sudo sed -ie "s/# dictcheck.*/dictcheck =\\t1/" /etc/security/pwquality.conf
    #sudo sed -ie "s/dictcheck.*/dictcheck =\\t1/" /etc/security/pwquality.conf    
    
   ## RANBEFORE=$(grep "pam_tally2.so" /etc/pam.d/common-auth)
   ## if [[ -z $RANBEFORE ]]
   # then 
   #     echo "auth required pam_tally2.so deny=5 onerr=fail unlock_time=1800 audit even_deny_root silent" | sudo tee -a /etc/pam.d/common-auth > /dev/null
   # fi
    
    #sudo sed -i 's/nullok//g' /etc/pam.d/common-auth
    
    
    
    #secure system accounts
    /usr/bin/env bash use/sys_accounts.sh
    # GUID ROOT 0
    usermod -g 0 root
    passwd -l root
    
    
    {
l_output="" l_output2=""
l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
a_users=(); a_ulock=() # initialize arrays
while read -r l_user; do # change system accounts that have a valid login shell to nolog shell
echo -e " - System account \"$l_user\" has a valid logon shell, changing shell to \"$(which nologin)\""
usermod -s "$(which nologin)" "$l_user"
done < <(awk -v pat="$l_valid_shells" -F: '($1!~/(root|sync|shutdown|halt|^\+)/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $(NF) ~ pat) { print $1 }' /etc/passwd)
while read -r l_ulock; do # Lock system accounts that aren't locked
echo -e " - System account \"$l_ulock\" is not locked, locking account"
usermod -L "$l_ulock"
done < <(awk -v pat="$l_valid_shells" -F: '($1!~/(root|^\+)/ && $2!~/LK?/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $(NF) ~ pat) {print $1 }' /etc/passwd)
	}

	echo $l_output
	echo $l_output2

read -p "Locking service accounts"
clear	
{
declare -A HASH_MAP=( ["y"]="yescrypt" ["1"]="md5" ["2"]="blowfish"["5"]="SHA256" ["6"]="SHA512" ["g"]="gost-yescrypt" )
CONFIGURED_HASH=$(sed -n "s/^\s*ENCRYPT_METHOD\s*\(.*\)\s*$/\1/p" /etc/login.defs)
for MY_USER in $(sed -n "s/^\(.*\):\\$.*/\1/p" /etc/shadow)
do
CURRENT_HASH=$(sed -n "s/${MY_USER}:\\$\(.\).*/\1/p" /etc/shadow)
if [[ "${HASH_MAP["${CURRENT_HASH}"]^^}" != "${CONFIGURED_HASH^^}" ]];
then
echo "The password for '${MY_USER}' is using '${HASH_MAP["${CURRENT_HASH}"]}' instead of the configured '${CONFIGURED_HASH}'."
fi
done
}
read -p "Users that dont use current encryption standerd"


clear

/usr/bin/env bash use/log.sh    
read -p "?"
clear
    
clear
awk -F: '($2 == "" ) { print $1 " does not have a password "}' /etc/shadow
read -p "No password users"
sed -e 's/^\([a-zA-Z0-9_]*\):[^:]*:/\1:x:/' -i /etc/passwd

for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do
	grep -q -P "^.*?:[^:]*:$i:" /etc/group
	if [ $? -ne 0 ]; then
		echo "Group $i is referenced by /etc/passwd but does not exist in /etc/group"
	fi
done
read -p "Group"
sed -ri 's/(^shadow:[^:]*:[^:]*:)([^:]+$)/\1/' /etc/group

while read -r l_count l_uid; do
	if [ "$l_count" -gt 1 ]; then
	echo -e "Duplicate UID: \"$l_uid\" Users: \"$(awk -F: '($3 == n) { print $1 }' n=$l_uid /etc/passwd | xargs)\""
fi
done < <(cut -f3 -d":" /etc/passwd | sort -n | uniq -c)
read -p "Duplicate UID"

cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do
	echo "Duplicate GID ($x) in /etc/group"
done
read -p "duplicate GIDs"
cut -d: -f1 /etc/passwd | sort | uniq -d | while read -r x; do
	echo "Duplicate login name $x in /etc/passwd"
done
read -p "duplicate usernames"

cut -d: -f1 /etc/group | sort | uniq -d | while read -r x; do
	echo "Duplicate group name $x in /etc/group"
done
read -p "duplicate group names"
read -p "CLEAR"
clear
RPCV="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"
echo "$RPCV" | grep -q "::" && echo "root's path contains a empty directory (::)"
echo "$RPCV" | grep -q ":$" && echo "root's path contains a trailing (:)"
for x in $(echo "$RPCV" | tr ":" " "); do
	if [ -d "$x" ]; then
	ls -ldH "$x" | awk '$9 == "." {print "PATH contains current working directory (.)"} $3 != "root" {print $9, "is not owned by root"} substr($1,6,1) != "-" {print $9, "is group writable"} substr($1,9,1) != "-" {print $9, "is world writable"}'
else
	echo "$x is not a directory"
fi
done
read -p "Root intergerty check"
	awk -F: '($3 == 0) { print $1 }' /etc/passwd
read -p "Should be root -=- UID 0"

clear
/usr/bin/env bash use/home.sh    
read -p "cont ---"
clear
/usr/bin/env bash use/dot.sh
read -p "cont ---"
