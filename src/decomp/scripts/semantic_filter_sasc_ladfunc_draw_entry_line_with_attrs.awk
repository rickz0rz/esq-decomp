BEGIN {
    has_entry = 0
    has_textlength = 0
    div_count = 0
    mul_count = 0
    round_count = 0
    has_alloc = 0
    has_prefix_24 = 0
    has_prefix_25 = 0
    has_prefix_26 = 0
    display_count = 0
    has_bitmap_rows = 0
    has_font_height = 0
    has_ed_textlimit = 0
    has_free = 0
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

    if (u ~ /^LADFUNC_DRAWENTRYLINEWITHATTRS:/ || u ~ /^LADFUNC_DRAWENTRYLINEWITHAT[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "_LVOTEXTLENGTH") > 0) has_textlength = 1
    if (u ~ /^(JSR|BSR(\.[A-Z])?) .*NEWGRID_JMPTBL_MATH_DIVS32/ || u ~ /^(JSR|BSR(\.[A-Z])?) .*NEWGRID_JMPTBL_MATH_DIVS/) div_count++
    if (u ~ /^(JSR|BSR(\.[A-Z])?) .*NEWGRID_JMPTBL_MATH_MULU32/ || u ~ /^(JSR|BSR(\.[A-Z])?) .*NEWGRID_JMPTBL_MATH_MULU/) mul_count++
    if (index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATE") > 0) has_alloc = 1

    if (u ~ /#(24|\$18)\b/) has_prefix_24 = 1
    if (u ~ /#(25|\$19)\b/) has_prefix_25 = 1
    if (u ~ /#(26|\$1A)\b/) has_prefix_26 = 1

    if (u ~ /^(JSR|BSR(\.[A-Z])?) .*LADFUNC_DISPLAYTEXTPACKEDPENS/ || u ~ /^(JSR|BSR(\.[A-Z])?) .*LADFUNC_DISPLAYTEXTPACKEDPE/) display_count++
    if (u ~ /ASR\.L #1,/ || index(u, "ASR1_ROUND_TOWARD_ZERO") > 0) round_count++
    if (u ~ /MOVE\.W (2\(A0\)|\$2\(A0\)),D[0-7]/) has_bitmap_rows = 1
    if (u ~ /MOVE\.W (20\(A1\)|\$14\(A0\)),D[0-7]/) has_font_height = 1
    if (index(u, "ED_TEXTLIMIT") > 0) has_ed_textlimit = 1
    if (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATE") > 0) has_free = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TEXTLENGTH=" has_textlength
    print "HAS_DIV_FLOW=" (div_count >= 3)
    print "HAS_MUL_FLOW=" (mul_count >= 5)
    print "HAS_ROUND_FLOW=" (round_count >= 2)
    print "HAS_ALLOC=" has_alloc
    print "HAS_PREFIX_24=" has_prefix_24
    print "HAS_PREFIX_25=" has_prefix_25
    print "HAS_PREFIX_26=" has_prefix_26
    print "HAS_BITMAP_ROWS=" has_bitmap_rows
    print "HAS_FONT_HEIGHT=" has_font_height
    print "HAS_ED_TEXTLIMIT=" has_ed_textlimit
    print "HAS_DISPLAY_FLOW=" (display_count >= 3)
    print "HAS_FREE=" has_free
    print "HAS_RETURN=" has_return
}
