BEGIN {
    has_entry = 0
    has_reset_path = 0
    has_allowed_gate = 0
    has_count_gate = 0
    has_entry_init = 0
    has_temp_alloc = 0
    has_pen_control = 0
    has_time_window_control = 0
    has_emit_char = 0
    has_finalize_text = 0
    has_attr_realloc = 0
    has_attr_copy = 0
    has_temp_free = 0
    has_update = 0
    has_success_return = 0
    has_zero_return = 0

    saw_status_flag = 0
    saw_reset_tag = 0
    saw_reset_find = 0
    saw_reset_buffers = 0

    saw_allowed_tag = 0
    saw_allowed_find = 0
    saw_entry_limit = 0

    saw_count_ref = 0
    saw_count_add = 0
    saw_count_store = 0

    saw_start_default = 0
    saw_end_default = 0

    saw_alloc_304 = 0
    saw_alloc_temp_line = 0
    saw_alloc_call = 0

    pen_parse_calls = 0
    saw_set_high = 0
    saw_set_low = 0

    validate_calls = 0
    saw_ctrl20 = 0

    saw_attr_store = 0
    saw_text_store = 0
    saw_len_inc = 0

    saw_terminate = 0
    saw_replace = 0

    free_calls = 0
    alloc_calls = 0
    saw_old_attr_ref = 0
    saw_old_attr_tag = 0
    saw_attr_alloc_line = 0

    saw_copy_loop = 0
    saw_temp_free_line = 0
    saw_temp_free_tag = 0
    saw_return_one = 0
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = norm($0)
    if (line == "") {
        next
    }

    if (line ~ /^LADFUNC_PARSEBANNERENTRYDATA:/ ||
        line ~ /^LADFUNC_PARSEBANNERENTRYDATA[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (index(line, "ESQIFF_STATUSPACKETREADYFLAG") > 0) {
        saw_status_flag = 1
    }
    if (index(line, "LADFUNC_TAG_RS_RESETTRIGGERSET") > 0) {
        saw_reset_tag = 1
    }
    if (index(line, "GROUP_AS_JMPTBL_STR_FINDCHARPTR") > 0 ||
        index(line, "GROUP_AS_JMPTBL_STR_FINDCHAR") > 0) {
        if (saw_reset_tag && !saw_allowed_tag) {
            saw_reset_find = 1
        }
        if (saw_allowed_tag) {
            saw_allowed_find = 1
        }
    }
    if (index(line, "LADFUNC_RESETENTRYTEXTBUFFERS") > 0 ||
        index(line, "LADFUNC_RESETENTRYTEXTBU") > 0) {
        saw_reset_buffers = 1
    }
    if (saw_status_flag && saw_reset_tag && saw_reset_find && saw_reset_buffers) {
        has_reset_path = 1
    }

    if (index(line, "LADFUNC_TAG_RS_PARSEALLOWEDSET") > 0) {
        saw_allowed_tag = 1
    }
    if (line ~ /^MOVE\.B #\$2E,/ || line ~ /^MOVE\.B #46,/ ||
        line ~ /^MOVEQ(\.L)? #\$?2E,D[0-7]$/ || line ~ /^MOVEQ #46,D[0-7]$/) {
        saw_entry_limit = 1
    }
    if (saw_allowed_tag && saw_entry_limit) {
        has_allowed_gate = 1
    }

    if (index(line, "LADFUNC_PARSEDENTRYCOUNT") > 0) {
        saw_count_ref = 1
        if (line ~ /^MOVE\.W D[0-7],LADFUNC_PARSEDENTRYCOUNT/ ||
            line ~ /^MOVE\.W D[0-7], LADFUNC_PARSEDENTRYCOUNT/) {
            saw_count_store = 1
        }
    }
    if (line ~ /^ADDQ\.W #\$?1,D[0-7]$/ || line ~ /^ADDQ\.W #1,D[0-7]$/) {
        saw_count_add = 1
    }
    if (saw_count_ref && saw_count_add && saw_count_store) {
        has_count_gate = 1
    }

    if (line ~ /^MOVE\.W #\$?1,\(A[0-7]\)$/ || line ~ /^MOVE\.W #1,\(A[0-7]\)$/ ||
        index(line, "MOVE.W D0,(A2)") > 0 || index(line, "MOVE.W D0, (A2)") > 0) {
        saw_start_default = 1
    }
    if (line ~ /^MOVE\.W #\$30,\$?2\(A[0-7]\)$/ ||
        index(line, "MOVE.W $1CE(A7),$2(A2)") > 0 ||
        index(line, "MOVE.W D1,$2(A2)") > 0) {
        saw_end_default = 1
    }
    if (saw_start_default && saw_end_default) {
        has_entry_init = 1
    }

    if (line ~ /^PEA 304\.W$/ || line ~ /^MOVE\.W #\$130,D[0-7]$/ ||
        line ~ /^MOVE\.L #\$130,/ || line ~ /^MOVE\.W \$1CC\(A7\),D[0-7]$/) {
        saw_alloc_304 = 1
    }
    if (line ~ /^PEA 367\.W$/ || line ~ /^PEA \(\$16F\)\.W$/ ||
        index(line, "GLOBAL_STR_LADFUNC_C_5") > 0) {
        saw_alloc_temp_line = 1
    }
    if (index(line, "NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0 ||
        index(line, "NEWGRID_JMPTBL_MEMORY_ALLOCATEME") > 0) {
        alloc_calls++
        if (alloc_calls == 1) {
            saw_alloc_call = 1
        }
    }
    if (saw_alloc_304 && saw_alloc_temp_line && alloc_calls >= 1) {
        has_temp_alloc = 1
    }

    if (index(line, "LADFUNC_PARSEHEXDIGIT") > 0 ||
        index(line, "LADFUNC_PARSEHEXDIG") > 0) {
        pen_parse_calls++
    }
    if (index(line, "LADFUNC_SETPACKEDPENHIGHNIBBLE") > 0 ||
        index(line, "LADFUNC_SETPACKEDPENHIGHN") > 0) {
        saw_set_high = 1
    }
    if (index(line, "LADFUNC_SETPACKEDPENLOWNIBBLE") > 0 ||
        index(line, "LADFUNC_SETPACKEDPENLOWNI") > 0) {
        saw_set_low = 1
    }
    if (pen_parse_calls >= 2 && saw_set_high && saw_set_low) {
        has_pen_control = 1
    }

    if (line ~ /^MOVEQ(\.L)? #\$14,D[0-7]$/ || line ~ /^MOVEQ #20,D[0-7]$/) {
        saw_ctrl20 = 1
    }
    if (index(line, "ESQIFF2_VALIDATEASCIINUMERICBYTE") > 0 ||
        index(line, "ESQIFF2_VALIDATEASCIINUME") > 0 ||
        index(line, "VALIDATEASCII") > 0) {
        validate_calls++
    }
    if (saw_ctrl20 || validate_calls >= 2) {
        if (validate_calls >= 2) {
            has_time_window_control = 1
        }
    }
    if (validate_calls >= 2) {
        has_time_window_control = 1
    }

    if (line ~ /^MOVE\.B D[0-7],\$0\(A[0-7],D[0-7]\.L\)$/ ||
        line ~ /^MOVE\.B \$[0-9A-F]+\((A[0-7]|A7)\),\$0\(A[0-7],D[0-7]\.L\)$/ ||
        line ~ /^MOVE\.B \$[0-9A-F-]+\((A[0-7]|A7)\),0\(A[0-7],D[0-7]\.W\)$/ ||
        index(line, "0(A0,D6.W)") > 0 || index(line, "$0(A3,D1.L)") > 0) {
        saw_attr_store = 1
    }
    if (line ~ /^MOVE\.B D[0-7],\$[0-9A-F]+\((A[0-7]|A7),D[0-7]\.L\)$/ ||
        line ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/ ||
        line ~ /^MOVE\.B \$[0-9A-F-]+\((A[0-7]|A7)\),\(A[0-7]\)$/) {
        saw_text_store = 1
    }
    if (line ~ /^ADDQ\.W #\$?1,D[0-7]$/ || line ~ /^ADDQ\.W #1,D[0-7]$/) {
        saw_len_inc = 1
    }
    if (saw_attr_store && saw_text_store && saw_len_inc) {
        has_emit_char = 1
    }

    if (line ~ /^CLR\.B \(A[0-7]\)$/ ||
        line ~ /^CLR\.B \$[0-9A-F]+\((A[0-7]|A7),D[0-7]\.L\)$/) {
        saw_terminate = 1
    }
    if (index(line, "ESQPARS_REPLACEOWNEDSTRING") > 0 ||
        index(line, "ESQPARS_REPLACEOWNEDSTR") > 0) {
        saw_replace = 1
    }
    if (saw_terminate && saw_replace) {
        has_finalize_text = 1
    }

    if (index(line, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 ||
        index(line, "NEWGRID_JMPTBL_MEMORY_DEALLOCATE") > 0) {
        free_calls++
    }
    if (line ~ /^TST\.L \$A\(A[0-7]\)$/ || line ~ /^MOVE\.L \$A\(A[0-7]\),-\(A7\)$/) {
        saw_old_attr_ref = 1
    }
    if (index(line, "GLOBAL_STR_LADFUNC_C_6") > 0) {
        saw_old_attr_tag = 1
    }
    if (line ~ /^PEA 413\.W$/ || index(line, "GLOBAL_STR_LADFUNC_C_7") > 0) {
        saw_attr_alloc_line = 1
    }
    if ((saw_old_attr_ref || saw_old_attr_tag) && saw_attr_alloc_line &&
        alloc_calls >= 2 && free_calls >= 1) {
        has_attr_realloc = 1
    }

    if (line ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/ ||
        line ~ /^MOVE\.B \$0\(A[0-7],D[0-7]\.L\),\(A[0-7]\)$/ ||
        line ~ /^MOVE\.B \$0\(A[0-7],D[0-7]\.L\),\(A[0-7]\)$/ ||
        line ~ /^MOVE\.B \$0\(A[0-7],D[0-7]\.L\),\$0?\(A[0-7]\)$/) {
        saw_copy_loop = 1
    }
    if (saw_copy_loop) {
        has_attr_copy = 1
    }

    if (line ~ /^PEA 416\.W$/ || index(line, "GLOBAL_STR_LADFUNC_C_8") > 0) {
        saw_temp_free_line = 1
        saw_temp_free_tag = 1
    }
    if ((saw_temp_free_line || saw_temp_free_tag) && free_calls >= 2) {
        has_temp_free = 1
    }

    if (index(line, "LADFUNC_UPDATEHIGHLIGHTSTATE") > 0 ||
        index(line, "LADFUNC_UPDATEHIGHLIGHTST") > 0) {
        has_update = 1
    }

    if (line ~ /^MOVEQ(\.L)? #\$?1,D0$/ || line ~ /^MOVEQ #1,D0$/) {
        saw_return_one = 1
    }
    if (saw_return_one && line == "RTS") {
        has_success_return = 1
    }
    if ((line ~ /^MOVEQ(\.L)? #\$?0,D0$/ || line ~ /^MOVEQ #0,D0$/) && !saw_return_one) {
        has_zero_return = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_RESET_PATH=" has_reset_path
    print "HAS_ALLOWED_GATE=" has_allowed_gate
    print "HAS_COUNT_GATE=" has_count_gate
    print "HAS_ENTRY_INIT=" has_entry_init
    print "HAS_TEMP_ALLOC=" has_temp_alloc
    print "HAS_PEN_CONTROL=" has_pen_control
    print "HAS_TIME_WINDOW_CONTROL=" has_time_window_control
    print "HAS_EMIT_CHAR=" has_emit_char
    print "HAS_FINALIZE_TEXT=" has_finalize_text
    print "HAS_ATTR_REALLOC=" has_attr_realloc
    print "HAS_ATTR_COPY=" has_attr_copy
    print "HAS_TEMP_FREE=" has_temp_free
    print "HAS_UPDATE=" has_update
    print "HAS_SUCCESS_RETURN=" has_success_return
    print "HAS_ZERO_RETURN=" has_zero_return
}
