BEGIN {
    has_entry = 0
    has_62 = 0
    has_base = 0
    has_offset = 0
    has_read_mode = 0
    has_state_index = 0
    has_highlight_countdown = 0
    has_call_snapshot = 0
    has_call_reset = 0
    has_call_setup = 0
    has_ciab = 0
    has_bit7 = 0
    has_bit6 = 0
    has_head_cfg = 0
    has_list_a = 0
    has_list_b = 0
    has_pending = 0
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

    if (uline ~ /^ESQSHARED4_INITIALIZEBANNERCOPPERSYSTEM:/ || uline ~ /^ESQSHARED4_INITIALIZEBANNERCOPPE[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /#(\$)?62/ || uline ~ /#98/) has_62 = 1
    if (index(uline, "ESQPARS2_BANNERSWEEPBASECOLOR") > 0 || index(uline, "ESQPARS2_BANNERSWEEPBASE") > 0) has_base = 1
    if (index(uline, "ESQPARS2_BANNERSWEEPOFFSETCOLOR") > 0 || index(uline, "ESQPARS2_BANNERSWEEPOFFS") > 0) has_offset = 1
    if (index(uline, "ESQPARS2_READMODEFLAGS") > 0 || index(uline, "ESQPARS2_READMODE") > 0) has_read_mode = 1
    if (index(uline, "ESQPARS2_STATEINDEX") > 0 || index(uline, "ESQPARS2_STATEIND") > 0) has_state_index = 1
    if (index(uline, "ESQPARS2_HIGHLIGHTTICKCOUNTDOWN") > 0 || index(uline, "ESQPARS2_HIGHLIGHTTICK") > 0) has_highlight_countdown = 1
    if (index(uline, "ESQSHARED4_SNAPSHOTDISPLAYBUFFERBASES") > 0 || index(uline, "ESQSHARED4_SNAPSHOTDISPLAYBUFFER") > 0 || index(uline, "SNAPSHOTDISPLAYBUFFER") > 0) has_call_snapshot = 1
    if (index(uline, "ESQSHARED4_RESETBANNERCOLORSWEEPSTATE") > 0 || index(uline, "ESQSHARED4_RESETBANNERCOLORSWEEP") > 0 || index(uline, "RESETBANNERCOLORSWEEP") > 0) has_call_reset = 1
    if (index(uline, "ESQSHARED4_SETUPBANNERPLANEPOINTERWORDS") > 0 || index(uline, "ESQSHARED4_SETUPBANNERPLANEPOINT") > 0 || index(uline, "SETUPBANNERPLANEPOINTER") > 0) has_call_setup = 1
    if (index(uline, "CIAB_PRA") > 0) has_ciab = 1
    if (uline ~ /BSET #7/ || uline ~ /#(\$)?80/) has_bit7 = 1
    if (uline ~ /BSET #(\$)?6/ || uline ~ /#(\$)?40/) has_bit6 = 1
    if (index(uline, "CONFIG_BANNERCOPPERHEADBYTE") > 0 || index(uline, "CONFIG_BANNERCOPPERHE") > 0) has_head_cfg = 1
    if (index(uline, "ESQ_COPPERLISTBANNERA") > 0 || index(uline, "ESQ_COPPERLISTBANNER") > 0) has_list_a = 1
    if (index(uline, "ESQ_COPPERLISTBANNERB") > 0 || index(uline, "ESQ_COPPERLISTBANNER") > 0) has_list_b = 1
    if (index(uline, "ESQPARS2_COPPERPROGRAMPENDINGFLAG") > 0 || index(uline, "ESQPARS2_COPPERPROGRAMPENDINGFLA") > 0 || index(uline, "ESQPARS2_COPPERPROGRAMPE") > 0) has_pending = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_62_CONST=" has_62
    print "HAS_BASE_WRITE=" has_base
    print "HAS_OFFSET_WRITE=" has_offset
    print "HAS_READ_MODE=" has_read_mode
    print "HAS_STATE_INDEX=" has_state_index
    print "HAS_HIGHLIGHT_COUNTDOWN=" has_highlight_countdown
    print "HAS_CALL_SNAPSHOT=" has_call_snapshot
    print "HAS_CALL_RESET=" has_call_reset
    print "HAS_CALL_SETUP=" has_call_setup
    print "HAS_CIAB_PRA=" has_ciab
    print "HAS_BIT7_SET=" has_bit7
    print "HAS_BIT6_SET=" has_bit6
    print "HAS_HEAD_CFG_READ=" has_head_cfg
    print "HAS_LIST_A_WRITE=" has_list_a
    print "HAS_LIST_B_WRITE=" has_list_b
    print "HAS_PENDING_WRITE=" has_pending
    print "HAS_RTS=" has_rts
}
