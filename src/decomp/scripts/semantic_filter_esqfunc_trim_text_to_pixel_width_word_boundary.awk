BEGIN {
    has_entry = 0
    has_textlen_call = 0
    has_cmp_width = 0
    has_class_table = 0
    has_btst = 0
    has_return_label = 0
    has_restore = 0
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

    if (uline ~ /^ESQFUNC_TRIMTEXTTOPIXELWIDTHWORDBOUNDARY:/) has_entry = 1
    if (uline ~ /LVOTEXTLENGTH\(A6\)/) has_textlen_call = 1
    if (uline ~ /^CMP\.L D7,D0$/) has_cmp_width = 1
    if (uline ~ /WDISP_CHARCLASSTABLE/) has_class_table = 1
    if (uline ~ /^BTST #3,\(A0\)$/) has_btst = 1
    if (uline ~ /^ESQFUNC_TRIMTEXTTOPIXELWIDTHWORDBOUNDARY_RETURN:/) has_return_label = 1
    if (uline ~ /^MOVEM\.L \(A7\)\+,D6-D7\/A2-A3$/) has_restore = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TEXTLEN_CALL=" has_textlen_call
    print "HAS_CMP_WIDTH=" has_cmp_width
    print "HAS_CLASS_TABLE=" has_class_table
    print "HAS_BTST=" has_btst
    print "HAS_RETURN_LABEL=" has_return_label
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
