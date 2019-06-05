#!/bin/sh

#### FAILURE SETUP ####
#set -euo pipefail
#trap "echo 'error: Script failed: see failed command above'" ERR

OIFS="$IFS"
IFS=$'\n'

#### FUNCTIONS ####


usage()
{
    echo "usage: suggest-files-to-delete [[[-a daysAgo -d depth] [-i]] | [-h]]"
}


##### Main #####

clear

interactive=
depth=1
daysAgo=$((30 * 12))

if [ $# -gt 0 ]; then
    echo "Your command line contains $# arguments"

    while [ "$1" != "" ]; do
        case $1 in
             -a | --daysago )        shift
                                     daysAgo=$1
                                     ;;
             -d | --depth )          shift
                                     depth=$1
                                     ;;
             -i | --interactive )    interactive=1
                                     ;;
             -h | --help )           usage
                                     exit
                                     ;;
             * )                     usage
                                     exit 1
         esac
         shift
     done

     echo "interactive=${interactive}"
     echo "depth=${depth}"
     echo "daysAgo=${daysAgo}"
     echo ""
else
    echo "Your command line contains no arguments"
fi


echo "PROPOSING FILES TO DELETE"
echo "========================="

# find list of files older the "$daysAgo" days 
i=0 # count number of matching files
for x in $(find ~/Downloads -maxdepth $depth -type f -atime +$daysAgo -print); do ls -l "$x";i=$(($i + 1)); done

if [ $i -gt 0 ]; then
   echo "Delete these files? (y) Yes (n) No"
   echo "=================================="

   read isDelete
   
   if [ $isDelete = "y" ]; then
      echo "Deleting the selected files"
      echo "==========================="
      find ~/Downloads -maxdepth $depth -type f -atime +$daysAgo -print | while read f; do rm -rf "$f"; done
   fi
else
  echo "No files to suggest"
  echo "bye"
fi
