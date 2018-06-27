#!/bin/sh

#  ssh_load.command
#  nvidia_monitor
#
#  Created by Ivan Sahumbaiev on 25/06/2018.
#  Copyright © 2018 Ivan Sahumbaiev. All rights reserved.


user=$1
host=$2
password=$3
nvidia_command="nvidia-smi --query-gpu=name,index,temperature.gpu,utilization.gpu --format=csv"

/usr/bin/expect << EOF

spawn ssh "$user\@$host"
expect "$user\@$host's password:"
send "$password\r"
expect "$ "
send "$nvidia_command\r"
send "exit\r"
expect "$ "

EOF
