BEGIN {
    has_entry = 0
    has_find_pred = 0
    has_replace_owned = 0
    has_select_slot = 0
    has_trim = 0
    has_text_length = 0
    has_text = 0
    has_move = 0
    has_dealloc = 0
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

    if (uline ~ /^ESQIFF_DRAWWEATHERSTATUSOVERLAYINTOBRUSH:/) has_entry = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_FINDBRUSHBYPREDICATE/) has_find_pred = 1
    if (uline ~ /ESQPARS_REPLACEOWNEDSTRING/) has_replace_owned = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHSLOT/) has_select_slot = 1
    if (uline ~ /ESQFUNC_TRIMTEXTTOPIXELWIDTHWORDBOUNDARY/) has_trim = 1
    if (uline ~ /_LVOTEXTLENGTH\(A6\)/) has_text_length = 1
    if (uline ~ /_LVOTEXT\(A6\)/) has_text = 1
    if (uline ~ /_LVOMOVE\(A6\)/) has_move = 1
    if (uline ~ /ESQIFF_JMPTBL_MEMORY_DEALLOCATEMEMORY/) has_dealloc = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FIND_PRED=" has_find_pred
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_SELECT_SLOT=" has_select_slot
    print "HAS_TRIM=" has_trim
    print "HAS_TEXT_LENGTH=" has_text_length
    print "HAS_TEXT=" has_text
    print "HAS_MOVE=" has_move
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_RTS=" has_rts
}
