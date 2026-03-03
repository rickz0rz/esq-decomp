BEGIN {
    has_entry = 0
    has_select_slot = 0
    has_validate = 0
    has_remaining_update = 0
    has_offset_update = 0
    has_return_label = 0
    has_return_movem = 0
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

    if (uline ~ /^ESQIFF_RENDERWEATHERSTATUSBRUSHSLICE:/) has_entry = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHSLOT/) has_select_slot = 1
    if (uline ~ /ESQIFF_JMPTBL_NEWGRID_VALIDATESELECTIONCODE/) has_validate = 1
    if (uline ~ /^SUB\.W D7,ESQIFF_WEATHERSLICEREMAININGWIDTH$/) has_remaining_update = 1
    if (uline ~ /^ADD\.W D7,ESQIFF_WEATHERSLICESOURCEOFFSET$/) has_offset_update = 1
    if (uline ~ /^ESQIFF_RENDERWEATHERSTATUSBRUSHSLICE_RETURN:/) has_return_label = 1
    if (uline ~ /^MOVEM\.L \(A7\)\+,D2\/D6-D7\/A2-A3$/) has_return_movem = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SELECT_SLOT=" has_select_slot
    print "HAS_VALIDATE=" has_validate
    print "HAS_REMAINING_UPDATE=" has_remaining_update
    print "HAS_OFFSET_UPDATE=" has_offset_update
    print "HAS_RETURN_LABEL=" has_return_label
    print "HAS_RETURN_MOVEM=" has_return_movem
    print "HAS_RTS=" has_rts
}
