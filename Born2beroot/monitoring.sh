# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jmartin <marvin@42lausanne.ch>             +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/11/15 11:54:27 by jmartin           #+#    #+#              #
#    Updated: 2021/11/17 17:39:24 by jmartin          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

wall
'#Architecture: ' `uname -a` \
'\n#CPU physical: ' \
'\n#vCPU: ' \
'\n#Memory Usage: ' \
'\n#Disk Usage: ' \
'\n#CPU load: ' \
'\n#Last boot: ' \
'\n#LVM use: ' \
'\n#Connexions TCP: ' \
'\n#User log: ' \
'\n#Network: IP' `hostname -I` `sudo ifconfig | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'` \
'\n#Sudo: '
