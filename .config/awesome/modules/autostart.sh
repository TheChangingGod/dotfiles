#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

run nm-applet
run redshift -c $HOME/.config/redshift/redshift.conf
run picom --config $HOME/.config/picom/picom.conf
if ! pgrep -f cloud-drive-ui; then synology-drive start; fi
if ! pgrep -f volctl; then volctl; fi
run `bash -c '[[ ! -z "$LAPTOP" ]] && xinput set-prop 19 325 1.0'`
run `bash -c '[[ -z "$LAPTOP" ]] && mpv --no-video ~/.config/awesome/libraries/fishlive/sounds/startup-snd-1.mp3 &'`
