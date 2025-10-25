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

  if [ $(map_oh_magic ${oh_magic}) != "PE32+" ]; then
    echo "Unimplemented format";
    exit 1
  else
    ohsf_major=$(get_bytes_le $((2+$(offset_optional_header))) 1)
    field_print "Major Linker version" ${ohsf_major} hex2int

    ohsf_minor=$(get_bytes_le $((3+$(offset_optional_header))) 1)
    field_print "Minor Linker version" ${ohsf_minor} hex2int

    ohsf_code_size=$(get_bytes_le $((4+$(offset_optional_header))) 4)
    field_print "Code Size" ${ohsf_code_size} hex2int

    ohsf_initdata_size=$(get_bytes_le $((8+$(offset_optional_header))) 4)
    field_print "Initialized Data Size" ${ohsf_initdata_size} hex2int

    ohsf_uninitdata_size=$(get_bytes_le $((12+$(offset_optional_header))) 4)
    field_print "Uninitialized Data Size" ${ohsf_uninitdata_size} hex2int

    ohsf_entrypoint_address=$(get_bytes_le $((16+$(offset_optional_header))) 4)
    field_print "Address of Entry point" ${ohsf_entrypoint_address} hex2int

    ohsf_codebase=$(get_bytes_le $((20+$(offset_optional_header))) 4)
    field_print "Base of Code" ${ohsf_codebase} hex2int
  fi

  eyecandy_end
fi
