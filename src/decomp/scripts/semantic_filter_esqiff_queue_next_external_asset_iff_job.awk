BEGIN {
    has_entry = 0
    has_forbid = 0
    has_permit = 0
    has_read_next = 0
    has_find_sep = 0
    has_find_wild = 0
    has_alloc = 0
    has_start_iff = 0
    has_grid_idle = 0
    has_return = 0
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

    if (uline ~ /^ESQIFF_QUEUENEXTEXTERNALASSETIFFJOB:/) has_entry = 1
    if (uline ~ /_LVOFORBID\(A6\)/) has_forbid = 1
    if (uline ~ /_LVOPERMIT\(A6\)/) has_permit = 1
    if (uline ~ /ESQIFF_READNEXTEXTERNALASSETPATHENTRY/) has_read_next = 1
    if (uline ~ /GCOMMAND_FINDPATHSEPARATOR/) has_find_sep = 1
    if (uline ~ /ESQIFF_JMPTBL_TEXTDISP_FINDENTRYINDEXBYWILDCARD/) has_find_wild = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_ALLOCBRUSHNODE/) has_alloc = 1
    if (uline ~ /ESQIFF_JMPTBL_CTASKS_STARTIFFTASKPROCESS/) has_start_iff = 1
    if (uline ~ /ESQDISP_PROCESSGRIDMESSAGESIFIDLE/) has_grid_idle = 1
    if (uline ~ /^\.RETURN:$/) has_return = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FORBID=" has_forbid
    print "HAS_PERMIT=" has_permit
    print "HAS_READ_NEXT=" has_read_next
    print "HAS_FIND_SEP=" has_find_sep
    print "HAS_FIND_WILD=" has_find_wild
    print "HAS_ALLOC=" has_alloc
    print "HAS_START_IFF=" has_start_iff
    print "HAS_GRID_IDLE=" has_grid_idle
    print "HAS_RETURN_LABEL=" has_return
    print "HAS_RTS=" has_rts
}
