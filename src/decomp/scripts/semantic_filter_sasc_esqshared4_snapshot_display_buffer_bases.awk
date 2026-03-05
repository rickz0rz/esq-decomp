BEGIN {
    has_entry = 0
    has_live0 = 0
    has_live1 = 0
    has_live2 = 0
    has_snap0 = 0
    has_snap1 = 0
    has_snap2 = 0
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

    if (uline ~ /^ESQSHARED4_SNAPSHOTDISPLAYBUFFERBASES:/ || uline ~ /^ESQSHARED4_SNAPSHOTDISPLAYBUFFER[A-Z0-9_]*:/) has_entry = 1
    if (index(uline, "ESQSHARED_LIVEPLANEBASE0") > 0 || index(uline, "ESQSHARED_LIVEPLANEBA") > 0) has_live0 = 1
    if (index(uline, "ESQSHARED_LIVEPLANEBASE1") > 0 || index(uline, "ESQSHARED_LIVEPLANEBA") > 0) has_live1 = 1
    if (index(uline, "ESQSHARED_LIVEPLANEBASE2") > 0 || index(uline, "ESQSHARED_LIVEPLANEBA") > 0) has_live2 = 1
    if (index(uline, "ESQPARS2_SNAPSHOTLIVEPLANE0BASE") > 0 || index(uline, "ESQPARS2_SNAPSHOTLIVEPLANE") > 0) has_snap0 = 1
    if (index(uline, "ESQPARS2_SNAPSHOTLIVEPLANE1BASE") > 0 || index(uline, "ESQPARS2_SNAPSHOTLIVEPLANE") > 0) has_snap1 = 1
    if (index(uline, "ESQPARS2_SNAPSHOTLIVEPLANE2BASE") > 0 || index(uline, "ESQPARS2_SNAPSHOTLIVEPLANE") > 0) has_snap2 = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LIVE0=" has_live0
    print "HAS_LIVE1=" has_live1
    print "HAS_LIVE2=" has_live2
    print "HAS_SNAP0=" has_snap0
    print "HAS_SNAP1=" has_snap1
    print "HAS_SNAP2=" has_snap2
    print "HAS_RTS=" has_rts
}
