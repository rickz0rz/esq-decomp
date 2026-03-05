BEGIN {
    has_entry = 0
    has_slot_ref = 0
    has_queue_read = 0
    has_ff_branch = 0
    has_fe_branch = 0
    has_mode_write = 0
    has_queue_clear = 0
    has_countdown_tick = 0
    has_refresh_set = 0
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
    u = toupper(line)

    if (u ~ /^GCOMMAND_CONSUMEBANNERQUEUEENTRY:/) has_entry = 1
    if (index(u, "GCOMMAND_BANNERQUEUESLOTCURRENT") > 0) has_slot_ref = 1
    if (index(u, "ESQPARS2_BANNERQUEUEBUFFER") > 0 && (u ~ /^TST\.B / || u ~ /^MOVE\.B /)) has_queue_read = 1
    if (u ~ /^NOT\.B D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/) has_ff_branch = 1
    if (u ~ /^MOVEQ(\.L)? #127,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$7F,D[0-7]$/ || u ~ /^MOVE\.W #\$101,ESQPARS2_READMODEFLAGS/) has_fe_branch = 1
    if (index(u, "ESQPARS2_READMODEFLAGS") > 0 && (u ~ /^MOVE\.W /)) has_mode_write = 1
    if (index(u, "ESQPARS2_BANNERQUEUEBUFFER") > 0 && (u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/ || u ~ /^CLR\.B / || u ~ /^CLR\.B \$0\(A[0-7],D[0-7]\.[WL]\)$/)) has_queue_clear = 1
    if ((index(u, "ESQPARS2_BANNERQUEUEATTENTIONCOUNTDOWN") > 0 || index(u, "ESQPARS2_BANNERQUEUEATTENTIONCOU") > 0) && (u ~ /^SUBQ\.[WL] #\$1,D[0-7]$/ || u ~ /^SUBQ\.[WL] #1,D[0-7]$/ || u ~ /^MOVE\.W D[0-7],ESQPARS2_BANNERQUEUEATTENTIONCOUNTDOWN/ || u ~ /^MOVE\.W D[0-7],ESQPARS2_BANNERQUEUEATTENTIONCOU/)) has_countdown_tick = 1
    if (index(u, "ESQDISP_STATUSREFRESHPENDINGFLAG") > 0 || index(u, "ESQDISP_STATUSINDICATORDEFERREDAPPLYFLAG") > 0) has_refresh_set = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SLOT_REF=" has_slot_ref
    print "HAS_QUEUE_READ=" has_queue_read
    print "HAS_FF_BRANCH=" has_ff_branch
    print "HAS_FE_BRANCH=" has_fe_branch
    print "HAS_MODE_WRITE=" has_mode_write
    print "HAS_QUEUE_CLEAR=" has_queue_clear
    print "HAS_COUNTDOWN_TICK=" has_countdown_tick
    print "HAS_REFRESH_SET=" has_refresh_set
    print "HAS_RETURN=" has_return
}
