BEGIN {
    has_entry = 0
    has_div = 0
    has_draw = 0
    has_counter = 0
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

    if (u ~ /^TEXTDISP_DRAWNEXTENTRYPREVIEW:/ || u ~ /^TEXTDISP_DRAWNEXTENTRYPRE[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "MATH_DIVS32") > 0) has_div = 1
    if (index(u, "TEXTDISP2_JMPTBL_LADFUNC_DRAWENTRYPREVIEW") > 0 ||
        index(u, "TEXTDISP2_JMPTBL_LADFUNC_DRAWENTRYP") > 0 ||
        index(u, "TEXTDISP2_JMPTBL_LADFUNC_DRAWENT") > 0 ||
        index(u, "LADFUNC_DRAWENTRYPREVIEW") > 0 ||
        index(u, "LADFUNC_DRAWENTRYP") > 0 ||
        index(u, "LADFUNC_DRAWENT") > 0) has_draw = 1
    if (index(u, "LADFUNC_ENTRYCOUNT") > 0) has_counter = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DIV=" has_div
    print "HAS_DRAW=" has_draw
    print "HAS_COUNTER=" has_counter
    print "HAS_RETURN=" has_return
}
