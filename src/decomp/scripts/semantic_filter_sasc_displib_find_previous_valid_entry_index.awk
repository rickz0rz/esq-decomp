BEGIN {
    has_entry = 0
    has_step_select = 0
    has_floor_clamp = 0
    has_slot_probe = 0
    has_decrement = 0
    has_wrap_zero = 0
    has_wrap_flag = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /BTST #5,27\(A3\)/ || l ~ /ANDI\.L #\$20/ || l ~ /#\$30/ || l ~ /#\$7/) has_step_select = 1
    if (l ~ /SUB\.L D[0-7],D[0-7]/ || l ~ /CMP\.L #\$1/ || l ~ /MOVEQ\.L #\$1/) has_floor_clamp = 1
    if (l ~ /TST\.L 56\(A2,D0\.L\)/ || l ~ /56\(A[0-7],D[0-7]\.L\)/ || l ~ /^TST\.L \(A0\)$/) has_slot_probe = 1
    if (l ~ /SUBQ\.L #1,D7/ || l ~ /SUBQ\.L #\$1,D[0-7]/) has_decrement = 1
    if (l ~ /MOVEQ\.L #\$0,D7/ || l ~ /CLR\.W DISPLIB_PREVIOUSSEARCHWRAPPEDFLAG/) has_wrap_zero = 1
    if (l ~ /MOVE\.W #\$1,DISPLIB_PREVIOUSSEARCHWRAPPEDFLAG/ || l ~ /MOVE\.W #1,DISPLIB_PREVIOUSSEARCHWRAPPEDFLAG/ || l ~ /MOVE\.W #\$1,DISPLIB_PREVIOUSSEARCHWRAPPEDFLA/) has_wrap_flag = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_STEP_SELECT=" has_step_select
    print "HAS_FLOOR_CLAMP=" has_floor_clamp
    print "HAS_SLOT_PROBE=" has_slot_probe
    print "HAS_DECREMENT=" has_decrement
    print "HAS_WRAP_ZERO=" has_wrap_zero
    print "HAS_WRAP_FLAG=" has_wrap_flag
}
