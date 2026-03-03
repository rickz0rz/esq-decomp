BEGIN {
    has_entry = 0
    has_save = 0
    has_null_guard = 0
    has_writes = 0
    has_copy = 0
    has_clear = 0
    has_return_label = 0
    has_restore = 0
    has_rts = 0
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

    if (uline ~ /^ESQDISP_FILLPROGRAMINFOHEADERFIELDS:/) has_entry = 1
    if (uline ~ /MOVEM\.L D4-D7\/A2-A3,-\(A7\)/) has_save = 1
    if (uline ~ /MOVE\.L A3,D0/ && uline ~ /BEQ(\.[A-Z]+)? ESQDISP_FILLPROGRAMINFOHEADERFIELDS_RETURN/) has_null_guard = 1
    if (uline ~ /MOVE\.B D7,40\(A3\)/ && uline ~ /MOVE\.W D6,46\(A3\)/) has_writes = 1
    if (uline ~ /ESQFUNC_JMPTBL_STRING_COPYPADNUL/) has_copy = 1
    if (uline ~ /CLR\.B 45\(A3\)/) has_clear = 1
    if (uline ~ /^ESQDISP_FILLPROGRAMINFOHEADERFIELDS_RETURN:/) has_return_label = 1
    if (uline ~ /MOVEM\.L \(A7\)\+,D4-D7\/A2-A3/) has_restore = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_WRITES=" has_writes
    print "HAS_COPY=" has_copy
    print "HAS_CLEAR=" has_clear
    print "HAS_RETURN_LABEL=" has_return_label
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
