BEGIN {
    has_entry = 0
    has_noop_006a = 0
    has_noop_0074 = 0
    has_dec_primary = 0
    has_inc_targets = 0
    has_lane0_store = 0
    has_lane1_store = 0
    has_lane2_store = 0
    has_lane3_store = 0
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

    if (uline ~ /^ESQIFF_RUNPENDINGCOPPERANIMATIONS:/) has_entry = 1
    if (uline ~ /ESQIFF_JMPTBL_ESQ_NOOP_006A/) has_noop_006a = 1
    if (uline ~ /ESQIFF_JMPTBL_ESQ_NOOP_0074/) has_noop_0074 = 1
    if (uline ~ /ESQIFF_JMPTBL_ESQ_DECCOPPERLISTSPRIMARY/) has_dec_primary = 1
    if (uline ~ /ESQIFF_JMPTBL_ESQ_INCCOPPERLISTSTOWARDSTARGETS/) has_inc_targets = 1
    if (uline ~ /^MOVE\.W D0,COPPER_ANIMATIONLANE0_COUNTDOWN$/) has_lane0_store = 1
    if (uline ~ /^MOVE\.W D0,COPPER_ANIMATIONLANE1_COUNTDOWN$/) has_lane1_store = 1
    if (uline ~ /^MOVE\.W D0,COPPER_ANIMATIONLANE2_COUNTDOWN$/) has_lane2_store = 1
    if (uline ~ /^MOVE\.W D0,COPPER_ANIMATIONLANE3_COUNTDOWN$/) has_lane3_store = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_NOOP_006A=" has_noop_006a
    print "HAS_NOOP_0074=" has_noop_0074
    print "HAS_DEC_PRIMARY=" has_dec_primary
    print "HAS_INC_TARGETS=" has_inc_targets
    print "HAS_LANE0_STORE=" has_lane0_store
    print "HAS_LANE1_STORE=" has_lane1_store
    print "HAS_LANE2_STORE=" has_lane2_store
    print "HAS_LANE3_STORE=" has_lane3_store
    print "HAS_RTS=" has_rts
}
