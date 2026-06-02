#!/bin/bash
# Location: $HOME/Banner-Pro/banner-setup.sh

# ==========================================
# 🎨 COLOR VARIABLES
# ==========================================
RESET="\e[0m"
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
MAGENTA="\e[1;35m"
CYAN="\e[1;36m"
WHITE="\e[1;37m"

# ==========================================
# 🛠 HELPER FUNCTIONS (Professional Format)
# ==========================================
print_step() {
    echo -e "${MAGENTA}[*] $1${RESET}"
}

print_success() {
    echo -e "${GREEN}[+] $1${RESET}"
}

print_error() {
    echo -e "${RED}[!] Error: $1${RESET}"
}

print_info() {
    echo -e "${BLUE}[i] $1${RESET}"
}

print_warning() {
    echo -e "${YELLOW}[~] $1${RESET}"
}

# ==========================================
# ⚙️ DIRECTORY & BACKUP 
# ==========================================
DIR="$HOME/Banner-Pro"
if [ ! -d "$DIR" ]; then
  print_error "Directory not found."
  print_info "Please run from: cd \$HOME/Banner-Pro"
  exit 1
fi

BASHRC="$PREFIX/etc/bash.bashrc"
MOTD="$PREFIX/etc/motd"

backup_files() {
    print_step "Checking backups..."
    if [ ! -f "$BASHRC.bak" ]; then
        cp "$BASHRC" "$BASHRC.bak"
        print_success "Backed up bash.bashrc"
    fi
    if [ ! -f "$MOTD.bak" ] && [ -f "$MOTD" ]; then
        cp "$MOTD" "$MOTD.bak"
        print_success "Backed up motd"
    fi
}

# =============================================================
# 🎨 TERMINAL COLOR & THEME FUNCTION (Dracula Vibrant)
# =============================================================
apply_theme() {
    print_step "Applying Vibrant Dark Theme (Dracula Style)..."
    
    # Create termux folder if not exists
    mkdir -p "$HOME/.termux"
    
    # Write color codes to properties
    cat <<EOF > "$HOME/.termux/colors.properties"
# Dracula Vibrant Dark Theme
background=#282A36
foreground=#F8F8F2
cursor=#F8F8F2
color0=#21222C
color8=#6272A4
color1=#FF5555
color9=#FF6E6E
color2=#50FA7B
color10=#69FF94
color3=#F1FA8C
color11=#FFFFA5
color4=#BD93F9
color12=#D6ACFF
color5=#FF79C6
color13=#FF92DF
color6=#8BE9FD
color14=#A4FFFF
color7=#F8F8F2
color15=#FFFFFF
EOF

    # Reload termux to apply colors immediately
    termux-reload-settings
    print_success "Terminal color theme updated successfully!"
}

# ==========================================
# 🚀 APPLY BANNER ARROW - PS1 DESIGN 
# ==========================================
apply_banner() {
    local BANNER_FILE=$1
    local IS_SCRIPT=$2

    backup_files
    
    # Hide default motd
    rm -rf "$MOTD" 2>/dev/null
    touch "$MOTD"

    # Clean old banner & PS1 settings
    sed -i '/# BANNER-PRO START/,/# BANNER-PRO END/d' "$BASHRC"

    print_step "Applying new configuration..."
    echo "# BANNER-PRO START" >> "$BASHRC"
    echo "clear" >> "$BASHRC"
    
    if [ "$IS_SCRIPT" == "true" ]; then
        echo "bash $DIR/banner-logo/$BANNER_FILE" >> "$BASHRC"
    else
        echo "cat $DIR/banner-logo/images/$BANNER_FILE | lolcat" >> "$BASHRC"
    fi

    # 💡  Shortcut for CyberMatrix    
    echo "alias matrix='cmatrix -b -s -C cyan'" >> "$BASHRC"

    # 🔥 Hacker Style Arrow (PS1 Customization)
    echo 'PS1="\n\[\e[1;36m\]┌──[\[\e[1;32m\]\u\[\e[1;36m\]]──[\[\e[1;34m\]\w\[\e[1;36m\]]\n\[\e[1;36m\]└──► \[\e[0m\]"' >> "$BASHRC"

    echo "# BANNER-PRO END" >> "$BASHRC"
    print_success "Banner & Terminal Prompt configured."

    # 🎨 Y/N မေးပြီး Theme ပြောင်းမည့်အပိုင်း
    echo ""
    print_info "Do you want to apply the Vibrant Dark Terminal Theme?"
    read -p "  👉 Choose (Y/N): " choose

    if [[ "$choose" == "Y" || "$choose" == "y" || "$choose" == "Yes" || "$choose" == "yes" ]]; then
        echo ""
        apply_theme
    else
        echo ""
        print_info "Skipped terminal theme. Keeping current colors."
    fi

    echo ""
    print_success "Setup is 100% Complete! Restart your Termux to see changes."
    sleep 3
}

# ==========================================
# 🖥 MAIN MENU
# ==========================================
while true; do
    clear
    echo -e "${CYAN}=========================================${RESET}"
    echo -e "${GREEN}         BANNER-PRO SETUP MENU (V3)      ${RESET}"
    echo -e "${CYAN}=========================================${RESET}"
    echo -e "${WHITE}  [1]${RESET} Alien Banner"
    echo -e "${WHITE}  [2]${RESET} Hacker Banner"
    echo -e "${WHITE}  [3]${RESET} Cyborg Banner"
    echo -e "${WHITE}  [4]${RESET} Cyber Matrix (Jarvis Edition) 🌟"
    echo -e "${WHITE}  [5]${RESET} Restore Original Termux"
    echo -e "${WHITE}  [6]${RESET} Exit"
    echo -e "${CYAN}=========================================${RESET}"
    read -p "Select an option (1-6): " opt

    case $opt in
        1) apply_banner "Alien.txt" "false" ;;
        2) apply_banner "Hacker.txt" "false" ;;
        3) apply_banner "Cyborg.txt" "false" ;;
        4) apply_banner "cyber.sh" "true" ;;
        5) 
           print_step "Restoring original settings..."
           bash "$DIR/banner-logo/restore-original.sh"
           sleep 2
           ;;
        6) 
           print_success "Exiting... Happy Coding!"
           exit 0 
           ;;
        *) 
           print_warning "Invalid Option. Try again."
           sleep 1
           ;;
    esac
done

