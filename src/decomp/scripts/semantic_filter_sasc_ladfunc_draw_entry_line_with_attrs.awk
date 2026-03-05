BEGIN {
    has_entry = 0
    has_textlength = 0
    has_div = 0
    has_mul = 0
    has_alloc = 0
    has_prefix_24 = 0
    has_prefix_25 = 0
    has_prefix_26 = 0
    has_display = 0
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
    if (index(u, "NEWGRID_JMPTBL_MATH_DIVS32") > 0 || index(u, "NEWGRID_JMPTBL_MATH_DIVS") > 0) has_div = 1
    if (index(u, "NEWGRID_JMPTBL_MATH_MULU32") > 0 || index(u, "NEWGRID_JMPTBL_MATH_MULU") > 0) has_mul = 1
    if (index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATE") > 0) has_alloc = 1

    if (u ~ /MOVEQ #24,D[0-7]/ || u ~ /CMP\.B #24,/ || u ~ /CMP\.B D[0-7],D[0-7]/) has_prefix_24 = 1
    if (u ~ /MOVEQ #25,D[0-7]/ || u ~ /CMP\.B #25,/ || u ~ /CMP\.B D[0-7],D[0-7]/) has_prefix_25 = 1
    if (u ~ /MOVEQ #26,D[0-7]/ || u ~ /CMP\.B #26,/ || u ~ /CMP\.B D[0-7],D[0-7]/) has_prefix_26 = 1

    if (index(u, "LADFUNC_DISPLAYTEXTPACKEDPENS") > 0 || index(u, "LADFUNC_DISPLAYTEXTPACKEDPE") > 0) has_display = 1
    if (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATE") > 0) has_free = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TEXTLENGTH=" has_textlength
    print "HAS_DIV=" has_div
    print "HAS_MUL=" has_mul
    print "HAS_ALLOC=" has_alloc
    print "HAS_PREFIX_24=" has_prefix_24
    print "HAS_PREFIX_25=" has_prefix_25
    print "HAS_PREFIX_26=" has_prefix_26
    print "HAS_DISPLAY=" has_display
    print "HAS_FREE=" has_free
    print "HAS_RETURN=" has_return
}
