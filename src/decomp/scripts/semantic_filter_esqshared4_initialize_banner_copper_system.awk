BEGIN {
    has_base = 0
    has_offset = 0
    has_read_mode = 0
    has_state = 0
    has_tick = 0
    has_snapshot_call = 0
    has_reset_call = 0
    has_setup_call = 0
    has_ciab = 0
    has_banner_a = 0
    has_banner_b = 0
    has_pending = 0
    has_rts = 0
}

function trim(s,    t) {
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
    u = toupper(line)

    if (u ~ /ESQPARS2_BANNERSWEEPBASECOLOR/) has_base = 1
    if (u ~ /ESQPARS2_BANNERSWEEPOFFSETCOLOR/) has_offset = 1
    if (u ~ /ESQPARS2_READMODEFLAGS/) has_read_mode = 1
    if (u ~ /ESQPARS2_STATEINDEX/) has_state = 1
    if (u ~ /ESQPARS2_HIGHLIGHTTICKCOUNTDOWN/) has_tick = 1

    if (u ~ /ESQSHARED4_SNAPSHOTDISPLAYBUFFERBASES/) has_snapshot_call = 1
    if (u ~ /ESQSHARED4_RESETBANNERCOLORSWEEPSTATE/) has_reset_call = 1
    if (u ~ /ESQSHARED4_SETUPBANNERPLANEPOINTERWORDS/) has_setup_call = 1

    if (u ~ /CIAB_PRA/) has_ciab = 1
    if (u ~ /ESQ_COPPERLISTBANNERA/) has_banner_a = 1
    if (u ~ /ESQ_COPPERLISTBANNERB/) has_banner_b = 1
    if (u ~ /ESQPARS2_COPPERPROGRAMPENDINGFLAG/) has_pending = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_BASE=" has_base
    print "HAS_OFFSET=" has_offset
    print "HAS_READ_MODE=" has_read_mode
    print "HAS_STATE=" has_state
    print "HAS_TICK=" has_tick
    print "HAS_SNAPSHOT_CALL=" has_snapshot_call
    print "HAS_RESET_CALL=" has_reset_call
    print "HAS_SETUP_CALL=" has_setup_call
    print "HAS_CIAB=" has_ciab
    print "HAS_BANNER_A=" has_banner_a
    print "HAS_BANNER_B=" has_banner_b
    print "HAS_PENDING=" has_pending
    print "HAS_RTS=" has_rts
}
