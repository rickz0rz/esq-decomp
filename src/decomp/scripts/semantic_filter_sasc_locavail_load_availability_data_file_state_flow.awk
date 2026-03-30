BEGIN {
    has_entry = 0
    has_load_file = 0
    has_fail_reset_primary = 0
    has_fail_reset_secondary = 0
    has_reset_primary_chain = 0
    has_reset_secondary_chain = 0
    has_set_primary_mode = 0
    has_set_secondary_mode = 0
    has_capture_file_len = 0
    has_capture_file_buf = 0
    has_fetch_section = 0
    has_normalize_workbuf_error = 0
    has_check_version = 0
    has_reset_scratch = 0
    has_parse_mode = 0
    has_parse_node_count = 0
    has_capture_mode_char = 0
    has_alloc_node_arrays = 0
    has_alloc_result_test = 0
    has_empty_alloc_failure_guard = 0
    has_node_offset_mul10 = 0
    has_parse_token_index = 0
    has_store_token_index = 0
    has_validate_token_nonzero = 0
    has_validate_token_upper = 0
    has_parse_duration = 0
    has_store_duration = 0
    has_validate_duration_positive = 0
    has_validate_duration_max = 0
    has_parse_payload_size = 0
    has_store_payload_size = 0
    has_validate_payload_positive = 0
    has_validate_payload_max = 0
    has_alloc_payload = 0
    has_alloc_line_786 = 0
    has_alloc_memf_public_clear = 0
    has_store_payload_ptr = 0
    has_fetch_encoded = 0
    has_payload_decode_switch = 0
    has_map_g_to_2 = 0
    has_map_i_to_4 = 0
    has_map_t_to_3 = 0
    has_map_u_to_0 = 0
    has_map_v_to_1 = 0
    has_default_map_0 = 0
    has_set_failure_zero = 0
    has_copy_to_primary = 0
    has_copy_to_secondary = 0
    has_free_scratch = 0
    has_fetch_next_section = 0
    has_normalize_next_section_error = 0
    has_prep_filebuf_free_size = 0
    has_free_filebuf = 0
    has_free_line_897 = 0
    has_return = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^LOCAVAIL_LOADAVAILABILITYDATAFILE:/ ||
        u ~ /^LOCAVAIL_LOADAVAILABILITYDATAFIL[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if ((u ~ /LOCAVAIL_PATH_DF0_COLON_LOCAVAIL/ || u ~ /LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT/) &&
        (u ~ /LOADFILETOWORKBUFFER/ || u ~ /GROUP_AY_JMPTBL_DISKIO_LOADFILET/)) {
        has_load_file = 1
    }

    if (u ~ /^MOVE\.B TEXTDISP_PRIMARYGROUPCODE/ || u ~ /^MOVE\.B TEXTDISP_PRIMARYGROUPCODE\(A4\),/) {
        has_set_primary_mode = 1
        has_fail_reset_primary = 1
    }
    if (u ~ /^MOVE\.B TEXTDISP_SECONDARYGROUPCODE/ || u ~ /^MOVE\.B TEXTDISP_SECONDARYGROUPCODE\(A4\),/) {
        has_set_secondary_mode = 1
        has_fail_reset_secondary = 1
    }

    if (u ~ /LOCAVAIL_FREERESOURCECHAIN/ && !has_reset_primary_chain) {
        has_reset_primary_chain = 1
    } else if (u ~ /LOCAVAIL_FREERESOURCECHAIN/ && !has_reset_secondary_chain) {
        has_reset_secondary_chain = 1
    } else if (u ~ /LOCAVAIL_FREERESOURCECHAIN/) {
        has_free_scratch = 1
    }

    if (u ~ /GLOBAL_REF_LONG_FILE_SCRATCH/ && u ~ /^MOVE\.L /) {
        has_capture_file_len = 1
    }
    if (u ~ /GLOBAL_PTR_WORK_BUFFER/ && u ~ /^MOVE\.L /) {
        has_capture_file_buf = 1
    }

    if (u ~ /CONSUMECSTRINGFROMWORKBUFFER/ || u ~ /GROUP_AY_JMPTBL_DISKIO_CONSUMECS/) {
        if (!has_fetch_section) {
            has_fetch_section = 1
        } else if (!has_fetch_encoded && has_store_payload_ptr) {
            has_fetch_encoded = 1
        } else {
            has_fetch_next_section = 1
        }
    }

    if ((u ~ /^MOVEA?\.W #\$?FFFF,A0$/ || u ~ /^MOVE\.L #\$?FFFF,A0$/) && !has_normalize_workbuf_error) {
        has_normalize_workbuf_error = 1
    } else if ((u ~ /^MOVEA?\.W #\$?FFFF,A0$/ || u ~ /^MOVE\.L #\$?FFFF,A0$/) && has_fetch_next_section) {
        has_normalize_next_section_error = 1
    }

    if ((u ~ /COMPARENOCASEN/ || u ~ /GROUP_AY_JMPTBL_STRING_COMPARENO/) &&
        u ~ /LOCAVAIL_STR_LA_VER/) {
        has_check_version = 1
    }

    if (u ~ /LOCAVAIL_RESETFILTERSTATESTRUCT/) {
        has_reset_scratch = 1
    }

    if (u ~ /PARSELONGFROMWORKBUFFER/ || u ~ /GROUP_AY_JMPTBL_DISKIO_PARSELONG/) {
        if (!has_parse_mode) {
            has_parse_mode = 1
        } else if (!has_parse_node_count) {
            has_parse_node_count = 1
        } else if (!has_parse_token_index) {
            has_parse_token_index = 1
        } else if (!has_parse_duration) {
            has_parse_duration = 1
        } else if (!has_parse_payload_size) {
            has_parse_payload_size = 1
        }
    }

    if (u ~ /^MOVE\.B \(A0\),D1$/ || u ~ /^MOVE\.B D1,\$?[0-9A-F]+\((A7|A5)\)$/) {
        has_capture_mode_char = 1
    }

    if (u ~ /LOCAVAIL_ALLOCNODEARRAYSFORSTATE/) {
        has_alloc_node_arrays = 1
    }
    if ((u ~ /^TST\.L D0$/ || u ~ /^TST\.L D[0-7]$/) && has_alloc_node_arrays) {
        has_alloc_result_test = 1
    }
    if ((u ~ /^TST\.L -22\(A5\)$/ || u ~ /^TST\.L D5$/) && has_alloc_result_test) {
        has_empty_alloc_failure_guard = 1
    }

    if ((u ~ /MATH_MULU32/ || u ~ /NEWGRID_JMPTBL_MATH_MULU32/) &&
        (u ~ /^JSR / || u ~ /^BSR(\.[A-Z]+)? /)) {
        has_node_offset_mul10 = 1
    }

    if (u ~ /^MOVE\.B D0,\(A0\)$/ || u ~ /^MOVE\.B D0,\(A[0-7]\)$/) {
        has_store_token_index = 1
    }
    if ((u ~ /^CMP\.B D1,D0$/ || u ~ /^TST\.B D0$/ || u ~ /^BEQ\.B / || u ~ /^BLS\.W /) &&
        has_store_token_index) {
        has_validate_token_nonzero = 1
    }
    if ((u ~ /^MOVEQ(\.L)? #\$?64,D1$/ || u ~ /^MOVEQ(\.L)? #100,D1$/ || u ~ /^CMP\.B D1,D0$/) &&
        has_store_token_index) {
        has_validate_token_upper = 1
    }

    if (u ~ /^MOVE\.W D0,2\(A0\)$/ || u ~ /^MOVE\.W D0,\$2\(A0\)$/) {
        has_store_duration = 1
    }
    if ((u ~ /^TST\.W D0$/ || u ~ /^TST\.W D[0-7]$/) && has_store_duration) {
        has_validate_duration_positive = 1
    }
    if (u ~ /^CMPI\.W #\$E11,D0$/ || u ~ /^CMPI\.W #\$E11,D[0-7]$/) {
        has_validate_duration_max = 1
    }

    if (u ~ /^MOVE\.W D0,4\(A0\)$/ || u ~ /^MOVE\.W D0,\$4\(A0\)$/) {
        has_store_payload_size = 1
    }
    if ((u ~ /^TST\.W D0$/ || u ~ /^TST\.W D[0-7]$/ || u ~ /^TST\.W D1$/) &&
        has_store_payload_size) {
        has_validate_payload_positive = 1
    }
    if ((u ~ /^MOVEQ(\.L)? #\$?64,D1$/ || u ~ /^MOVEQ(\.L)? #100,D1$/ || u ~ /^CMP\.L D1,D0$/ || u ~ /^CMP\.W D1,D0$/) &&
        has_store_payload_size) {
        has_validate_payload_max = 1
    }

    if ((u ~ /NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY/ || u ~ /ALLOCATEMEMORY/) &&
        u ~ /GLOBAL_STR_LOCAVAIL_C_7/) {
        has_alloc_payload = 1
    }
    if ((u ~ /^PEA \(\$312\)\.W$/ || u ~ /^PEA 786\.W$/) && has_alloc_payload) {
        has_alloc_line_786 = 1
    }
    if ((u ~ /^MOVE\.L #\$10001,-\(A7\)$/ || u ~ /^MOVE\.L #\(MEMF_PUBLIC\+MEMF_CLEAR\),-\(A7\)$/) &&
        has_alloc_payload) {
        has_alloc_memf_public_clear = 1
    }
    if (u ~ /^MOVE\.L D0,6\(A0\)$/ || u ~ /^MOVE\.L D0,\$6\(A0\)$/) {
        has_store_payload_ptr = 1
    }

    if ((u ~ /^SUBI?\.W #\$47,D0$/ || u ~ /^MOVEQ(\.L)? #\$47,D0$/ || u ~ /^JMP \$4\(PC,D1\.W\)$/) &&
        has_store_payload_ptr) {
        has_payload_decode_switch = 1
    }
    if (u ~ /^MOVE\.B #\$2,\(A0\)$/) {
        has_map_g_to_2 = 1
    }
    if (u ~ /^MOVE\.B #\$4,\(A0\)$/) {
        has_map_i_to_4 = 1
    }
    if (u ~ /^MOVE\.B #\$3,\(A0\)$/) {
        has_map_t_to_3 = 1
    }
    if (u ~ /^MOVE\.B #\$1,\(A0\)$/) {
        has_map_v_to_1 = 1
    }
    if (u ~ /^CLR\.B \(A0\)$/ && !has_map_u_to_0) {
        has_map_u_to_0 = 1
    } else if (u ~ /^CLR\.B \(A0\)$/) {
        has_default_map_0 = 1
    }
    if ((u ~ /^MOVEQ(\.L)? #\$?0,D5$/ || u ~ /^MOVEQ(\.L)? #\$?0,D7$/) &&
        (has_parse_token_index || has_store_payload_ptr)) {
        has_set_failure_zero = 1
    }

    if (u ~ /LOCAVAIL_COPYFILTERSTATESTRUCTRETAINREFS/ || u ~ /LOCAVAIL_COPYFILTERSTATESTRUCTRE/) {
        if (!has_copy_to_primary) {
            has_copy_to_primary = 1
        } else {
            has_copy_to_secondary = 1
        }
    }

    if ((u ~ /^MOVE\.L D6,D0$/ || u ~ /^MOVE\.L D[0-7],D0$/) && has_fetch_next_section) {
        has_prep_filebuf_free_size = 1
    }
    if ((u ~ /NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || u ~ /DEALLOCATEMEMORY/) &&
        u ~ /GLOBAL_STR_LOCAVAIL_C_8/) {
        has_free_filebuf = 1
    }
    if ((u ~ /^PEA \(\$381\)\.W$/ || u ~ /^PEA 897\.W$/) && has_free_filebuf) {
        has_free_line_897 = 1
    }

    if (u == "RTS") {
        has_return = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD_FILE=" has_load_file
    print "HAS_FAIL_RESET_PRIMARY=" has_fail_reset_primary
    print "HAS_FAIL_RESET_SECONDARY=" has_fail_reset_secondary
    print "HAS_RESET_PRIMARY_CHAIN=" has_reset_primary_chain
    print "HAS_RESET_SECONDARY_CHAIN=" has_reset_secondary_chain
    print "HAS_SET_PRIMARY_MODE=" has_set_primary_mode
    print "HAS_SET_SECONDARY_MODE=" has_set_secondary_mode
    print "HAS_CAPTURE_FILE_LEN=" has_capture_file_len
    print "HAS_CAPTURE_FILE_BUF=" has_capture_file_buf
    print "HAS_FETCH_SECTION=" has_fetch_section
    print "HAS_NORMALIZE_WORKBUF_ERROR=" has_normalize_workbuf_error
    print "HAS_CHECK_VERSION=" has_check_version
    print "HAS_RESET_SCRATCH=" has_reset_scratch
    print "HAS_PARSE_MODE=" has_parse_mode
    print "HAS_PARSE_NODE_COUNT=" has_parse_node_count
    print "HAS_CAPTURE_MODE_CHAR=" has_capture_mode_char
    print "HAS_ALLOC_NODE_ARRAYS=" has_alloc_node_arrays
    print "HAS_ALLOC_RESULT_TEST=" has_alloc_result_test
    print "HAS_EMPTY_ALLOC_FAILURE_GUARD=" has_empty_alloc_failure_guard
    print "HAS_NODE_OFFSET_MUL10=" has_node_offset_mul10
    print "HAS_PARSE_TOKEN_INDEX=" has_parse_token_index
    print "HAS_STORE_TOKEN_INDEX=" has_store_token_index
    print "HAS_VALIDATE_TOKEN_NONZERO=" has_validate_token_nonzero
    print "HAS_VALIDATE_TOKEN_UPPER=" has_validate_token_upper
    print "HAS_PARSE_DURATION=" has_parse_duration
    print "HAS_STORE_DURATION=" has_store_duration
    print "HAS_VALIDATE_DURATION_POSITIVE=" has_validate_duration_positive
    print "HAS_VALIDATE_DURATION_MAX=" has_validate_duration_max
    print "HAS_PARSE_PAYLOAD_SIZE=" has_parse_payload_size
    print "HAS_STORE_PAYLOAD_SIZE=" has_store_payload_size
    print "HAS_VALIDATE_PAYLOAD_POSITIVE=" has_validate_payload_positive
    print "HAS_VALIDATE_PAYLOAD_MAX=" has_validate_payload_max
    print "HAS_ALLOC_PAYLOAD=" has_alloc_payload
    print "HAS_ALLOC_LINE_786=" has_alloc_line_786
    print "HAS_ALLOC_MEMF_PUBLIC_CLEAR=" has_alloc_memf_public_clear
    print "HAS_STORE_PAYLOAD_PTR=" has_store_payload_ptr
    print "HAS_FETCH_ENCODED=" has_fetch_encoded
    print "HAS_PAYLOAD_DECODE_SWITCH=" has_payload_decode_switch
    print "HAS_MAP_G_TO_2=" has_map_g_to_2
    print "HAS_MAP_I_TO_4=" has_map_i_to_4
    print "HAS_MAP_T_TO_3=" has_map_t_to_3
    print "HAS_MAP_U_TO_0=" has_map_u_to_0
    print "HAS_MAP_V_TO_1=" has_map_v_to_1
    print "HAS_DEFAULT_MAP_0=" has_default_map_0
    print "HAS_SET_FAILURE_ZERO=" has_set_failure_zero
    print "HAS_COPY_TO_PRIMARY=" has_copy_to_primary
    print "HAS_COPY_TO_SECONDARY=" has_copy_to_secondary
    print "HAS_FREE_SCRATCH=" has_free_scratch
    print "HAS_FETCH_NEXT_SECTION=" has_fetch_next_section
    print "HAS_NORMALIZE_NEXT_SECTION_ERROR=" has_normalize_next_section_error
    print "HAS_PREP_FILEBUF_FREE_SIZE=" has_prep_filebuf_free_size
    print "HAS_FREE_FILEBUF=" has_free_filebuf
    print "HAS_FREE_LINE_897=" has_free_line_897
    print "HAS_RETURN=" has_return
}
