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
    has_return_branch = 0
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

    if (uline ~ /^ESQIFF2_READSERIALRECORDINTOBUFFER:/) has_entry = 1
    if (uline ~ /^LINK\.W A5,#-12$/) has_frame = 1
    if (uline ~ /^CMPI\.W #\$2328,D4$/ || uline ~ /^TST\.W D7$/) has_guard = 1
    if (uline ~ /^JSR ESQFUNC_WAITFORCLOCKCHANGEANDSERVICEUI\(PC\)$/) has_wait = 1
    if (uline ~ /^JSR ESQPARS_JMPTBL_SCRIPT_READSERIALRBFBYTE\(PC\)$/) has_read = 1
    if (uline ~ /^MOVEQ #20,D1$/ || uline ~ /^\.LOOP_COPY_0X14_EXTENSION:$/) has_0x14 = 1
    if (uline ~ /^MOVEQ #18,D1$/ || uline ~ /^\.CHECK_0X12_DELIMITER_CASE:$/) has_0x12 = 1
    if (uline ~ /^CMPI\.W #\$12E,-6\(A5\)$/) has_limit = 1
    if (uline ~ /^MOVE\.B D0,ESQIFF_RECORDCHECKSUMBYTE$/) has_checksum = 1
    if (uline ~ /^BRA\.[SW] ESQIFF2_READSERIALRECORDINTOBUFFER_RETURN$/ || uline ~ /^JMP ESQIFF2_READSERIALRECORDINTOBUFFER_RETURN$/) has_return_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FRAME=" has_frame
    print "HAS_GUARD=" has_guard
    print "HAS_WAIT=" has_wait
    print "HAS_READ=" has_read
    print "HAS_0X14=" has_0x14
    print "HAS_0X12=" has_0x12
    print "HAS_LIMIT=" has_limit
    print "HAS_CHECKSUM=" has_checksum
    print "HAS_RETURN_BRANCH=" has_return_branch
}
