#!/bin/sh
target=$1;
cache_path="/var/www/html/app/tmp/cache/models";
file_prefix="set_cashe_prefix_here";
core_path="/var/www/html/app/tmp/cache/persistent";
webservers_path="../webservers.txt";

if [ -z "$1" ]; then
        echo "Sorry you have to specific the target:";
        echo "All: for clear all cached models.";
        echo "NewTable: when new table created in db.";
        echo "UpdateTable: when table modified on db.";
        echo "Core: for clear cake core cache like translations.";
        exit 0
fi

if [ $1 = "All" ]; then
        echo "Are you sure you want delete all cache files in all web servers!"
        read conf

        if [ $conf = "yes" ]; then
                while read HOST;
                do
                        ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=2 -l ubuntu -n $HOST "sudo rm ${cache_path}/*";
                        echo "$HOST Done.";
                done < $webservers_path
        fi
elif [ $1 = "NewTable" ]; then
        while read HOST;
        do
                ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=2 -l ubuntu -n $HOST "sudo rm ${cache_path}/${file_prefix}_list";
                echo "$HOST Done.";
        done < $webservers_path
elif [ $1 = "UpdateTable" ]; then
        echo "Please enter the name of updated table:"
        read table_name

        if [ $table_name  ]; then
                while read HOST;
                do
                        ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=2 -l ubuntu -n $HOST "sudo rm ${cache_path}/${file_prefix}_${table_name}";
                        echo "$HOST Done.";
                done < $webservers_path
        fi
elif [ $1 = "Core" ]; then
        while read HOST;
        do
                ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=2 -l ubuntu -n $HOST "sudo rm ${core_path}/*";
                echo "$HOST Done.";
        done < $webservers_path
else
        echo "Target should be one of this:";
        echo "All";
        echo "NewTable";
        echo "UpdateTable";
        echo "Core";
fi
