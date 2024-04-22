BOXNAME=$1
TEXT=$2
COLOR=$3

tputf() {
  if [ -t 1 ]; then 
    tput "$@"
  fi;
}

if [ -n "$TEXT" ]; then
  BOXLEN=0
  if [ $((${#TEXT} + 4)) -lt $((${#BOXNAME} + 5)) ]; then
    BOXLEN=$((${#BOXNAME} + 5))
  else
    BOXLEN=$((${#TEXT} + 3))
  fi

  tputf sgr0;
  printf " ┏━";

  if [ "${BOXNAME}" = "" ]; then
    printf "━━";
  else
    tputf setaf "$COLOR";
    printf " %s " "$BOXNAME";
    tputf sgr0;
  fi;

  i=$((${#BOXNAME} + 4));
  while [ "$i" -lt "$BOXLEN" ]; do
    printf "━"; i=$((i + 1));
  done;
  printf "┓\n ┃ %s" "${TEXT}";

  i=$((${#TEXT} + 3));
  while [ "$i" -lt "$BOXLEN" ]; do
    printf " "; i=$((i + 1));
  done;
  printf " ┃\n ┗";

  i=1;
  while [ "$i" -lt "$BOXLEN" ]; do
    printf "━"; i=$((i + 1));
  done;

  printf "┛\n";
fi
