BEGIN {
    seen_entry = 0
    header_reads = 0
    seen_zero_index = 0
    seen_loop_fetch = 0
    seen_loop_store = 0
    seen_delim_check = 0
    seen_limit_check = 0
    seen_index_increment = 0
    seen_nul_term = 0
    seen_mode_read = 0
    zero_ext_count = 0
    seen_zero_ext_args = 0
    seen_payload_push = 0
    long_pushes = 0
    seen_title_push = 0
    seen_update_call = 0
    seen_stack_cleanup = 0
    seen_rts = 0
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
    u = norm($0)
    if (u == "") {
        next
    }

    if (u ~ /^ESQSHARED_PARSECOMPACTENTRYRECORD:/ ||
        u ~ /^ESQSHARED_PARSECOMPACTENTRYRECOR[A-Z0-9_]*:/) {
        seen_entry = 1
    }

    if (!seen_mode_read && u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) {
        if (header_reads < 2) {
            ++header_reads
        } else {
            seen_loop_fetch = 1
        }
    }

    if (u ~ /^MOVEQ(\.L)? #\$?0,D[0-7]$/ || u ~ /^CLR\.B [-$0-9A-F]+\((A[0-7]|A5)\)$/) {
        seen_zero_index = 1
    }

    if (u ~ /^MOVE\.B D[0-7],[-$0-9A-F]+\((A[0-7]|A5),D[0-7]\.[WL]\)$/) {
        seen_loop_store = 1
    }

    if (u ~ /^CMP\.B D[0-7],D[0-7]$/ ||
        u ~ /^CMP\.B #\$?12,D[0-7]$/ ||
        u ~ /^MOVEQ(\.L)? #\$?12,D[0-7]$/) {
        seen_delim_check = 1
    }

    if (u ~ /^CMP\.[BW] D[0-7],D[0-7]$/ ||
        u ~ /^CMP\.[BW] #\$?8,D[0-7]$/ ||
        u ~ /^MOVEQ(\.L)? #\$?8,D[0-7]$/) {
        seen_limit_check = 1
    }

    if (u ~ /^ADDQ\.[BW] #\$?1,D[0-7]$/ ||
        u ~ /^ADDQ\.[BW] #\$?1,[-$0-9A-F]+\((A[0-7]|A5)\)$/) {
        seen_index_increment = 1
    }

    if (u ~ /^CLR\.B [-$0-9A-F]+\((A[0-7]|A5),D[0-7]\.[WL]\)$/) {
        seen_nul_term = 1
    }

    if (seen_nul_term && !seen_mode_read && u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) {
        seen_mode_read = 1
    }

    if (prev ~ /^MOVEQ(\.L)? #\$?0,D[0-7]$/) {
        zero_reg = substr(prev, length(prev), 1)
    } else {
        zero_reg = ""
    }

    if (seen_mode_read && zero_reg != "" && u ~ ("^MOVE\\.B [^,]+,D" zero_reg "$")) {
        ++zero_ext_count
    }
    if (zero_ext_count >= 3) {
        seen_zero_ext_args = 1
    }

    if (seen_mode_read && u ~ /^MOVE\.L A[0-7],-\(A7\)$/) {
        seen_payload_push = 1
    }
    if (seen_mode_read && u ~ /^MOVE\.L D[0-7],-\(A7\)$/) {
        ++long_pushes
    }
    if (seen_mode_read && u ~ /^PEA /) {
        seen_title_push = 1
    }

    if (u ~ /(JSR|BSR).*UPDATEMATCHINGENTRIESB/ ||
        u ~ /(JSR|BSR).*UPDATEMATCHINGENTRIESBYTITLE/) {
        seen_update_call = 1
    }

    if (u ~ /^LEA [$0-9A-F]+\((A7|SP)\),(A7|SP)$/ ||
        u ~ /^ADD\.[WL] #\$?14,(A7|SP)$/ ||
        (seen_update_call && u ~ /^MOVEM\.L .*$/) ||
        (seen_update_call && u ~ /^UNLK A[0-7]$/)) {
        seen_stack_cleanup = 1
    }

    if (u == "RTS") {
        seen_rts = 1
    }

    prev = u
}

END {
    print "HAS_ENTRY=" seen_entry
    print "HAS_HEADER_READS=" (header_reads >= 2 ? 1 : 0)
    print "HAS_ZERO_INDEX=" seen_zero_index
    print "HAS_LOOP_FETCH=" seen_loop_fetch
    print "HAS_LOOP_STORE=" seen_loop_store
    print "HAS_DELIM_CHECK=" seen_delim_check
    print "HAS_LIMIT_CHECK=" seen_limit_check
    print "HAS_INDEX_INCREMENT=" seen_index_increment
    print "HAS_NUL_TERM=" seen_nul_term
    print "HAS_MODE_READ=" seen_mode_read
    print "HAS_ZERO_EXT_ARGS=" seen_zero_ext_args
    print "HAS_PAYLOAD_PUSH=" seen_payload_push
    print "HAS_LONG_ARG_PUSHES=" (long_pushes >= 3 ? 1 : 0)
    print "HAS_TITLE_PUSH=" seen_title_push
    print "HAS_UPDATE_CALL=" seen_update_call
    print "HAS_STACK_CLEANUP=" seen_stack_cleanup
    print "HAS_RTS=" seen_rts
}
