#!/bin/bash

SCRIPT_FILE="$0"

if [ -L "$0" ]; then
    SCRIPT_FILE=$(realpath "$0")
fi

SCRIPT_PATH=$(dirname "$SCRIPT_FILE")
cd $SCRIPT_PATH

GIT_HOOK_PATH=".git/hooks"
GIT_HOOK_RELATIVE_PATH="../.."

HOOK_PATH=hooks
HOOK_FILES="$HOOK_PATH/*"

INSTALL_SCRIPT="$(basename $SCRIPT_FILE)"


symbolic_link(){
    if [ -f "$2" ]; then
        if [ $(readlink "$2") == "$1" ]; then
            return 0
        fi
    fi

    echo ""
    if [ -f "$2" -a ! -L "$2" ]; then
        echo "Current file stored $2 -> $2.old"
        mv "$2" "$2.old"
    fi
        
    if [ -f "$2" ]; then
        echo "Removing $2"
        rm -f "$2"
    fi

    echo "Creating symbolic link SOURCE=$1 TARGET=$2"
    SOURCE="$1"
    TARGET="$2"
    ln -s "$SOURCE" "$TARGET"
}

create_hooks(){
    for file in $HOOK_FILES; do
        FILENAME=$(basename $file)
        SOURCE="$GIT_HOOK_RELATIVE_PATH/$file"
        TARGET="$GIT_HOOK_PATH/$FILENAME"
        symbolic_link "$SOURCE" "$TARGET"
    done
}

main(){
    create_hooks
}

main