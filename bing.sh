#!/bin/sh

# code by phoneli
# mail : phone.wc.li@gmail.com

if [ $# -ne 1 ]
then
	echo "usage $0 arg(bing , bing-load or dark)"
	exit	
fi

cmd=$1
if [ "$cmd"x = "bing-load"x ]
then
	pass=""
elif [ "$cmd"x = "dark"x ]
then
	filename="dark.png"
	localfolder="/Users/$USER/Pictures/bing"
	localfile=${localfolder}"/"${filename}
	osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$localfile\""
	exit
elif [ "$cmd"x = "bing"x ]
then
	filename=$(echo $(date +%y%m%d)".jpg")
	localfolder="/Users/$USER/Pictures/bing"
	localfile=${localfolder}"/"${filename}
	osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$localfile\""
	exit
else
	echo "usage $0 arg(bing or dark)"
	exit	
fi

#======bing logic======
 
# get url
url=$(curl "http://cn.bing.com/#" | grep hprichbg | grep -o "url:'http.*bing.*hprichbg.*jpg',id" | awk -F"'" '{print $2}')
#filename=$(echo $url | awk -F"/" '{print $NF}' )
filename=$(echo $(date +%y%m%d)".jpg")
localfolder="/Users/$USER/Pictures/bing"
localfile=${localfolder}"/"${filename}

if [ ! -e $localfolder ]
then
	echo "$localfolder not exist , now create";
    mkdir $localfolder
fi

if [ -e $localfile ]
then
	#echo "$localfile exist";
	exit
fi


#download image
curl -o $localfile  $url

#echo $url
#echo $filename
#echo $localfolder
#echo $localfile

#set image 
osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$localfile\""

