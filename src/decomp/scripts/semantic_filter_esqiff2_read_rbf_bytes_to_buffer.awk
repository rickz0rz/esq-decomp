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
    uline = toupper(line)

    if (uline ~ /^ESQIFF2_READRBFBYTESTOBUFFER:/) has_entry = 1
    if (uline ~ /^LINK\.W A5,#-4$/) has_link = 1
    if (uline ~ /^MOVEM\.L D6-D7\/A3,-\(A7\)$/) has_save = 1
    if (uline ~ /^CMP\.W D7,D6$/) has_loop_cmp = 1
    if (uline ~ /^BGE\.[SW] ESQIFF2_READSERIALBYTESTOBUFFER_RETURN$/) has_loop_exit = 1
    if (uline ~ /^JSR ESQFUNC_WAITFORCLOCKCHANGEANDSERVICEUI\(PC\)$/) has_wait = 1
    if (uline ~ /^JSR ESQPARS_JMPTBL_SCRIPT_READSERIALRBFBYTE\(PC\)$/) has_read_byte = 1
    if (uline ~ /^MOVE\.B D0,\(A0\)$/) has_store = 1
    if (uline ~ /^ADDQ\.W #1,D6$/) has_inc = 1
    if (uline ~ /^BRA\.[SW] \.LOOP_READ_SERIAL_BYTE_TO_BUFFER$/) has_back_branch = 1
}

END {
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
}
