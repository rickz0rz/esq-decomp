BEGIN {
    has_entry = 0
    has_zero_state = 0
    has_loop_bound = 0
    has_clear_line_ptr = 0
    has_clear_line_len = 0
    has_set_line_pen = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /TARGETLINEINDEX/ || l ~ /CURRENTLINEINDEX/ || l ~ /LINEWIDTHPX/ || l ~ /CONTROLMARKERWIDTHPX/ || l ~ /LINETABLELOCKFLAG/ || l ~ /CONTROLMARKERSENABLEDFLAG/) has_zero_state = 1
    if (l ~ /MOVEQ #20,D0/ || l ~ /CMPI\.L #\$15/ || l ~ /CMP\.L D0,D7/) has_loop_bound = 1
    if (l ~ /LINEPTRTABLE/ && (l ~ /CLR\.L/ || l ~ /MOVE\.L D1,\(A0\)/)) has_clear_line_ptr = 1
    if (l ~ /LINELENGTHTABLE/ && l ~ /CLR\.W/) has_clear_line_len = 1
    if (l ~ /LINEPENTABLE/ && (l ~ /MOVEQ #1,D0/ || l ~ /MOVE\.L D0,\(A0\)/)) has_set_line_pen = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ZERO_STATE=" has_zero_state
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_CLEAR_LINE_PTR=" has_clear_line_ptr
    print "HAS_CLEAR_LINE_LEN=" has_clear_line_len
    print "HAS_SET_LINE_PEN=" has_set_line_pen
}
