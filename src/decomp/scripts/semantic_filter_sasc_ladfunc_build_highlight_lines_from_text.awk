BEGIN {
    has_entry = 0
    has_slot_index = 0
    has_ctrl_table = 0
    has_ptr_table = 0
    has_textlength = 0
    has_padding = 0
    has_prefix_24 = 0
    has_prefix_25 = 0
    has_prefix_26 = 0
    has_set4 = 0
    has_set0 = 0
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
    u = toupper(line)

    if (u ~ /^LADFUNC_BUILDHIGHLIGHTLINESFROMTEXT:/ || u ~ /^LADFUNC_BUILDHIGHLIGHTLINESFR[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "LADFUNC_LINESLOTWRITEINDEX") > 0) has_slot_index = 1
    if (index(u, "LADFUNC_LINECONTROLCODETABLE") > 0) has_ctrl_table = 1
    if (index(u, "LADFUNC_LINETEXTBUFFERPTRS") > 0) has_ptr_table = 1
    if (index(u, "_LVOTEXTLENGTH") > 0) has_textlength = 1
    if (index(u, "GROUP_AW_JMPTBL_DISPLIB_APPLYINLINEALIGNMENTPADDING") > 0 || index(u, "GROUP_AW_JMPTBL_DISPLIB_APPLYINLINEALIGNMENTP") > 0 || index(u, "GROUP_AW_JMPTBL_DISPLIB_APPLYINL") > 0) has_padding = 1

    if (u ~ /#24/ || index(u, "#$18") > 0) has_prefix_24 = 1
    if (u ~ /#25/ || index(u, "#$19") > 0) has_prefix_25 = 1
    if (u ~ /#26/ || index(u, "#$1A") > 0) has_prefix_26 = 1

    if (index(u, "MOVE.W #4,") > 0 || index(u, "MOVE.W #$4,") > 0) has_set4 = 1
    if (u ~ /MOVE\.W D0,\(A[0-7]\)/ || u ~ /CLR\.W \(A[0-7]\)/ || index(u, "CLR.W $0(") > 0) has_set0 = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SLOT_INDEX=" has_slot_index
    print "HAS_CTRL_TABLE=" has_ctrl_table
    print "HAS_PTR_TABLE=" has_ptr_table
    print "HAS_TEXTLENGTH=" has_textlength
    print "HAS_PADDING=" has_padding
    print "HAS_PREFIX_24=" has_prefix_24
    print "HAS_PREFIX_25=" has_prefix_25
    print "HAS_PREFIX_26=" has_prefix_26
    print "HAS_SET4=" has_set4
    print "HAS_SET0=" has_set0
    print "HAS_RETURN=" has_return
}
