BEGIN {
    has_entry = 0
    has_entry_check_before_title_alloc = 0
    has_name_error_direct_exit = 0
    has_skip_reset_before_slot_loop = 0

    alloc_count = 0
    saw_entry_result_test = 0
    consume_count = 0
    post_first_name_consume = 0
    in_name_copy_window = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return t
}

function alnum(s, t) {
    t = toupper(s)
    gsub(/[^A-Z0-9]/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    u = toupper(line)
    n = alnum(line)

    if (u ~ /^DISKIO2_LOADNXTDAYDATAFILE:/ || u ~ /^DISKIO2_LOADNXTDAYDATAFILE[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (n ~ /(GROUPAGJMPTBLMEMORYALLOCATEMEMORY|MEMORYALLOCATEMEMORY)/) {
        alloc_count++
        if (alloc_count == 1) {
            saw_entry_result_test = 0
        } else if (alloc_count == 2 && saw_entry_result_test) {
            has_entry_check_before_title_alloc = 1
        }
    }

    if (alloc_count == 1) {
        if (u ~ /^TST\.L / || n ~ /MOVELA3D0/ || n ~ /MOVELA3D0/ || n ~ /MOVEALD0A3/ || n ~ /MOVELD0A3/) {
            saw_entry_result_test = 1
        }
        if (u ~ /^BNE/ && saw_entry_result_test) {
            saw_entry_result_test = 1
        }
    }

    if (n ~ /DISKIOCONSUMECSTRINGFROMWORKBUFFER/ || n ~ /DISKIOCONSUMECSTRINGFROMWORKBUF/) {
        consume_count++
        if (consume_count == 1) {
            post_first_name_consume = 1
        } else {
            post_first_name_consume = 0
            in_name_copy_window = 0
        }
    }

    if (post_first_name_consume) {
        if (u ~ /^BRA/) {
            has_name_error_direct_exit = 1
        } else if (u ~ /^MOVEA\.L A2,A1$/ || u ~ /^MOVE\.L A2,/) {
            in_name_copy_window = 1
        }
    }

    if (in_name_copy_window) {
        if ((u ~ /^MOVE\.W #\$FFFFFFFF,/ || u ~ /^MOVE\.W #\(-1\),/) && u !~ /,A0$/) {
            has_skip_reset_before_slot_loop = 1
            post_first_name_consume = 0
            in_name_copy_window = 0
        }
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ENTRY_CHECK_BEFORE_TITLE_ALLOC=" has_entry_check_before_title_alloc
    print "HAS_NAME_ERROR_DIRECT_EXIT=" has_name_error_direct_exit
    print "HAS_SKIP_RESET_BEFORE_SLOT_LOOP=" has_skip_reset_before_slot_loop
}
