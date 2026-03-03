BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_get_ptr = 0
    has_default_copy = 0
    has_charclass = 0
    has_parse_hex = 0
    has_store_primary = 0
    has_store_secondary = 0
    has_restore = 0
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

    if (uline ~ /^CLEANUP_UPDATEENTRYFLAGBYTES:/) has_label = 1
    if (uline ~ /LINK.W A5,#-16/) has_link = 1
    if (uline ~ /MOVEM.L D7\/A3,-\(A7\)/) has_save = 1
    if (uline ~ /COI_GETANIMFIELDPOINTERBYMODE/) has_get_ptr = 1
    if (uline ~ /\.COPY_DEFAULT_ENTRY_LOOP:/) has_default_copy = 1
    if (uline ~ /WDISP_CHARCLASSTABLE/) has_charclass = 1
    if (uline ~ /GROUP_AE_JMPTBL_LADFUNC_PARSEHEXDIGIT/) has_parse_hex = 1
    if (uline ~ /MOVE.B D1,DISPTEXT_INSETNIBBLEPRIMARY/) has_store_primary = 1
    if (uline ~ /MOVE.B D1,DISPTEXT_INSETNIBBLESECONDARY/) has_store_secondary = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D7\/A3/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_GET_PTR=" has_get_ptr
    print "HAS_DEFAULT_COPY=" has_default_copy
    print "HAS_CHARCLASS=" has_charclass
    print "HAS_PARSE_HEX=" has_parse_hex
    print "HAS_STORE_PRIMARY=" has_store_primary
    print "HAS_STORE_SECONDARY=" has_store_secondary
    print "HAS_RESTORE=" has_restore
}
