BEGIN {
    has_entry = 0
    has_compare00 = 0
    has_compare11 = 0
    has_fallback_type3 = 0
    has_select_by_label = 0
    has_blt = 0
    has_restore_palette = 0
    has_unlk = 0
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

    if (uline ~ /^ESQFUNC_SELECTANDAPPLYBRUSHFORCURRENTENTRY:/) has_entry = 1
    if (uline ~ /ESQFUNC_TAG_00/) has_compare00 = 1
    if (uline ~ /ESQFUNC_TAG_11/) has_compare11 = 1
    if (uline ~ /ESQFUNC_FALLBACKTYPE3BRUSHNODE/) has_fallback_type3 = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHBYLABEL/) has_select_by_label = 1
    if (uline ~ /LVOBLTBITMAPRASTPORT\(A6\)/) has_blt = 1
    if (uline ~ /WDISP_PALETTETRIPLESRBASE/) has_restore_palette = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_COMPARE00=" has_compare00
    print "HAS_COMPARE11=" has_compare11
    print "HAS_FALLBACK_TYPE3=" has_fallback_type3
    print "HAS_SELECT_BY_LABEL=" has_select_by_label
    print "HAS_BLT=" has_blt
    print "HAS_RESTORE_PALETTE=" has_restore_palette
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
