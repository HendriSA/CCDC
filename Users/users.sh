#!/bin/bash
# script to remove the user not listed 

USER=root #THE USER YOU WANT TO KEEP

sed 's/:.*//' /etc/passwd | sort -r > userlist.txt # uses the sed thingy to make just return the usernames from /etc/passwd and then sending that to the userlist.txt

input=userlist.txt #using the userlist as input for the while loop to be read line by line
while IFS= read -r line
do
  if [ $line != $USER ] # can add more users and then add an OR operand
  then
    userdel -r $USER
  fi
done < "$input"

rm userlist.txt #removes the userlist.txt