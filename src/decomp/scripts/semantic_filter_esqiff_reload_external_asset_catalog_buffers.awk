BEGIN {
    has_entry = 0
    has_forbid = 0
    has_permit = 0
    has_open = 0
    has_read = 0
    has_close = 0
    has_alloc = 0
    has_dealloc = 0
    has_or_flag1 = 0
    has_or_flag2 = 0
    has_clear_logo = 0
    has_clear_gads = 0
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

    if (uline ~ /^ESQIFF_RELOADEXTERNALASSETCATALOGBUFFERS:/) has_entry = 1
    if (uline ~ /LVOFORBID\(A6\)/) has_forbid = 1
    if (uline ~ /LVOPERMIT\(A6\)/) has_permit = 1
    if (uline ~ /ESQIFF_JMPTBL_DOS_OPENFILEWITHMODE/) has_open = 1
    if (uline ~ /LVOREAD\(A6\)/) has_read = 1
    if (uline ~ /LVOCLOSE\(A6\)/) has_close = 1
    if (uline ~ /ESQIFF_JMPTBL_MEMORY_ALLOCATEMEMORY/) has_alloc = 1
    if (uline ~ /ESQIFF_JMPTBL_MEMORY_DEALLOCATEMEMORY/) has_dealloc = 1
    if (uline ~ /^ORI\.W #1,D0$/) has_or_flag1 = 1
    if (uline ~ /^ORI\.W #2,D0$/) has_or_flag2 = 1
    if (uline ~ /^CLR\.L GLOBAL_REF_LONG_DF0_LOGO_LST_DATA$/) has_clear_logo = 1
    if (uline ~ /^CLR\.L GLOBAL_REF_LONG_GFX_G_ADS_DATA$/) has_clear_gads = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FORBID=" has_forbid
    print "HAS_PERMIT=" has_permit
    print "HAS_OPEN=" has_open
    print "HAS_READ=" has_read
    print "HAS_CLOSE=" has_close
    print "HAS_ALLOC=" has_alloc
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_OR_FLAG1=" has_or_flag1
    print "HAS_OR_FLAG2=" has_or_flag2
    print "HAS_CLEAR_LOGO=" has_clear_logo
    print "HAS_CLEAR_GADS=" has_clear_gads
    print "HAS_RTS=" has_rts
}
