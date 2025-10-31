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
    eyecandy_start "Optional Header Standard Fields (Image)"

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

    eyecandy_end
    eyecandy_start "Optional Header Standard Fields (Image)"

    ohwsf_image_base=$(get_bytes_le $((24+$(offset_optional_header))) 8)
    field_print "Image base" ${ohwsf_image_base} hex2int

    ohwsf_section_alignment=$(get_bytes_le $((32+$(offset_optional_header))) 4)
    field_print "Section Alignment" ${ohwsf_section_alignment} hex2int

    ohwsf_file_alignment=$(get_bytes_le $((36+$(offset_optional_header))) 4)
    field_print "File Alignment" ${ohwsf_file_alignment} hex2int

    ohwsf_major_os_version=$(get_bytes_le $((40+$(offset_optional_header))) 2)
    field_print "Major OS Version" ${ohwsf_major_os_version} hex2int

    ohwsf_minor_os_version=$(get_bytes_le $((42+$(offset_optional_header))) 2)
    field_print "Minor OS Version" ${ohwsf_minor_os_version} hex2int

    ohwsf_major_image_version=$(get_bytes_le $((44+$(offset_optional_header))) 2)
    field_print "Major Image Version" ${ohwsf_major_image_version} hex2int

    ohwsf_minor_image_version=$(get_bytes_le $((46+$(offset_optional_header))) 2)
    field_print "Minor Image Version" ${ohwsf_minor_image_version} hex2int

    ohwsf_major_subsystem_version=$(get_bytes_le $((48+$(offset_optional_header))) 2)
    field_print "Major Subsystem Version" ${ohwsf_major_subsystem_version} hex2int

    ohwsf_minor_subsystem_version=$(get_bytes_le $((50+$(offset_optional_header))) 2)
    field_print "Minor Subsystem Version" ${ohwsf_minor_subsystem_version} hex2int

    ohwsf_win32_version=$(get_bytes_le $((52+$(offset_optional_header))) 4)
    field_print "Reserved win32 version value, must be zero" ${ohwsf_minor_subsystem_version} hex2int

    ohwsf_image_size=$(get_bytes_le $((56+$(offset_optional_header))) 4)
    field_print "Size of Image" ${ohwsf_image_size} hex2int

    ohwsf_headers_size=$(get_bytes_le $((60+$(offset_optional_header))) 4)
    field_print "Size of Headers" ${ohwsf_headers_size} hex2int

    ohwsf_checksum=$(get_bytes_le $((64+$(offset_optional_header))) 4)
    field_print "Checksum" ${ohwsf_checksum}

    ohwsf_subsystem=$(get_bytes_le $((68+$(offset_optional_header))) 2)
    field_print "Subsystem" ${ohwsf_subsystem} map_subsystem

    ohwsf_dll_characteristics=$(get_bytes_le $((70+$(offset_optional_header))) 2)
    field_print "DLL Characteristics" ${ohwsf_dll_characteristics} map_dll_characteristics

    ohwsf_stack_reserve_size=$(get_bytes_le $((72+$(offset_optional_header))) 8)
    field_print "Size of Stack Reserve" ${ohwsf_stack_reserve_size} hex2int

    ohwsf_stack_commit_size=$(get_bytes_le $((80+$(offset_optional_header))) 8)
    field_print "Size of Stack Commit" ${ohwsf_stack_commit_size} hex2int

    ohwsf_heap_reserve_size=$(get_bytes_le $((88+$(offset_optional_header))) 8)
    field_print "Size of Heap Reserve" ${ohwsf_heap_reserve_size} hex2int

    ohwsf_heap_commit_size=$(get_bytes_le $((96+$(offset_optional_header))) 8)
    field_print "Size of Heap Commit" ${ohwsf_heap_commit_size} hex2int

    ohwsf_loader_flags=$(get_bytes_le $((104+$(offset_optional_header))) 4)
    field_print "Loader flags (Reserved, must be zero)" ${ohwsf_loader_flags}

    ohwsf_nof_rva_and_sizes=$(get_bytes_le $((108+$(offset_optional_header))) 4)
    field_print "Number of RVA and Sizes" ${ohwsf_nof_rva_and_sizes} hex2int

    eyecandy_end

    for data_num in $(seq 1 $(hex2int ${ohwsf_nof_rva_and_sizes})); do
      eyecandy_start "Optional Header Data Directory number ${data_num} (Image)"

      data_dir_size=128

      ohdd_export_table_addr[${data_num}]=$(get_bytes_le $((112+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      ohdd_export_table_size[${data_num}]=$(get_bytes_le $((116+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      field_print "Export table Address" ${ohdd_export_table_addr[${data_num}]} hex2int
      field_print "Export table Size" ${ohdd_export_table_size[${data_num}]} hex2int

      ohdd_import_table_addr[${data_num}]=$(get_bytes_le $((120+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      ohdd_import_table_size[${data_num}]=$(get_bytes_le $((124+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      field_print "Import table Address" ${ohdd_import_table_addr[${data_num}]} hex2int
      field_print "Import table Size" ${ohdd_import_table_size[${data_num}]} hex2int

      ohdd_resource_table_addr[${data_num}]=$(get_bytes_le $((128+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      ohdd_resource_table_size[${data_num}]=$(get_bytes_le $((132+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      field_print "Resource table Address" ${ohdd_resource_table_addr[${data_num}]} hex2int
      field_print "Resource table Size" ${ohdd_resource_table_size[${data_num}]} hex2int

      ohdd_exception_table_addr[${data_num}]=$(get_bytes_le $((136+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      ohdd_exception_table_size[${data_num}]=$(get_bytes_le $((140+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      field_print "Exception table Address" ${ohdd_exception_table_addr[${data_num}]} hex2int
      field_print "Exception table Size" ${ohdd_exception_table_size[${data_num}]} hex2int

      ohdd_certificate_table_addr[${data_num}]=$(get_bytes_le $((144+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      ohdd_certificate_table_size[${data_num}]=$(get_bytes_le $((148+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      field_print "Certificate table Address" ${ohdd_certificate_table_addr[${data_num}]} hex2int
      field_print "Certificate table Size" ${ohdd_certificate_table_size[${data_num}]} hex2int

      ohdd_reloc_table_addr[${data_num}]=$(get_bytes_le $((152+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      ohdd_reloc_table_size[${data_num}]=$(get_bytes_le $((156+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      field_print "Base Relocation table Address" ${ohdd_reloc_table_addr[${data_num}]} hex2int
      field_print "Base Relocation table Size" ${ohdd_reloc_table_size[${data_num}]} hex2int

      ohdd_debug_table_addr[${data_num}]=$(get_bytes_le $((160+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      ohdd_debug_table_size[${data_num}]=$(get_bytes_le $((164+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 4)
      field_print "Debug table Address" ${ohdd_debug_table_addr[${data_num}]} hex2int
      field_print "Debug table Size" ${ohdd_debug_table_size[${data_num}]} hex2int

      ohdd_architecture[${data_num}]=$(get_bytes_le $((168+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) 8)
      field_print "Architecture (Reserved, must be zero)" ${ohdd_architecture[${data_num}]} hex2int

      rdata[${data_num}]=$(get_bytes_le $((176+$((${data_dir_size}*$((${data_num}-1))))+$(offset_optional_header))) ${ohdd_export_table_size})

      eyecandy_end
    done
  fi

  eyecandy_end
fi
