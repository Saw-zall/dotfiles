#!/usr/bin/env bash

SERVICE="kokorodoki.service"

case "${1:-status}" in
toggle)
  if systemctl --user is-active --quiet "$SERVICE"; then
    systemctl --user stop "$SERVICE"
  else
    systemctl --user start "$SERVICE"
  fi
  ;;

start)
  systemctl --user start "$SERVICE"
  ;;

stop)
  systemctl --user stop "$SERVICE"
  ;;
esac

state="$(systemctl --user is-active "$SERVICE" 2>/dev/null || true)"

case "$state" in
active)
  printf '{"text":"󰔊","class":"active","tooltip":"Kokorodoki active — clic to stop"}\n'
  ;;
activating)
  printf '{"text":"󰔟","class":"activating","tooltip":"Kokorodoki starting…"}\n'
  ;;
failed)
  printf '{"text":"󰅙","class":"failed","tooltip":"Kokorodoki error — clic restart"}\n'
  ;;
*)
  printf '{"text":"󰔍","class":"inactive","tooltip":"Kokorodoki stopped — clic restart"}\n'
  ;;
esac
