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

    if (uline ~ /^ESQIFF2_READSERIALSIZEDTEXTRECORD:/) has_entry = 1
    if (uline ~ /^LINK\.W A5,#-4$/ && uline !~ /^;/) has_frame = 1
    if (uline ~ /^TST\.L D7$/ || uline ~ /^CMPI\.L #\$2328,D7$/) has_size_guard = 1
    if (uline ~ /^\.LOOP_READ_INITIAL_PAYLOAD:$/ || uline ~ /^MOVE\.B D0,0\(A3,D1\.L\)$/) has_initial_loop = 1
    if (uline ~ /^JSR ESQPARS_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3_ALT\(PC\)$/) has_trailer_parse = 1
    if (uline ~ /^\.LOOP_READ_TRAILER_BYTES:$/ || uline ~ /^CMP\.L D5,D6$/) has_trailer_loop = 1
    if (uline ~ /^\.FAIL_TRAILER_VALIDATION:$/ || uline ~ /^CLR\.B \(A3\)$/) has_fail_path = 1
    if (uline ~ /^MOVE\.B D0,ESQIFF_RECORDCHECKSUMBYTE$/) has_checksum = 1
    if (uline ~ /^\.FINISH_SIZED_RECORD_READ:$/ || uline ~ /^MOVE\.L D4,D0$/) has_finish = 1
    if (uline ~ /^BRA\.[SW] ESQIFF2_READSERIALSIZEDTEXTRECORD_RETURN$/ || uline ~ /^JMP ESQIFF2_READSERIALSIZEDTEXTRECORD_RETURN$/) has_return_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FRAME=" has_frame
    print "HAS_SIZE_GUARD=" has_size_guard
    print "HAS_INITIAL_LOOP=" has_initial_loop
    print "HAS_TRAILER_PARSE=" has_trailer_parse
    print "HAS_TRAILER_LOOP=" has_trailer_loop
    print "HAS_FAIL_PATH=" has_fail_path
    print "HAS_CHECKSUM=" has_checksum
    print "HAS_FINISH=" has_finish
    print "HAS_RETURN_BRANCH=" has_return_branch
}
