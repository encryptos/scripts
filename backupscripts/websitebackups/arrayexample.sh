#!/bin/bash
maindomains=/home/www/html/maindomains/
subdomains=/home/www/html/subdomains/
echo $maindomains

array=($(ls $maindomains))
echo ${array[*]}
echo ${#array[*]}
