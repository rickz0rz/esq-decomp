BEGIN {
    has_entry = 0
    has_select_slot = 0
    has_validate = 0
    has_remaining_update = 0
    has_offset_update = 0
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
    nline = uline
    gsub(/[^A-Z0-9]/, "", nline)

    if (nline ~ /^ESQIFFRENDERWEATHERSTATUSBRUSHS/) has_entry = 1
    if (nline ~ /ESQIFFJMPTBLBRUSHSELECTBRUSHS/) has_select_slot = 1
    if (nline ~ /ESQIFFJMPTBLNEWGRIDVALIDATESE/) has_validate = 1
    if (nline ~ /ESQIFFWEATHERSLICEREMAININGWIDT/ && (uline ~ /^SUB/ || uline ~ /^MOVE/)) has_remaining_update = 1
    if (nline ~ /ESQIFFWEATHERSLICESOURCEOFFSET/ && (uline ~ /^ADD/ || uline ~ /^MOVE/)) has_offset_update = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SELECT_SLOT=" has_select_slot
    print "HAS_VALIDATE=" has_validate
    print "HAS_REMAINING_UPDATE=" has_remaining_update
    print "HAS_OFFSET_UPDATE=" has_offset_update
    print "HAS_RTS=" has_rts
}
