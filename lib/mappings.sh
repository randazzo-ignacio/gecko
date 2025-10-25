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
    "0107") echo "ROM";;
    "020b") echo "PE32+";;
    *) echo "ERROR";;
  esac
}

map_subsystem() {
  case "$1" in
    "0000") echo "IMAGE_SUBSYSTEM_UNKNOWN";;
    "0001") echo "IMAGE_SUBSYSTEM_NATIVE";;
    "0002") echo "IMAGE_SUBSYSTEM_WINDOWS_GUI";;
    "0003") echo "IMAGE_SUBSYSTEM_WINDOWS_CUI";;
    "0004") echo "ERROR";;
    "0005") echo "IMAGE_SUBSYSTEM_OS2_CUI";;
    "0006") echo "ERROR";;
    "0007") echo "IMAGE_SUBSYSTEM_POSIX_CUI";;
    "0008") echo "IMAGE_SUBSYSTEM_NATIVE_WINDOWS";;
    "0009") echo "IMAGE_SUBSYSTEM_WINDOWS_CE_GUI";;
    "000a") echo "IMAGE_SUBSYSTEM_EFI_APPLICATION";;
    "000b") echo "IMAGE_SUBSYSTEM_EFI_BOOT_SERVICE_DRIVER";;
    "000c") echo "IMAGE_SUBSYSTEM_EFI_RUNTIME_DRIVER";;
    "000d") echo "IMAGE_SUBSYSTEM_EFI_ROM";;
    "000e") echo "IMAGE_SUBSYSTEM_XBOX ";;
    "000f") echo "ERROR";;
    "0010") echo "IMAGE_SUBSYSTEM_WINDOWS_BOOT_APPLICATION";;
    *) echo "ERROR";;
  esac
}

map_dll_characteristics() {
  intflags=$(hex2int $1)
  if [ $((${intflags}&32))    -ne 0 ]; then echo -n "IMAGE_DLLCHARACTERISTICS_HIGH_ENTROPY_VA |"; fi
  if [ $((${intflags}&64))    -ne 0 ]; then echo -n "IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE |"; fi
  if [ $((${intflags}&128))   -ne 0 ]; then echo -n "IMAGE_DLLCHARACTERISTICS_FORCE_INTEGRITY |"; fi
  if [ $((${intflags}&256))   -ne 0 ]; then echo -n "IMAGE_DLLCHARACTERISTICS_NX_COMPAT |"; fi
  if [ $((${intflags}&512))   -ne 0 ]; then echo -n "IMAGE_DLLCHARACTERISTICS_NO_ISOLATION |"; fi
  if [ $((${intflags}&1024))  -ne 0 ]; then echo -n "IMAGE_DLLCHARACTERISTICS_NO_SEH |"; fi
  if [ $((${intflags}&2048))  -ne 0 ]; then echo -n "IMAGE_DLLCHARACTERISTICS_NO_BIND |"; fi
  if [ $((${intflags}&4096))  -ne 0 ]; then echo -n "IMAGE_DLLCHARACTERISTICS_APPCONTAINER |"; fi
  if [ $((${intflags}&8192))  -ne 0 ]; then echo -n "IMAGE_DLLCHARACTERISTICS_WDM_DRIVER |"; fi
  if [ $((${intflags}&16384)) -ne 0 ]; then echo -n "IMAGE_DLLCHARACTERISTICS_GUARD_CF |"; fi
  if [ $((${intflags}&32768)) -ne 0 ]; then echo -n "IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE |"; fi
}
