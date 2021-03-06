# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmartin <jmartin@student.42lausanne.ch>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/11/15 11:54:27 by jmartin           #+#    #+#              #
#    Updated: 2021/11/18 17:29:15 by jmartin          ###   ########.fr        #
# **************************************************************************** #

#!/bin/bash

archi=$(uname -a)

cpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)

ram_u=$(free --mega -t | awk -vORS=' ' '{print $3}' | awk '{print $2"M"}')
ram_t=$(free --giga -t | awk -vORS=' ' '{print $2}' | awk '{print $2"G"}')
ram_p=$(free -t | awk 'NR == 2 {$4=$3/$2*100; printf("%.1f%%"), $4}')

disk_u=$(df -h --output=used --total | awk 'END {print $1}')
disk_t=$(df -h --output=size --total | awk 'END {print $1}')
disk_p=$(df --total | grep 'total' | rev | cut -d ' ' -f 2 | rev)

cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

boot=$(who -b | awk '{print $(NF-1) " " $(NF-0)}')

lvmt=$(lsblk | grep "lvm" | wc -l)
lvm=$(if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi)

tcp=$(netstat -a | grep 'ESTABLISHED' | wc -l)
user=$(who | wc -l)

ip=$(hostname -I)
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')

sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "
#Architecture: $archi
#CPU physical: $cpu
#vCPU: $vcpu
#Memory Usage: $ram_u/$ram_t ($ram_p)
#Disk Usage: $disk_u/$disk_t ($disk_p)
#CPU load: $cpul
#Last boot: $boot
#LVM use: $lvm
#Connexions TCP: $tcp ESTABLISHED
#User log:  $user
#Network: IP $ip ($mac)
#Sudo: $sudo cmd"
