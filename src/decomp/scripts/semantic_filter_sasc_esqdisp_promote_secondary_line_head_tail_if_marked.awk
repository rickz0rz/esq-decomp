BEGIN {
    has_entry = 0
    has_flag_check = 0
    has_clear_call = 0
    has_move_head = 0
    has_move_tail = 0
    has_clear_secondary = 0
    has_clear_flag = 0
    has_return = 0
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

    if (uline ~ /^ESQDISP_PROMOTESECONDARYLINEHEADTAILIFMARKED:/ || uline ~ /^ESQDISP_PROMOTESECONDARYLINEHE[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /ESQDISP_SECONDARYLINEPROMOTEPENDINGFLAG/ || uline ~ /ESQDISP_SECONDARYLINEPROMOTEPEND/) has_flag_check = 1
    if (uline ~ /ESQIFF2_CLEARLINEHEADTAILBYMODE/ || uline ~ /ESQIFF2_CLEARLINEHEADTAILBYMO/) has_clear_call = 1
    if (uline ~ /ESQIFF_SECONDARYLINEHEADPTR,ESQIFF_PRIMARYLINEHEADPTR/ || uline ~ /ESQIFF_SECONDARYLINEHEADPTR/ && uline ~ /ESQIFF_PRIMARYLINEHEADPTR/) has_move_head = 1
    if (uline ~ /ESQIFF_SECONDARYLINETAILPTR,ESQIFF_PRIMARYLINETAILPTR/ || uline ~ /ESQIFF_SECONDARYLINETAILPTR/ && uline ~ /ESQIFF_PRIMARYLINETAILPTR/) has_move_tail = 1
    if ((uline ~ /CLR\.L ESQIFF_SECONDARYLINEHEADPTR/ || uline ~ /CLR\.L ESQIFF_SECONDARYLINETAILPTR/) || ((uline ~ /ESQIFF_SECONDARYLINEHEADPTR/ || uline ~ /ESQIFF_SECONDARYLINETAILPTR/) && uline ~ /#0/) || uline ~ /SUBA\.L A0,A0/) has_clear_secondary = 1
    if (uline ~ /CLR\.W ESQDISP_SECONDARYLINEPROMOTEPENDINGFLAG/ || uline ~ /CLR\.L ESQDISP_SECONDARYLINEPROMOTEPENDINGFLAG/ || uline ~ /CLR\.W ESQDISP_SECONDARYLINEPROMOTEPEND/ || uline ~ /CLR\.L ESQDISP_SECONDARYLINEPROMOTEPEND/ || (uline ~ /ESQDISP_SECONDARYLINEPROMOTEPENDINGFLAG/ && uline ~ /#0/)) has_clear_flag = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FLAG_CHECK=" has_flag_check
    print "HAS_CLEAR_CALL=" has_clear_call
    print "HAS_MOVE_HEAD=" has_move_head
    print "HAS_MOVE_TAIL=" has_move_tail
    print "HAS_CLEAR_SECONDARY=" has_clear_secondary
    print "HAS_CLEAR_FLAG=" has_clear_flag
    print "HAS_RETURN=" has_return
}
