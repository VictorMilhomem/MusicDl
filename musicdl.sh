#!/bin/bash

gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Hello, there! Welcome to $(gum style --foreground 212 'Music Downloader')."


URL=$(gum input --placeholder="type the Youtube music url...")

NEW_FOLDER="Create new folder"
MUSIC_FOLDER="$HOME/Music"

folders=$(find $MUSIC_FOLDER -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)

# Check if there are any directories
if [ -z "$folders" ]; then
  echo "No directories found in ~/Music."
  mkdir "$MUSIC_FOLDER"
fi

echo -e "Select the folder to $(gum style --italic --foreground 99 'save')?\n"
selected_folder=$(echo -e "$folders\n$NEW_FOLDER" | gum choose)

if [[ "$selected_folder" == "$NEW_FOLDER" ]]; then
  selected_folder=$(gum input --placeholder="type the new folder name")
  mkdir "$MUSIC_FOLDER"/"$selected_folder"
fi

gum spin --spinner minidot --title "Downloading" -- yt-dlp -f bestaudio -x --audio-format mp3 --embed-metadata --audio-quality 160k "$URL"
# download the file
#yt-dlp -f bestaudio -x --audio-format mp3 --embed-metadata --audio-quality 160k "$URL"
music_file=$(ls -t *.mp3 2>/dev/null | head -n 1)

echo -e "The music name is $(gum style --italic --foreground 99 "$music_file")\n"
echo -e "$(gum style --italic --foreground 212 'Rename it?')\n"
RENAME=$(gum choose --item.foreground 250 "Yes" "No")


if [[ "$RENAME" == "Yes" ]]; then
  NEW_NAME=$(gum input --placeholder="type the new file name")
  mv "$music_file" "$NEW_NAME.mp3"
  music_file="$NEW_NAME.mp3"
fi

echo -e "Moving $(gum style --italic --foreground 99 "$music_file") to $(gum style --italic --foreground 99 "$MUSIC_FOLDER"/"$selected_folder")\n"

mv "$music_file" "$MUSIC_FOLDER"/"$selected_folder"/

