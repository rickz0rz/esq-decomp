BEGIN {
    has_entry = 0
    has_save = 0
    has_loop_cmp = 0
    has_loop_exit = 0
    has_wait = 0
    has_read = 0
    has_store = 0
    has_xor = 0
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

    if (uline ~ /^ESQIFF2_READRBFBYTESWITHXOR:/) has_entry = 1
    if (uline ~ /^MOVEM\.L D6-D7\/A2-A3,-\(A7\)$/) has_save = 1
    if (uline ~ /^CMP\.W D7,D6$/) has_loop_cmp = 1
    if (uline ~ /^BGE\.[SW] ESQIFF2_READSERIALBYTESWITHXOR_RETURN$/) has_loop_exit = 1
    if (uline ~ /^JSR ESQFUNC_WAITFORCLOCKCHANGEANDSERVICEUI\(PC\)$/) has_wait = 1
    if (uline ~ /^JSR ESQPARS_JMPTBL_SCRIPT_READSERIALRBFBYTE\(PC\)$/) has_read = 1
    if (uline ~ /^MOVE\.B D0,\(A3\)$/) has_store = 1
    if (uline ~ /^EOR\.B D0,\(A2\)$/) has_xor = 1
    if (uline ~ /^ADDQ\.W #1,D6$/) has_inc = 1
    if (uline ~ /^BRA\.[SW] \.LOOP_READ_SERIAL_BYTE_WITH_XOR$/) has_back_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_LOOP_CMP=" has_loop_cmp
    print "HAS_LOOP_EXIT=" has_loop_exit
    print "HAS_WAIT=" has_wait
    print "HAS_READ=" has_read
    print "HAS_STORE=" has_store
    print "HAS_XOR=" has_xor
    print "HAS_INC=" has_inc
    print "HAS_BACK_BRANCH=" has_back_branch
}
