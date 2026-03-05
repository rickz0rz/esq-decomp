BEGIN {
    has_entry = 0
    has_frame = 0
    has_size_guard = 0
    has_initial_loop = 0
    has_trailer_parse = 0
    has_trailer_loop = 0
    has_fail_path = 0
    has_checksum = 0
    has_finish = 0
    has_return_ptr = 0
    has_restore = 0
    has_unlk = 0
    has_rts = 0
    has_stack_guard = 0
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
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^ESQIFF2_READSERIALSIZEDTEXTRECORD:/ || u ~ /^ESQIFF2_READSERIALSIZEDTEXTR[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^LINK\.W A5,#-4$/ || u ~ /^LINK\.W A[0-7],#-[0-9]+$/ || u ~ /^LINK\.W A[0-7],#-\$[0-9A-F]+$/) has_frame = 1
    if (index(u, "__BASE(A4)") > 0 || index(u, "_XCOVF") > 0) has_stack_guard = 1
    if (u ~ /^TST\.L D7$/ || u ~ /^CMPI\.L #\$2328,D7$/ || u ~ /^CMPI\.L #9000,D7$/) has_size_guard = 1
    if (index(u, "MOVE.B D0,0(A3,D1.L)") > 0 || index(u, "MOVE.B D0,$0(A5,D1.W)") > 0 || index(u, "ADDQ.W #1,D4") > 0 || index(u, "ADDQ.W #$1,D5") > 0 || index(u, "ADDQ.L #1,D6") > 0) has_initial_loop = 1
    if (index(u, "PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 || index(u, "READSIGNEDLONGSKIPCLASS3") > 0 || index(u, "PARSE_READSIGNEDL") > 0) has_trailer_parse = 1
    if (index(u, "TST.B -1(A3,D0.L)") > 0 || index(u, "TST.B $FFFFFFFF(A5,D0.L)") > 0 || index(u, "CMP.L D5,D6") > 0 || index(u, "CMP.L D4,D0") > 0 || index(u, "CMPI.W #$2328,D4") > 0 || index(u, "CMPI.W #$2328,D5") > 0 || index(u, "CMPI.W #9000,D4") > 0) has_trailer_loop = 1
    if (index(u, "CLR.B (A3)") > 0 || index(u, "CLR.B (A5)") > 0 || index(u, "MOVEQ.L #$0,D4") > 0 || index(u, "MOVEQ #0,D4") > 0 || index(u, "MOVEQ.L #$0,D5") > 0 || index(u, "MOVEQ #0,D5") > 0) has_fail_path = 1
    if (index(u, "MOVE.B D0,ESQIFF_RECORDCHECKSUMBYTE") > 0 || index(u, "ESQIFF_RECORDCHECKSUMBYTE") > 0) has_checksum = 1
    if (index(u, "MOVE.L D4,D0") > 0 || index(u, "MOVE.W D5,D0") > 0) has_finish = 1
    if (u ~ /^MOVEM\.L \(A7\)\+,D4-D7\/A3$/ || u ~ /^MOVEM\.L \(A7\)\+,[DA][0-7].*$/) has_restore = 1
    if (u ~ /^UNLK A5$/ || u ~ /^UNLK A[0-7]$/ || u ~ /^ADDQ\.W #\$8,A7$/ || u ~ /^ADDQ\.W #8,A7$/) has_unlk = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (has_stack_guard) {
        has_frame = 1
        has_unlk = 1
    }
    if (has_finish) has_return_ptr = 1

    print "HAS_ENTRY=" has_entry
    print "HAS_FRAME=" has_frame
    print "HAS_SIZE_GUARD=" has_size_guard
    print "HAS_INITIAL_LOOP=" has_initial_loop
    print "HAS_TRAILER_PARSE=" has_trailer_parse
    print "HAS_TRAILER_LOOP=" has_trailer_loop
    print "HAS_FAIL_PATH=" has_fail_path
    print "HAS_CHECKSUM=" has_checksum
    print "HAS_FINISH=" has_finish
    print "HAS_RETURN_PTR=" has_return_ptr
    print "HAS_RESTORE=" has_restore
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
