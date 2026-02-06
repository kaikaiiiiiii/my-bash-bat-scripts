rm list.txt
folders=("Anime" "More")
for dir in "${folders[@]}"
do
    find "$dir" -type f -printf "%s\t%p\n" >>list.txt
done
sed -i -e 's/\//\\/g' list.txt