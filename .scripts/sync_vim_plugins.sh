#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\e[0;33m'
NC='\033[0m' # No Color

PLUGNUM="$(wc --lines ~/.vimplugins | grep -o '[0-9]*')"

echo -e "\n${YELLOW}Starting sync of $PLUGNUM Vim plugins${NC}\n"
mkdir -p ~/.vim/pack/plugins/start/ ~/vimfiles/pack/plugins/start/

counter=1
p="$HOME/.vimplugins"

while read p; do

    echo "========================================="
    echo -e "\n[${GREEN}PLUGIN $counter/$PLUGNUM${NC}: ${CYAN}$p${NC}]\n"

    DIR="${p##*/}"
    PATH1="$HOME/.vim/pack/plugins/start"
    PATH2="$HOME/vimfiles/pack/plugins/start"

    if [ -d "$PATH1/$DIR/.git" ]; then
        echo -ne "${CYAN}~/.vim:     ${NC}"
        git -C $PATH1/$DIR/ reset --hard HEAD >/dev/null
        git -C $PATH1/$DIR/ pull
    else
        echo -ne "${CYAN}~/.vim:     ${NC}"
        git -C $PATH1 clone https://github.com/$p.git
    fi

    if [ -d "$PATH2/$DIR/.git" ]; then
        echo -ne "${CYAN}~/vimfiles: ${NC}"
        git -C $PATH2/$DIR/ reset --hard HEAD >/dev/null
        git -C $PATH2/$DIR/ pull
    else
        echo -ne "${CYAN}~/vimfiles: ${NC}"
        git -C $PATH2 clone https://github.com/$p.git
    fi
    echo

    ((counter++))

done < "$p"

echo "========================================="
echo -e "\n${YELLOW}Finished syncing of $PLUGNUM Vim plugins.${NC}\n"