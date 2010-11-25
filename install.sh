#!/bin/bash

NOW=`date +%Y-%m-%d.%H:%M:%S`
BACKUP_DIR="vim-backup.$NOW.$$"
CURRENT_DIR=`pwd`


# Find Ruby binary
RUBY_BIN="NULL"
for BIN in "ruby" "ruby1.8" "ruby1.9"
do
    which $BIN > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
	RUBY_BIN=$BIN
	break
    fi
done

# Backup existing configuration
mkdir ~/$BACKUP_DIR
mv ~/.vimrc ~/.vim ~/$BACKUP_DIR

# Copy new configuration
mkdir ~/.vim
cp -r * ~/.vim/
ln -s ~/.vim/vimrc ~/.vimrc

# Upgrade plugins if wanted
read -n1 -p "Do you want to upgrade the plugins from Git? (y/n) "
if [[ "$REPLY" == "y" ]]; then
    rm -rf ~/.vim/bundle
    mkdir ~/.vim/bundle
    pushd ~/.vim/bundle
    $CURRENT_DIR/update_plugins.py
    popd
fi
echo ""

# Rebuild Command-T extension
if [[ "$RUBY_BIN" != "NULL" ]]; then
    pushd ~/.vim/bundle/command-t/ruby/command-t
    $RUBY_BIN extconf.rb
    make
    popd
fi

echo "All done!"
exit 0

