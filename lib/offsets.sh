source "$(dirname ${BASH_SOURCE[0]})/config.sh"

offset_signature() {
  echo $(hex2int $(get_bytes_le $(hex2int 3c) 1))
}

offset_coff() {
  echo $((4+$(offset_signature)))
}

offset_optional_header() {
  echo $((20+$(offset_coff)))
}

offset_optional_header_standard() {
  echo $((2+$(offset_optional_header)))
}

offset_debug_static() {
  eyecandy_start "Static Offsets"
  echo "Signature offset: $(offset_signature)"
  echo "COFF offset: $(offset_coff)"
  eyecandy_end
}
