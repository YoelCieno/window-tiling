#!/bin/bash

choice=$(zenity --list \
    --title="Select Profile" \
    --text="Which workspace profile?" \
    --column="Profile" Development Personal Minimal \
    --width=300 --height=250)

# Save the chosen profile so devilspie2 can read it
# echo "$choice" > /tmp/startup_profile

case "$choice" in
    Development) "$(dirname "$0")/startup/startup-dev.sh" ;;
    Personal)    "$(dirname "$0")/startup/startup-personal.sh" ;;
    Minimal)     "$(dirname "$0")/startup/startup-minimal.sh" ;;
    *)           "$(dirname "$0")/startup/startup-dev.sh" ;;   # default fallback
esac
