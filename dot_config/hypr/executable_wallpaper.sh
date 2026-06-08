#!/bin/bash
#WALLPAPER_DIR="$HOME/Images/WP"
WALLPAPER_DIR="/media/sigill/data/Pictures/WP"
#I dont know what the fuck I am doing
menu() {
    find "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}
main() {
    # choice=$(menu | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css --show dmenu --prompt "Select Wallpaper:" -n)
    # selected_wallpaper=$(echo "$choice" | sed 's/^img://')

    IMG1=$(find ${WALLPAPER_DIR} -type f | shuf -n1)
    IMG2=$(find ${WALLPAPER_DIR} -type f | shuf -n1)
    IMG3=$(find ${WALLPAPER_DIR} -type f | shuf -n1)

    montage "$IMG1" "$IMG2" "$IMG3" \
    -geometry +0+0 \
    -tile 3x1 \
    /tmp/wal-combined.jpg

    # magick \
    # \( "$IMG1" -resize 1440x2560^ -gravity center -extent 1440x2560 \) \
    # \( "$IMG2" -resize 2560x1440^ -gravity center -extent 2560x1440 \) \
    # \( "$IMG3" -resize 2560x1440^ -gravity center -extent 2560x1440 \) \
    # -background black \
    # -size 6560x2560 canvas:black \
    # -compose over \
    # -geometry +0+0      -composite \
    # -geometry +1440+560 -composite \
    # -geometry +4000+560 -composite \
    # /tmp/wal-combined.png

    wal -i /tmp/wal-combined.jpg -n --cols16

    awww img "$IMG1" --outputs HDMI-A-1
    awww img "$IMG2" --outputs DP-1
    awww img "$IMG3" --outputs DP-2

    # rm -rf /tmp/wal-combined.jpg

    # awww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .5
    # wal -i "$selected_wallpaper" -n --cols16

    # pkill swayosd-server
    # swayosd-server &
    swaync-client --reload-css
    cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf
    # pywalfox update
    /home/sigill/.local/bin/pywalfox update
    # color1=$(awk 'match($0, /color2=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
    # color2=$(awk 'match($0, /color3=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
    # cava_config="$HOME/.config/cava/config"
    # sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" $cava_config
    # sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" $cava_config
    # pkill -USR2 cava 2>/dev/null
    # source ~/.cache/wal/colors.sh && cp -r $wallpaper ~/wallpapers/pywallpaper.jpg 
}
main

