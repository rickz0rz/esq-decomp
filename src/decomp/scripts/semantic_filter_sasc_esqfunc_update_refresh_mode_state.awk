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

    if (uline ~ /^ESQFUNC_UPDATEREFRESHMODESTATE:/ || uline ~ /^ESQFUNC_UPDATEREFRESHMODEST[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /^LINK\.W A5,#0$/ || uline ~ /^MOVE\.L \$8\(A7\),D7$/ || uline ~ /^MOVE\.L \$10\(A7\),D6$/) has_link = 1
    if (uline ~ /^MOVE\.W #1,ESQFUNC_WEATHERSLICEWIDTHINITGATE$/ || uline ~ /^MOVE\.W #1,ESQFUNC_WEATHERSLICEWIDTHINIT/ || uline ~ /^MOVE\.W #\$1,ESQFUNC_WEATHERSLICEWIDTHINIT/) has_set_gate = 1
    if (uline ~ /^MOVE\.L D0,NEWGRID_MESSAGEPUMPSUSPENDFLAG$/ || uline ~ /^CLR\.L NEWGRID_MESSAGEPUMPSUSPENDFLAG$/ || uline ~ /^MOVE\.L D0,NEWGRID_MESSAGEPUMPSUSPEND/ || uline ~ /^CLR\.L NEWGRID_MESSAGEPUMPSUSPENDFLAG\(A4\)$/ || uline ~ /^CLR\.L NEWGRID_MESSAGEPUMPSUSPEND/) has_clear_suspend = 1
    if (uline ~ /^MOVE\.W #\$90,ESQPARS2_BANNERROWWIDTHBYTES$/ || uline ~ /^MOVE\.W #\$90,ESQPARS2_BANNERROWWIDTHBY/) has_set_row_width = 1
    if (uline ~ /^MOVE\.W #\$230,ESQPARS2_BANNERCOPYBLOCKSPANBYTES$/ || uline ~ /^MOVE\.W #\$230,ESQPARS2_BANNERCOPYBLOCK/) has_set_copy_span = 1
    if (uline ~ /ESQSHARED4_COMPUTEBANNERROWBLITGEOMETRY/ || uline ~ /ESQSHARED4_COMPUTEBANNERROWBLITGEOM/ || uline ~ /ESQSHARED4_COMPUTEBANNERROWBLITG/) has_geom_call = 1
    if (uline ~ /^MOVE\.L D0,NEWGRID_MODESELECTORSTATE$/ || uline ~ /^CLR\.L NEWGRID_MODESELECTORSTATE$/ || uline ~ /^MOVE\.L D0,NEWGRID_MODESELECTORST/) has_mode_zero = 1
    if (uline ~ /^MOVEQ #2,D0$/ || uline ~ /^MOVEQ\.L #\$2,D0$/) has_mode_two = 1
    if (uline ~ /^CLR\.L NEWGRID_REFRESHSTATEFLAG$/ || uline ~ /^MOVE\.L D0,NEWGRID_REFRESHSTATEFLAG$/ || uline ~ /^MOVE\.L D0,NEWGRID_REFRESHSTATEF/ || uline ~ /^CLR\.L NEWGRID_REFRESHSTATEFLAG\(A4\)$/ || uline ~ /^CLR\.L NEWGRID_REFRESHSTATEF/) has_clear_refresh = 1
    if (uline ~ /^MOVE\.L D7,NEWGRID_LASTREFRESHREQUEST$/ || uline ~ /^MOVE\.L D7,NEWGRID_LASTREFRESHREQ/ || uline ~ /^MOVE\.L D0,NEWGRID_LASTREFRESHREQUEST$/ || uline ~ /^MOVE\.L D0,NEWGRID_LASTREFRESHREQ/ || uline ~ /^MOVE\.L D6,NEWGRID_LASTREFRESHREQUEST\(A4\)$/ || uline ~ /^MOVE\.L D6,NEWGRID_LASTREFRESHREQ/) has_store_last = 1
    if (uline ~ /^UNLK A5$/ || uline ~ /^MOVE\.L \(A7\)\+,D7$/ || uline ~ /^MOVEM\.L \(A7\)\+,D6\/D7$/) has_unlk = 1
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
