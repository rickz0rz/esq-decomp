BEGIN {
    has_entry = 0
    has_move_a4_save = 0
    has_move_a4_restore = 0
    has_toward_end = 0
    has_toward_start = 0
    has_row0_clr = 0
    has_row1_clr = 0
    has_row2_clr = 0
    has_row3_clr = 0
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

    if (uline ~ /^ESQIFF_SERVICEPENDINGCOPPERPALETTEMOVES:/) has_entry = 1
    if (uline ~ /^MOVE\.L A4,-\(A7\)$/) has_move_a4_save = 1
    if (uline ~ /^MOVEA\.L \(A7\)\+,A4$/) has_move_a4_restore = 1
    if (uline ~ /ESQIFF_JMPTBL_ESQ_MOVECOPPERENTRYTOWARDEND/) has_toward_end = 1
    if (uline ~ /ESQIFF_JMPTBL_ESQ_MOVECOPPERENTRYTOWARDSTART/) has_toward_start = 1
    if (uline ~ /^CLR\.W ACCUMULATOR_ROW0_SATURATEFLAG$/) has_row0_clr = 1
    if (uline ~ /^CLR\.W ACCUMULATOR_ROW1_SATURATEFLAG$/) has_row1_clr = 1
    if (uline ~ /^CLR\.W ACCUMULATOR_ROW2_SATURATEFLAG$/) has_row2_clr = 1
    if (uline ~ /^CLR\.W ACCUMULATOR_ROW3_SATURATEFLAG$/) has_row3_clr = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MOVE_A4_SAVE=" has_move_a4_save
    print "HAS_MOVE_A4_RESTORE=" has_move_a4_restore
    print "HAS_TOWARD_END=" has_toward_end
    print "HAS_TOWARD_START=" has_toward_start
    print "HAS_ROW0_CLR=" has_row0_clr
    print "HAS_ROW1_CLR=" has_row1_clr
    print "HAS_ROW2_CLR=" has_row2_clr
    print "HAS_ROW3_CLR=" has_row3_clr
    print "HAS_RTS=" has_rts
}
