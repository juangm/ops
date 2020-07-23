#!/bin/bash

PATH_MODULES=$1

echo "---- List of node_modules folders found ----"
find $PATH_MODULES -name "node_modules" -type d -prune -print | xargs du -chs
echo "---------------------------------------------"

while true; do
    read -p "Do you wish to delete the previous folders (yes or no)? " yn
    case $yn in
        [Yy]* ) 
          echo "Deleting...."
          find $PATH_MODULES -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;
          break;;
        [Nn]* )
          echo "Exiting without deleting"
          exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
