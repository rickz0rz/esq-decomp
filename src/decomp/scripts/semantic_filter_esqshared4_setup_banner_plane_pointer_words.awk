BEGIN {
    has_save = 0
    has_base0 = 0
    has_base1 = 0
    has_base2 = 0
    has_snap0 = 0
    has_snap1 = 0
    has_snap2 = 0
    has_sweep0 = 0
    has_sweep1 = 0
    has_sweep2 = 0
    has_setbase_call = 0
    has_restore = 0
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

    if (u ~ /^MOVEM\.L D0-D1\/A0-A4,-\(A7\)$/) has_save = 1
    if (u ~ /ESQSHARED_BANNERROWSCRATCHRASTERBASE0/) has_base0 = 1
    if (u ~ /ESQSHARED_BANNERROWSCRATCHRASTERBASE1/) has_base1 = 1
    if (u ~ /ESQSHARED_BANNERROWSCRATCHRASTERBASE2/) has_base2 = 1
    if (u ~ /ESQ_BANNERSNAPSHOTPLANE0DSTPTRLOWORD/ || u ~ /ESQ_BANNERSNAPSHOTPLANE0DSTPTRHIWORD/) has_snap0 = 1
    if (u ~ /ESQ_BANNERSNAPSHOTPLANE1DSTPTRLOWORD/ || u ~ /ESQ_BANNERSNAPSHOTPLANE1DSTPTRHIWORD/) has_snap1 = 1
    if (u ~ /ESQ_BANNERSNAPSHOTPLANE2DSTPTRLOWORD/ || u ~ /ESQ_BANNERSNAPSHOTPLANE2DSTPTRHIWORD/) has_snap2 = 1
    if (u ~ /ESQ_BANNERSWEEPSRCPLANE0PTR_LOWORD/ || u ~ /ESQ_BANNERSWEEPSRCPLANE0PTR_HIWORD/) has_sweep0 = 1
    if (u ~ /ESQ_BANNERSWEEPSRCPLANE1PTR_LOWORD/ || u ~ /ESQ_BANNERSWEEPSRCPLANE1PTR_HIWORD/) has_sweep1 = 1
    if (u ~ /ESQ_BANNERSWEEPSRCPLANE2PTR_LOWORD/ || u ~ /ESQ_BANNERSWEEPSRCPLANE2PTR_HIWORD/) has_sweep2 = 1
    if (u ~ /ESQSHARED4_SETBANNERCOLORBASEANDLIMIT/) has_setbase_call = 1
    if (u ~ /^MOVEM\.L \(A7\)\+,D0-D1\/A0-A4$/) has_restore = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SAVE=" has_save
    print "HAS_BASE0=" has_base0
    print "HAS_BASE1=" has_base1
    print "HAS_BASE2=" has_base2
    print "HAS_SNAP0=" has_snap0
    print "HAS_SNAP1=" has_snap1
    print "HAS_SNAP2=" has_snap2
    print "HAS_SWEEP0=" has_sweep0
    print "HAS_SWEEP1=" has_sweep1
    print "HAS_SWEEP2=" has_sweep2
    print "HAS_SETBASE_CALL=" has_setbase_call
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
