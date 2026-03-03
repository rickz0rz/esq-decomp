BEGIN {
    has_entry = 0
    saw_target_reset = 0
    saw_current_reset = 0
    has_loop = 0
    saw_lineptr_lea = 0
    saw_ptr_clear = 0
    saw_len_lea = 0
    saw_len_clear = 0
    saw_pen_lea = 0
    saw_pen_set = 0
    has_return = 0
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

    if (uline ~ /^DISPLIB_RESETLINETABLES:/) has_entry = 1
    if (uline ~ /DISPTEXT_TARGETLINEINDEX/) saw_target_reset = 1
    if (uline ~ /DISPTEXT_CURRENTLINEINDEX/) saw_current_reset = 1
    if (uline ~ /^\.LAB_0564:/ || uline ~ /BRA\.S \.LAB_0564/) has_loop = 1
    if (uline ~ /DISPTEXT_LINEPTRTABLE/) saw_lineptr_lea = 1
    if (uline ~ /CLR\.L \(A0\)/) saw_ptr_clear = 1
    if (uline ~ /DISPTEXT_LINELENGTHTABLE/) saw_len_lea = 1
    if (uline ~ /CLR\.W \(A0\)/) saw_len_clear = 1
    if (uline ~ /DISPTEXT_LINEPENTABLE/) saw_pen_lea = 1
    if (uline ~ /MOVE\.L D0,\(A0\)/) saw_pen_set = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    has_state_reset = (saw_target_reset && saw_current_reset) ? 1 : 0
    has_ptr_clear = (saw_lineptr_lea && saw_ptr_clear) ? 1 : 0
    has_len_clear = (saw_len_lea && saw_len_clear) ? 1 : 0
    has_pen_set = (saw_pen_lea && saw_pen_set) ? 1 : 0

    print "HAS_ENTRY=" has_entry
    print "HAS_STATE_RESET=" has_state_reset
    print "HAS_LOOP=" has_loop
    print "HAS_PTR_CLEAR=" has_ptr_clear
    print "HAS_LEN_CLEAR=" has_len_clear
    print "HAS_PEN_SET=" has_pen_set
    print "HAS_RETURN=" has_return
}
