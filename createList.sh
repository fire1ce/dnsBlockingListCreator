#!/bin/bash

# Sets Working Dir as Real A Script Location
if [ -z $(which realpath) ]; then
    brew install coreutils
fi
cd $(dirname "$(realpath "$0")")

# Pull adn Create List
for source in $(cat lists.lst); do
    echo $source
    curl --silent $source >>rawList.txt
    echo -e "\t$(wc -l rawList.txt | cut -d " " -f 1) lines downloaded"
done

echo -e "\nFiltering non-url content..."
perl easylist.pl rawList.txt >parsedList.txt
rm rawList.txt
echo -e "\t$(wc -l parsedList.txt | cut -d " " -f 1) lines after parsing"

echo -e "\nRemoving duplicates..."
sort -u parsedList.txt >uniqueList.txt
rm parsedList.txt
echo -e "\t$(wc -l uniqueList.txt | cut -d " " -f 1) lines after deduping"

# Pushing to Repo
git add . 2>&1
git commit -m "${DATE}_update" 2>&1
git push 2>&1
