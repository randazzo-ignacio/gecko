#!/usr/bin/env bash

LIBDIR="$(dirname ${BASH_SOURCE[0]})/lib"

source "${LIBDIR}/config_check.sh"
source "${LIBDIR}/utils.sh"
source "${LIBDIR}/mappings.sh"
source "${LIBDIR}/offsets.sh"

offset_debug_static

eyecandy_start "Metadata"

magic_byte=$(get_bytes_be 0 2)
field_print "Magic byte" ${magic_byte} hex2chr
pe_signature=$(get_bytes_be $(offset_signature) 4)
field_print "PE Signature" ${pe_signature}

eyecandy_end
eyecandy_start "COFF File Header"

machine_type=$(get_bytes_le $(offset_coff) 2)
field_print "Machine Type" ${machine_type} map_machine_type

nof_sections=$(get_bytes_le $((2+$(offset_coff))) 2)
field_print "Number of Sections" ${nof_sections} hex2int

timestamp=$(get_bytes_le $((4+$(offset_coff))) 4)
field_print "Timestamp" ${timestamp} map_timestamp

symbol_tp=$(get_bytes_le $((8+$(offset_coff))) 4)
field_print "Symbol Table Pointer" ${symbol_tp} hex2int

nof_symbols=$(get_bytes_le $((12+$(offset_coff))) 4)
field_print "Number of Symbols" ${nof_symbols} hex2int

optional_header_size=$(get_bytes_le $((16+$(offset_coff))) 2)
field_print "Size of Optional Header" ${optional_header_size} hex2int

characteristics=$(get_bytes_le $((18+$(offset_coff))) 2)
field_print "Characteristics" ${characteristics} map_characteristics

eyecandy_end

if [ $(hex2int ${optional_header_size}) -ne 0 ]; then
  eyecandy_start "Optional Header (Image)"

  oh_magic=$(get_bytes_le $(($(offset_optional_header))) 2)
  field_print "Optional Header Magic" ${oh_magic} map_oh_magic

  eyecandy_end
fi
