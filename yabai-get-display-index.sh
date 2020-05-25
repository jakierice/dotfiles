#!/bin/sh

# This script is used to retrieve the MacOS index of the display
# to the east (next) or west (prev). The index can then be used
# in a yabai command for things like moving focus between displays.
#
# Original solution was found in comments of this GitHub issue:
# https://github.com/koekeishiya/yabai/issues/225#issuecomment-526800339
#
# DEPENDENCY: https://github.com/stedolan/jq
# make this script executable with `chmod u+x yabai-get-display-index`


# This script can be run with 1 argument...
# ...either `prev` or `next`.
case "${1}" in
  next)
    step=1
    ;;
  prev)
    step=-1
    ;;
  *)
    echo >&2 "ERROR: must provide an argument 'next' or 'prev'!"
    exit 1
    ;;
esac

jq -nr \
  --argjson displays "$(yabai -m query --displays)" \
  --argjson focused "$(yabai -m query --displays --display)" \
  --argjson step "$step" \
  '$displays
    | sort_by(.frame.x)
    | .[index($focused) + if (index($focused) + $step) < 0 then 0 else $step end].index // $focused.index'
