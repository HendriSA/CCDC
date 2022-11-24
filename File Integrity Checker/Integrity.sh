#!/bin/bash
#Bash script to check the integrity of a files or directory
    # Check the integrity of the files in the directory
    # and will report any changes to the files.
    # Maybe run in cron job

##/var/log/integrity.log is the log file that will be created and will contain the results of the integrity check.
echo "what is the file or directory you want to check?"
read target

echo "what is the md5 hash you want to check against?"
read hash

if [ -f $target ]; then
    echo "Checking File Integrity..."
    md5sum $target >> /var/log/integrity.log
    date >> /var/log/integrity.log
    target_hash=$(md5sum $target | awk '{print $1}')
    echo "File Integrity Check Complete"
elif [ -d $target ]; then
    echo "Checking Directory Integrity..."
    find $target -type f -exec md5sum {} \; >> /var/log/integrity.log
    date >> /var/log/integrity.log
    target_hash=$(find $target -type f -exec md5sum {} \; | awk '{print $1}')
    echo "Directory Integrity Check Complete"
else
    echo "not a file or directory"
fi

if [ $target_hash != $hash ]; then
    echo -e "\e[38;2;255;0;0mIntegrity check failed\e[0m"
    echo -e "\e[38;2;255;0;0mIntegrity check failed\e[0m" >> /var/log/integrity.log | mail -s "Integrity Check Failed" root
else
    echo -e "Integrity check passed"
    echo "Integrity check passed" >> /var/log/integrity.log
fi
echo "------------------------------------------------------------" >> /var/log/integrity.log
exit 0

# Could use Logwatch to reading logs
# Maybe Point it to the integrity.log file and have it email the results to the admin.