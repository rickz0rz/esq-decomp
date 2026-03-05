BEGIN {
    has_entry = 0
    has_build_context = 0
    has_setfont = 0
    has_textlength = 0
    has_div = 0
    has_alloc = 0
    has_setdrmd = 0
    has_drop = 0
    has_palette_copy = 0
    has_high_nibble = 0
    has_setrast = 0
    has_row_loop = 0
    has_draw_line = 0
    has_rise = 0
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

    if (u ~ /^LADFUNC_DRAWENTRYPREVIEW:/ || u ~ /^LADFUNC_DRAWENTRYPREVIEW[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "GROUP_AW_JMPTBL_TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE") > 0 || index(u, "GROUP_AW_JMPTBL_TLIBA3_BUILDDISPLAY") > 0 || index(u, "GROUP_AW_JMPTBL_TLIBA3_BUILDDISP") > 0) has_build_context = 1
    if (index(u, "_LVOSETFONT") > 0) has_setfont = 1
    if (index(u, "_LVOTEXTLENGTH") > 0) has_textlength = 1
    if (index(u, "NEWGRID_JMPTBL_MATH_DIVS32") > 0 || index(u, "NEWGRID_JMPTBL_MATH_DIVS") > 0) has_div = 1
    if (index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATE") > 0) has_alloc = 1
    if (index(u, "_LVOSETDRMD") > 0) has_setdrmd = 1
    if (index(u, "GROUP_AW_JMPTBL_ESQIFF_RUNCOPPERDROPTRANSITION") > 0 || index(u, "GROUP_AW_JMPTBL_ESQIFF_RUNCOPPERDR") > 0 || index(u, "GROUP_AW_JMPTBL_ESQIFF_RUNCOPPER") > 0) has_drop = 1
    if (index(u, "KYBD_CUSTOMPALETTETRIPLESRBASE") > 0 || index(u, "WDISP_PALETTETRIPLESRBASE") > 0) has_palette_copy = 1
    if (index(u, "LADFUNC_GETPACKEDPENHIGHNIBBLE") > 0 || index(u, "LADFUNC_GETPACKEDPENHIGHNIB") > 0) has_high_nibble = 1
    if (index(u, "_LVOSETRAST") > 0) has_setrast = 1
    if (index(u, "ED_TEXTLIMIT") > 0 || u ~ /^CMP\.L .*ED_TEXTLIMIT/) has_row_loop = 1
    if (index(u, "LADFUNC_DRAWENTRYLINEWITHATTRS") > 0 || index(u, "LADFUNC_DRAWENTRYLINEWITHAT") > 0) has_draw_line = 1
    if (index(u, "GROUP_AW_JMPTBL_ESQIFF_RUNCOPPERRISETRANSITION") > 0 || index(u, "GROUP_AW_JMPTBL_ESQIFF_RUNCOPPERRI") > 0 || index(u, "GROUP_AW_JMPTBL_ESQIFF_RUNCOPPER") > 0) has_rise = 1
    if (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATE") > 0) has_free = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_BUILD_CONTEXT=" has_build_context
    print "HAS_SETFONT=" has_setfont
    print "HAS_TEXTLENGTH=" has_textlength
    print "HAS_DIV=" has_div
    print "HAS_ALLOC=" has_alloc
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_DROP=" has_drop
    print "HAS_PALETTE_COPY=" has_palette_copy
    print "HAS_HIGH_NIBBLE=" has_high_nibble
    print "HAS_SETRAST=" has_setrast
    print "HAS_ROW_LOOP=" has_row_loop
    print "HAS_DRAW_LINE=" has_draw_line
    print "HAS_RISE=" has_rise
    print "HAS_FREE=" has_free
    print "HAS_RETURN=" has_return
}
