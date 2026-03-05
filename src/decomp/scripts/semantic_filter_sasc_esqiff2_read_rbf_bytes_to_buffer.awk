BEGIN {
    has_entry = 0
    has_link = 0
    has_save = 0
    has_loop_cmp = 0
    has_loop_exit = 0
    has_wait = 0
    has_read_byte = 0
    has_store = 0
    has_inc = 0
    has_back_branch = 0
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

    if (u ~ /^ESQIFF2_READRBFBYTESTOBUFFER:/ || u ~ /^ESQIFF2_READRBFBYTESTOBUFFE[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^LINK\.W A5,#-4$/ || u ~ /^LINK\.W A[0-7],#-[0-9]+$/ || u ~ /^LINK\.W A[0-7],#-\$[0-9A-F]+$/) has_link = 1
    if (u ~ /^CMP\.L __BASE\(A4\),A7$/) has_stack_guard = 1
    if (u ~ /^MOVEM\.L D6-D7\/A3,-\(A7\)$/ || u ~ /^MOVEM\.L [DA][0-7](\/[DA][0-7])+,-\(A7\)$/) has_save = 1
    if (u ~ /^CMP\.W D7,D6$/ || u ~ /^CMP\.W D[0-7],D[0-7]$/) has_loop_cmp = 1
    if (u ~ /^BGE\.[SWB] ESQIFF2_READSERIALBYTESTOBUFFER_RETURN$/ || u ~ /^BGE\.[SWB] ___ESQIFF2_READRBFBYTESTOBUFFE/ || u ~ /^BCC\.[SWB] ___ESQIFF2_READRBFBYTESTOBUFFE/ || u ~ /^BCC\.[SWB] ESQIFF2_READSERIALBYTESTOBUFFER_RETURN$/) has_loop_exit = 1
    if (index(u, "ESQFUNC_WAITFORCLOCKCHANGEANDSERVICEUI") > 0 || index(u, "WAITFORCLOCKCHANGEANDSERVICEUI") > 0 || index(u, "ESQFUNC_WAITFORCLOCKCHANGEANDSER") > 0 || index(u, "WAITFORCLOCKCHANGEANDSER") > 0) has_wait = 1
    if (index(u, "ESQPARS_JMPTBL_SCRIPT_READSERIALRBFBYTE") > 0 || index(u, "READSERIALRBFBYTE") > 0 || index(u, "ESQPARS_JMPTBL_SCRIPT_READSERIAL") > 0 || index(u, "READSERIAL") > 0) has_read_byte = 1
    if (u ~ /^MOVE\.B D0,\(A0\)$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/) has_store = 1
    if (u ~ /^ADDQ\.W #1,D6$/ || u ~ /^ADDQ\.W #\$1,D6$/ || u ~ /^ADDQ\.W #1,D[0-7]$/) has_inc = 1
    if (u ~ /^BRA\.[SWB] \.LOOP_READ_SERIAL_BYTE_TO_BUFFER$/ || u ~ /^BRA\.[SWB] ___ESQIFF2_READRBFBYTESTOBUFFE/) has_back_branch = 1
    if (u ~ /^MOVE\.L A3,D0$/ || u ~ /^MOVE\.L A[0-7],D0$/) has_return_ptr = 1
    if (u ~ /^MOVEM\.L \(A7\)\+,D6-D7\/A3$/ || u ~ /^MOVEM\.L \(A7\)\+,[DA][0-7].*$/) has_restore = 1
    if (u ~ /^UNLK A5$/ || u ~ /^UNLK A[0-7]$/) has_unlk = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (has_stack_guard) {
        has_link = 1
        has_unlk = 1
    }

    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_LOOP_CMP=" has_loop_cmp
    print "HAS_LOOP_EXIT=" has_loop_exit
    print "HAS_WAIT=" has_wait
    print "HAS_READ_BYTE=" has_read_byte
    print "HAS_STORE=" has_store
    print "HAS_INC=" has_inc
    print "HAS_BACK_BRANCH=" has_back_branch
    print "HAS_RETURN_PTR=" has_return_ptr
    print "HAS_RESTORE=" has_restore
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
