BEGIN {
    has_entry = 0
    has_frame = 0
    has_guard = 0
    has_wait = 0
    has_read = 0
    has_0x14 = 0
    has_0x12 = 0
    has_limit = 0
    has_checksum = 0
    has_finish = 0
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

    if (u ~ /^ESQIFF2_READSERIALRECORDINTOBUFFER:/ || u ~ /^ESQIFF2_READSERIALRECORDINTOB[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^LINK\.W A5,#-12$/ || u ~ /^LINK\.W A[0-7],#-[0-9]+$/ || u ~ /^LINK\.W A[0-7],#-\$[0-9A-F]+$/) has_frame = 1
    if (index(u, "__BASE(A4)") > 0 || index(u, "_XCOVF") > 0) has_stack_guard = 1
    if (u ~ /^CMPI\.W #\$2328,D4$/ || u ~ /^CMPI\.W #\$2328,D[0-7]$/ || u ~ /^CMPI\.W #9000,D[0-7]$/ || u ~ /^TST\.W D7$/) has_guard = 1
    if (index(u, "ESQFUNC_WAITFORCLOCKCHANGEANDSERVICEUI") > 0 || index(u, "WAITFORCLOCKCHANGEANDSERVICEUI") > 0 || index(u, "WAITFORCLOCKCHANGEANDSER") > 0) has_wait = 1
    if (index(u, "ESQPARS_JMPTBL_SCRIPT_READSERIALRBFBYTE") > 0 || index(u, "READSERIALRBFBYTE") > 0 || index(u, "ESQPARS_JMPTBL_SCRIPT_READSERIAL") > 0 || index(u, "READSERIAL") > 0) has_read = 1
    if (u ~ /^MOVEQ(\.L)? #20,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$14,D[0-7]$/ || index(u, "LOOP_COPY_0X14_EXTENSION") > 0) has_0x14 = 1
    if (u ~ /^MOVEQ(\.L)? #18,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$12,D[0-7]$/ || index(u, "CHECK_0X12_DELIMITER_CASE") > 0) has_0x12 = 1
    if (u ~ /^CMPI\.W #\$12E,-6\(A5\)$/ || u ~ /^CMPI\.W #\$12E,[-$0-9A-Z()]+$/ || u ~ /^CMPI\.W #302,[-$0-9A-Z()]+$/) has_limit = 1
    if (index(u, "MOVE.B D0,ESQIFF_RECORDCHECKSUMBYTE") > 0 || index(u, "ESQIFF_RECORDCHECKSUMBYTE") > 0) has_checksum = 1
    if (u ~ /^MOVE\.L D4,D0$/ || u ~ /^MOVE\.W D[0-7],D0$/ || u ~ /^MOVE\.L D[0-7],D0$/) has_finish = 1
    if (u ~ /^MOVEM\.L \(A7\)\+,D4-D7\/A3$/ || u ~ /^MOVEM\.L \(A7\)\+,[DA][0-7].*$/) has_restore = 1
    if (u ~ /^UNLK A5$/ || u ~ /^UNLK A[0-7]$/ || u ~ /^ADDQ\.W #\$[0-9A-F]+,A7$/ || u ~ /^ADDQ\.W #[0-9]+,A7$/) has_unlk = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (has_stack_guard) {
        has_frame = 1
        has_unlk = 1
    }

    print "HAS_ENTRY=" has_entry
    print "HAS_FRAME=" has_frame
    print "HAS_GUARD=" has_guard
    print "HAS_WAIT=" has_wait
    print "HAS_READ=" has_read
    print "HAS_0X14=" has_0x14
    print "HAS_0X12=" has_0x12
    print "HAS_LIMIT=" has_limit
    print "HAS_CHECKSUM=" has_checksum
    print "HAS_FINISH=" has_finish
    print "HAS_RESTORE=" has_restore
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
