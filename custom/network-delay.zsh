function delay-packets() {
  DELAY=$1
  VARIABILITY=$2
  CORRELATION_PERCENT=$3

  CURRENT=$(show-delay)

  case "$CURRENT" in
    *delay*)
      sudo tc qdisc change dev vboxnet0 root netem delay $DELAY $VARIABILITY $CORRELATION_PERCENT
      sudo tc qdisc change dev docker0 root netem delay $DELAY $VARIABILITY $CORRELATION_PERCENT
      ;;
    *)
      sudo tc qdisc add dev vboxnet0 root netem delay $DELAY $VARIABILITY $CORRELATION_PERCENT
      sudo tc qdisc add dev docker0 root netem delay $DELAY $VARIABILITY $CORRELATION_PERCENT
      ;;
  esac

  CURRENT_PACKET_DELAY=$DELAY
  export CURRENT_PACKET_DELAY
  CURRENT_PACKET_VARIABILITY=$VARIABILITY
  export CURRENT_PACKET_VARIABILITY
  CURRENT_CORRELATION_PERCENT=$CORRELATION_PERCENT
  export CURRENT_CORRELATION_PERCENT

  show-delay
}

function remove-delay() {
  DELAY=$1
  VARIABILITY=$2
  CORRELATION_PERCENT=$3

  if [ -z "$DELAY" ]; then
    DELAY=$CURRENT_PACKET_DELAY
  fi
  if [ -z "$VARIABILITY" ]; then
    VARIABILITY=$CURRENT_PACKET_VARIABILITY
  fi
  if [ -z "$CORRELATION_PERCENT" ]; then
    CORRELATION_PERCENT=$CURRENT_CORRELATION_PERCENT
  fi

  sudo tc qdisc del dev vboxnet0 root netem delay $DELAY $VARIABILITY $CORRELATION_PERCENT
  sudo tc qdisc del dev docker0 root netem delay $DELAY $VARIABILITY $CORRELATION_PERCENT

  show-delay
}

function show-delay() {
  echo "Current vbox packet settings:"
  sudo tc qdisc show dev vboxnet0

  echo "Current docker packet settings:"
  sudo tc qdisc show dev docker0
}
