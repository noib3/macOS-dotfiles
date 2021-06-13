#!/run/current-system/sw/bin/bash

PATH="$PATH:/run/current-system/sw/bin:/home/noib3/.nix-profile/bin"

function notify_change() {
  notify-send \
    --expire-time=5000 \
    --app-name="Redshift" \
    --icon="/home/noib3/sync/dotfiles/defaults/redshift/scripts/redshift-logo.png" \
    "Switching temps..." \
    "$1"
}

case "$1" in
  period-changed)
    [ "$3" == "none" ] || {
      new_period = "$(echo "$3" | sed 's/night/Night time/;s/day/Day /;s/tr/Tr/')"
      notify_change "$new_period"
    }
esac