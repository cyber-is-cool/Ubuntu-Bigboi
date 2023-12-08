sudo apt install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

unzip U_CAN_Ubuntu_20-04_LTS_V1R10_STIG_Ansible.zip -n
unzip ubuntu2004STIG-ansible.zip -n

/bin/bash enforce.sh
