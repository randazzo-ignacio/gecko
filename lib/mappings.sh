source "$(dirname ${BASH_SOURCE[0]})/config.sh"

map_machine_type() {
  case "$1" in
    "8664") echo "AMD64";;
    *) echo "ERROR";;
  esac
}

map_timestamp() {
  date --date="@$(hex2int $1)"
}

map_characteristics() {
  intflags=$(hex2int $1)
  if [ $((${intflags}&1))     -ne 0 ]; then echo -n "IMAGE_FILE_RELOCS_STRIPPED |"; fi
  if [ $((${intflags}&2))     -ne 0 ]; then echo -n "IMAGE_FILE_EXECUTABLE_IMAGE |"; fi
  if [ $((${intflags}&4))     -ne 0 ]; then echo -n "IMAGE_FILE_LINE_NUMS_STRIPPED |"; fi
  if [ $((${intflags}&8))     -ne 0 ]; then echo -n "IMAGE_FILE_LOCAL_SYMS_STRIPPED |"; fi
  if [ $((${intflags}&16))    -ne 0 ]; then echo -n "IMAGE_FILE_AGGRESSIVE_WS_TRIM |"; fi
  if [ $((${intflags}&32))    -ne 0 ]; then echo -n "IMAGE_FILE_LARGE_ADDRESS_AWARE |"; fi
  if [ $((${intflags}&64))    -ne 0 ]; then echo -n "RESERVED_FOR_FUTURE_USE |"; fi
  if [ $((${intflags}&128))   -ne 0 ]; then echo -n "IMAGE_FILE_BYTES_REVERSED_LO |"; fi
  if [ $((${intflags}&256))   -ne 0 ]; then echo -n "IMAGE_FILE_32BIT_MACHINE |"; fi
  if [ $((${intflags}&512))   -ne 0 ]; then echo -n "IMAGE_FILE_DEBUG_STRIPPED |"; fi
  if [ $((${intflags}&1024))  -ne 0 ]; then echo -n "IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP |"; fi
  if [ $((${intflags}&2048))  -ne 0 ]; then echo -n "IMAGE_FILE_NET_RUN_FROM_SWAP |"; fi
  if [ $((${intflags}&4096))  -ne 0 ]; then echo -n "IMAGE_FILE_SYSTEM |"; fi
  if [ $((${intflags}&8192))  -ne 0 ]; then echo -n "IMAGE_FILE_DLL |"; fi
  if [ $((${intflags}&16384)) -ne 0 ]; then echo -n "IMAGE_FILE_UP_SYSTEM_ONLY |"; fi
  if [ $((${intflags}&32768)) -ne 0 ]; then echo -n "IMAGE_FILE_BYTES_REVERSED_HI |"; fi
}

map_oh_magic() {
  case "$1" in
    "010b") echo "PE32";;
    "020b") echo "PE32+";;
    *) echo "ERROR";;
  esac
}
