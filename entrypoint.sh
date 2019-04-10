#! /bin/ash

TRANSMISSION="${TRANSMISSION:localhost:9091}"

function cleanup
{
  kill -- -$$
  exit $1
}

function handle_change
{
  FPATH=$1
  FILE=$2
  ABSOLUTE_FILE="$FPATH$FILE"

  echo "$ABSOLUTE_FILE modified"
  if [[ "${FILE}" == "vpnportfw" ]]
    then
      # https://linux.die.net/man/1/transmission-remote
      read NEWPORT < /config/vpnportfw
      sleep 30
      echo "port changed to $NEWPORT notifying transmission on $TRANSMISSION"
      transmission-remote $TRANSMISSION --port $NEWPORT
      echo "notified transmission"
  fi
}

function main
{
  inotifywait -r -m -e modify /config |
     while read path _ file; do
         handle_change $path $file
     done
}

trap cleanup SIGHUP SIGINT SIGTERM SIGQUIT
main "$@"
