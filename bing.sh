#!/bin/sh

# code by phoneli
# mail : phone.wc.li@gmail.com

function fecho()
{
	echo "\033[33m $1$2$3$4$5 \033[0m"
}

if [ $# -ne 1 ]
then
	fecho " "
	fecho "usage $0 arg( l | ls | bing | dark | bing-load | \$num | h )"
	fecho " "
	exit	
fi

cmd=$1
localfolder="/Users/$USER/Pictures/bing"

if [ "$cmd"x = "bing-load"x ]
then
	pass=""
else
	case $cmd in
	"l" | "ls" )
		tmp=1
		ls -l $localfolder"/" | grep -v total | awk '{print $NF}' | sort -r | while read line
		do
			echo "$line ($tmp)"
			let "tmp = $tmp + 1"
		done
	;;
	"bing" )
		filename=$(echo $(date +%y%m%d)".jpg")
		localfile=${localfolder}"/"${filename}
		osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$localfile\""
	;;
	"dark" )
		filename="dark.png"
		localfile=${localfolder}"/"${filename}
		osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$localfile\""
	;;
	[1-9] | [1-9][0-9] | [1-9][0-9][0-9] )
		line=$cmd
		filename=$(ls -l $localfolder"/" | grep -v total | awk '{print $NF}' | sort -r | tail -n +$line | head -n 1)
		localfile=${localfolder}"/"${filename}
		osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$localfile\""
	;;
	"h" | "-h" | "--help")
		fecho " "
		fecho "usage $0 arg( l | ls | bing | dark | bing-load | \$num | h )"
		fecho "l | ls : list"
		fecho "bing : set today bing's image"
		fecho "dark : set dark image"
		fecho "bing-load : load today bing's image from web and set it"
		fecho "h : help"
		fecho "\$num : set one image which in list"
		fecho " "
	;;
	esac		
	
	exit
fi

#======bing logic======
 
# get url
url=$(curl "http://cn.bing.com/#" | grep hprichbg | grep -o "url:'http.*bing.*hprichbg.*jpg',id" | awk -F"'" '{print $2}')
filename=$(echo $(date +%y%m%d)".jpg")
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

#set image 
osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$localfile\""

