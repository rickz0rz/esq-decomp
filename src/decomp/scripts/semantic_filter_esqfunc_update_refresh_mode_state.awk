BEGIN {
    has_entry = 0
    has_link = 0
    has_set_gate = 0
    has_clear_suspend = 0
    has_set_row_width = 0
    has_set_copy_span = 0
    has_geom_call = 0
    has_mode_zero = 0
    has_mode_two = 0
    has_clear_refresh = 0
    has_store_last = 0
    has_unlk = 0
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

    if (uline ~ /^ESQFUNC_UPDATEREFRESHMODESTATE:/) has_entry = 1
    if (uline ~ /^LINK\.W A5,#0$/) has_link = 1
    if (uline ~ /^MOVE\.W #1,ESQFUNC_WEATHERSLICEWIDTHINITGATE$/) has_set_gate = 1
    if (uline ~ /^MOVE\.L D0,NEWGRID_MESSAGEPUMPSUSPENDFLAG$/) has_clear_suspend = 1
    if (uline ~ /^MOVE\.W #\$90,ESQPARS2_BANNERROWWIDTHBYTES$/) has_set_row_width = 1
    if (uline ~ /^MOVE\.W #\$230,ESQPARS2_BANNERCOPYBLOCKSPANBYTES$/) has_set_copy_span = 1
    if (uline ~ /ESQSHARED4_COMPUTEBANNERROWBLITGEOMETRY/) has_geom_call = 1
    if (uline ~ /^MOVE\.L D0,NEWGRID_MODESELECTORSTATE$/ && uline ~ /#0/) has_mode_zero = 1
    if (uline ~ /^MOVEQ #2,D0$/) has_mode_two = 1
    if (uline ~ /^CLR\.L NEWGRID_REFRESHSTATEFLAG$/) has_clear_refresh = 1
    if (uline ~ /^MOVE\.L D7,NEWGRID_LASTREFRESHREQUEST$/) has_store_last = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_SET_GATE=" has_set_gate
    print "HAS_CLEAR_SUSPEND=" has_clear_suspend
    print "HAS_SET_ROW_WIDTH=" has_set_row_width
    print "HAS_SET_COPY_SPAN=" has_set_copy_span
    print "HAS_GEOM_CALL=" has_geom_call
    print "HAS_MODE_ZERO=" has_mode_zero
    print "HAS_MODE_TWO=" has_mode_two
    print "HAS_CLEAR_REFRESH=" has_clear_refresh
    print "HAS_STORE_LAST=" has_store_last
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
