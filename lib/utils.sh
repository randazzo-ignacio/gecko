source "$(dirname ${BASH_SOURCE[0]})/config.sh"

get_bytes_be() {
  offset="$1"
  length="$2"
  xxd -g16 -l ${length} -s ${offset} ${TARGET} | grep -oE "\s\S+\s" | tr -d " " | tr -d $"\n"
}

get_bytes_le() {
  offset="$1"
  length="$2"
  xxd -g16 -e -l ${length} -s ${offset} ${TARGET} | grep -oE "\s\S+\s" | tr -d " " | tr -d $"\n"
}

hex2chr() {
  echo "0x$1" | xxd -r
}

hex2int() {
  echo $((16#$1))
}

field_print() {
  name="$1"
  hex="$2"
  mapping="$3"
  if [ -z ${mapping} ]; then
    echo "${name}: 0x${hex}"
  else
    echo "${name}: 0x${hex} | ${mapping}: $(${mapping} ${hex})"
  fi
}

eyecandy_start() {
  title="$1"
  echo -e "\n==== ${title} ===="
}

eyecandy_end() {
  echo -e "================\n"
}
