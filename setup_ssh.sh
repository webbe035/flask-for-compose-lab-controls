#!/bin/bash

# Set the devices here
watchtowers=($(seq -w 1 16) $(seq -w 21 35) $(seq -w 41 54))
autobots=($(seq -w 1 10))
storage="duckietown06"
storage_password="IDSCrocks2019"

# FOR ROHIT ssh-add ~/.ssh/DT18_key_00 and it need to be chmod 600
# Step 1: Check DT18 key exists already in .ssh. If not, find it in duckietown-shell and copy.
if [[ -f /home/$USER/.ssh/DT18_key_00 && -f /home/$USER/.ssh/DT18_key_00.pub ]];
then
    echo "Found DT18_key_00 in .ssh!"
    chmod 600 /home/$USER/.ssh/DT18_key_00
    chmod 644 /home/$USER/.ssh/DT18_key_00.pub
    ssh-add /home/$USER/.ssh/DT18_key_00
else
    echo "Couldn't find required ssh keys in .ssh. Looking for duckietown-shell"
    if [[ -f /home/$USER/.dt-shell/commands/init_sd_card/DT18_key_00 && -f /home/$USER/.dt-shell/commands/init_sd_card/DT18_key_00.pub ]];
    then
        echo "Found DT18_key_00 in duckietown-shell. Copying to .ssh!"
        cp /home/$USER/.dt-shell/commands/init_sd_card/DT18_key_00* /home/$USER/.ssh/
        chmod 600 /home/$USER/.ssh/DT18_key_00
        chmod 644 /home/$USER/.ssh/DT18_key_00.pub
        ssh-add /home/$USER/.ssh/DT18_key_00
    else
        echo "Couldn't find DT18_key_00. Is duckietown-shell installed?"
        exit 1;
    fi
fi

# Step 2: Iterate through watchtowers
for idx in ${!watchtowers[*]}
do

    printf "Setting up watchtower%s.. " ${watchtowers[$idx]}

    cat >> /home/$USER/.ssh/config <<- EOM
# --- setup_ssh.sh generated ---

Host watchtower${watchtowers[$idx]}
    User mom
    Hostname watchtower${watchtowers[$idx]}.local
    IdentityFile /home/$USER/.ssh/DT18_key_00
    StrictHostKeyChecking no
# ------------------------------
EOM
    # Probably don't need this
    # sshpass -p MomWatches ssh-copy-id -f -i /home/$USER/.ssh/DT18_key_00 watchtower${watchtowers[$idx]} -p 22

    printf "Done!\n"
done

# Step 3: Iterate through autobots
for idx in ${!autobots[*]}
do

    printf "Setting up autobot%s.. " ${autobots[$idx]}

    cat >> /home/$USER/.ssh/config <<- EOM

# --- setup_ssh.sh generated ---

Host autobot${autobots[$idx]}
    User duckie
    Hostname autobot${autobots[$idx]}.local
    IdentityFile /home/$USER/.ssh/DT18_key_00
    StrictHostKeyChecking no
# ------------------------------

EOM

    # Probably don't need this
    # sshpass -p quackquack ssh-copy-id -f -i /home/$USER/.ssh/DT18_key_00 autobot${autobots[$idx]} -p 22

    printf "Done!\n"
done



# # Step 4: Setup Storage
# printf "Setting up storage at %s.." ${storage}
#
# cat >> /home/$USER/.ssh/config <<- EOM
#
# # --- setup_ssh.sh generated ---
#
# Host ${storage}
#     User aido2
#     Hostname ${storage}.local
#     IdentityFile /home/$USER/.ssh/DT18_key_00
#     StrictHostKeyChecking no
# # ------------------------------
#
# EOM
# printf "Done!\n"
#
# # Uncomment this line to set up a new storage server
# # sshpass -p ${storage_password} ssh-copy-id -f -i /home/$USER/.ssh/DT18_key_00 ${storage} -p 22
#
# echo "alias mount-aido=\"mkdir -p ~/AIDO2_experiment_data; sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 duckietown06:/home/aido2/AIDO2_experiment_data ~/AIDO2_experiment_data\"" >> ~/.bashrc
# echo "alias unmount-aido=\"fusermount -u ~/AIDO2_experiment_data\"" >> ~/.bashrc
# echo "alias mount-aido=\"mkdir -p ~/AIDO2_experiment_data; sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 duckietown06:/home/aido2/AIDO2_experiment_data ~/AIDO2_experiment_data\"" >> ~/.zshrc
# echo "alias unmount-aido=\"fusermount -u ~/AIDO2_experiment_data\"" >> ~/.zshrc
#
# RED='\033[0;31m'
# NC='\033[0m' # No Color
#
# printf "${RED}"
# printf "\n\n\n[IMPORTANT]\n"
# printf "Open a new terminal for changes to take place\n\n"
# printf "${NC}"
