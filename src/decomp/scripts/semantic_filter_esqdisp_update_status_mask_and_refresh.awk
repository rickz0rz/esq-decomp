BEGIN {
    has_entry = 0
    has_push = 0
    has_load_mask = 0
    has_or_path = 0
    has_clear_path = 0
    has_clamp = 0
    has_cmp_prev = 0
    has_call = 0
    has_return_label = 0
    has_pop = 0
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

    if (uline ~ /^ESQDISP_UPDATESTATUSMASKANDREFRESH:/) has_entry = 1
    if (uline ~ /MOVEM\.L D5-D7,-\(A7\)/) has_push = 1
    if (uline ~ /MOVE\.L ESQDISP_STATUSINDICATORMASK,D5/) has_load_mask = 1
    if (uline ~ /OR\.L D7,ESQDISP_STATUSINDICATORMASK/) has_or_path = 1
    if (uline ~ /NOT\.L D0/ && uline ~ /AND\.L D0,ESQDISP_STATUSINDICATORMASK/) has_clear_path = 1
    if (uline ~ /ANDI\.L #\$FFF,ESQDISP_STATUSINDICATORMASK/) has_clamp = 1
    if (uline ~ /CMP\.L D0,D5/) has_cmp_prev = 1
    if (uline ~ /ESQDISP_APPLYSTATUSMASKTOINDICATORS/) has_call = 1
    if (uline ~ /^ESQDISP_UPDATESTATUSMASKANDREFRESH_RETURN:/) has_return_label = 1
    if (uline ~ /MOVEM\.L \(A7\)\+,D5-D7/) has_pop = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PUSH=" has_push
    print "HAS_LOAD_MASK=" has_load_mask
    print "HAS_OR_PATH=" has_or_path
    print "HAS_CLEAR_PATH=" has_clear_path
    print "HAS_CLAMP=" has_clamp
    print "HAS_CMP_PREV=" has_cmp_prev
    print "HAS_CALL=" has_call
    print "HAS_RETURN_LABEL=" has_return_label
    print "HAS_POP=" has_pop
    print "HAS_RTS=" has_rts
}
