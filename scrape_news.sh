#!/bin/bash

#the script gets all the articles from Ynet and prints the number of 
#appearences of Netanyahu/Gantz in each article.

wget -q https://www.ynetnews.com/category/3082
#we search, sort and save uniq links that have suffix of 9
#letters\numbers and '"' at the end.  
grep -o "https://www.ynetnews.com/article/[a-zA-Z0-9]\{9\}[\"\]" 3082 \
| sort | uniq > links
#delete the '"' suffix.
sed 's/"//g' links > clean_links
cat clean_links | wc -l  > results.csv
num_of_links=$(cat results.csv)

#the for loop prints the the number of 
#appearences of Netanyahu/Gantz in each link.
for ((i=1; i<=num_of_links; i++)); do
	current_link=$(sed -n $i\p clean_links);
 	wget -q $current_link -O current_html;
 	gantz_count=$( grep -o "Gantz" current_html | wc -l); 
 	bibi_count=$( grep -o "Netanyahu" current_html | wc -l);
 	if (( ((bibi_count == 0)) && ((gantz_count == 0)) )); then
  		echo $current_link, - >> results.csv; 
  	else 
  		echo $current_link, Netanyahu, $bibi_count, Gantz, $gantz_count \
  		>> results.csv;
   	fi 
done
