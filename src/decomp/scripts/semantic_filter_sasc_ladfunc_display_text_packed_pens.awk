BEGIN {
    has_entry = 0
    has_low_call = 0
    has_setapen_call = 0
    has_high_call = 0
    has_setbpen_call = 0
    has_draw_call = 0
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

    if (u ~ /^LADFUNC_DISPLAYTEXTPACKEDPENS:/ || u ~ /^LADFUNC_DISPLAYTEXTPACKEDPE[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "LADFUNC_GETPACKEDPENLOWNIBBLE") > 0 || index(u, "LADFUNC_GETPACKEDPENLOWNIB") > 0) has_low_call = 1
    if (index(u, "_LVOSETAPEN") > 0) has_setapen_call = 1

    if (index(u, "LADFUNC_GETPACKEDPENHIGHNIBBLE") > 0 || index(u, "LADFUNC_GETPACKEDPENHIGHNIB") > 0) has_high_call = 1
    if (index(u, "_LVOSETBPEN") > 0) has_setbpen_call = 1

    if (index(u, "GROUP_AW_JMPTBL_DISPLIB_DISPLAYTEXTATPOSITION") > 0 || index(u, "GROUP_AW_JMPTBL_DISPLIB_DISPLAYTE") > 0 || index(u, "GROUP_AW_JMPTBL_DISPLIB_DISPLAYT") > 0) has_draw_call = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOW_CALL=" has_low_call
    print "HAS_SETAPEN_CALL=" has_setapen_call
    print "HAS_HIGH_CALL=" has_high_call
    print "HAS_SETBPEN_CALL=" has_setbpen_call
    print "HAS_DRAW_CALL=" has_draw_call
    print "HAS_RETURN=" has_return
}
