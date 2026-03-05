BEGIN {
    has_entry = 0
    has_base0 = 0
    has_base1 = 0
    has_base2 = 0
    has_2992 = 0
    has_3080 = 0
    has_6072 = 0
    has_reset_offset = 0
    has_snap0 = 0
    has_snap1 = 0
    has_snap2 = 0
    has_reset0 = 0
    has_reset1 = 0
    has_reset2 = 0
    has_sweep0 = 0
    has_sweep1 = 0
    has_sweep2 = 0
    has_call_setbase = 0
    has_rts = 0
    has_scratch_any = 0
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

    if (u ~ /^ESQSHARED4_SETUPBANNERPLANEPOINTERWORDS:/ || u ~ /^ESQSHARED4_SETUPBANNERPLANEPOINT[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "ESQSHARED_BANNERROWSCRATCHRASTERBASE0") > 0 || index(u, "BANNERROWSCRATCHRASTERBASE0") > 0) has_base0 = 1
    if (index(u, "ESQSHARED_BANNERROWSCRATCHRASTERBASE1") > 0 || index(u, "BANNERROWSCRATCHRASTERBASE1") > 0) has_base1 = 1
    if (index(u, "ESQSHARED_BANNERROWSCRATCHRASTERBASE2") > 0 || index(u, "BANNERROWSCRATCHRASTERBASE2") > 0) has_base2 = 1
    if (index(u, "ESQSHARED_BANNERROWSCRATCHRASTER") > 0 || index(u, "BANNERROWSCRATCHRASTER") > 0) has_scratch_any = 1

    if (u ~ /#(\$)?BB0/ || u ~ /#2992/ || u ~ /(^| )2992\(A[0-7]\)/ || u ~ /\$BB0\(A[0-7]\)/) has_2992 = 1
    if (u ~ /#(\$)?C08/ || u ~ /#3080/ || u ~ /(^| )3080\(A[0-7]\)/ || u ~ /\$C08\(A[0-7]\)/) has_3080 = 1
    if (u ~ /#(\$)?17B8/ || u ~ /#6072/ || u ~ /(^| )6072\(A[0-7]\)/ || u ~ /\$17B8\(A[0-7]\)/) has_6072 = 1

    if (index(u, "GCOMMAND_BANNERROWBYTEOFFSETRESETVALUEDEFAULT") > 0 || index(u, "BANNERROWBYTEOFFSETRESETVALUE") > 0 || index(u, "GCOMMAND_BANNERROWBYTEOFFSETRESE") > 0) has_reset_offset = 1

    if (index(u, "ESQ_BANNERSNAPSHOTPLANE0DSTPTRLOWORD") > 0 || index(u, "ESQ_BANNERSNAPSHOTPLANE0DSTPTRHIWORD") > 0 || index(u, "ESQ_BANNERSNAPSHOTPLANE0DSTPTR") > 0 || index(u, "ESQPARS2_BANNERSNAPSHOTPLANE0DST") > 0) has_snap0 = 1
    if (index(u, "ESQ_BANNERSNAPSHOTPLANE1DSTPTRLOWORD") > 0 || index(u, "ESQ_BANNERSNAPSHOTPLANE1DSTPTRHIWORD") > 0 || index(u, "ESQ_BANNERSNAPSHOTPLANE1DSTPTR") > 0 || index(u, "ESQPARS2_BANNERSNAPSHOTPLANE1DST") > 0) has_snap1 = 1
    if (index(u, "ESQ_BANNERSNAPSHOTPLANE2DSTPTRLOWORD") > 0 || index(u, "ESQ_BANNERSNAPSHOTPLANE2DSTPTRHIWORD") > 0 || index(u, "ESQ_BANNERSNAPSHOTPLANE2DSTPTR") > 0 || index(u, "ESQPARS2_BANNERSNAPSHOTPLANE2DST") > 0) has_snap2 = 1

    if (index(u, "ESQ_BANNERPLANE0DSTPTRRESET_LOWORD") > 0 || index(u, "ESQ_BANNERPLANE0DSTPTRRESET_HIWORD") > 0 || index(u, "ESQ_BANNERPLANE0DSTPTRRESET") > 0 || index(u, "ESQPARS2_BANNERROWOFFSETRESETPTRPLANE0") > 0 || index(u, "ESQPARS2_BANNERROWOFFSETRESETPTR") > 0) has_reset0 = 1
    if (index(u, "ESQ_BANNERPLANE1DSTPTRRESET_LOWORD") > 0 || index(u, "ESQ_BANNERPLANE1DSTPTRRESET_HIWORD") > 0 || index(u, "ESQ_BANNERPLANE1DSTPTRRESET") > 0 || index(u, "ESQPARS2_BANNERROWOFFSETRESETPTRPLANE1") > 0) has_reset1 = 1
    if (index(u, "ESQ_BANNERPLANE2DSTPTRRESET_LOWORD") > 0 || index(u, "ESQ_BANNERPLANE2DSTPTRRESET_HIWORD") > 0 || index(u, "ESQ_BANNERPLANE2DSTPTRRESET") > 0 || index(u, "ESQPARS2_BANNERROWOFFSETRESETPTRPLANE2TABLE") > 0 || index(u, "PLANE2TABLE") > 0) has_reset2 = 1

    if (index(u, "ESQ_BANNERSWEEPSRCPLANE0PTR_LOWORD") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE0PTR_HIWORD") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE0PTRRESET_LOWORD") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE0PTRRESET_HIWORD") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE0PTR_") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE0PTRRESET") > 0) has_sweep0 = 1
    if (index(u, "ESQ_BANNERSWEEPSRCPLANE1PTR_LOWORD") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE1PTR_HIWORD") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE1PTRRESET_LOWORD") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE1PTRRESET_HIWORD") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE1PTR_") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE1PTRRESET") > 0) has_sweep1 = 1
    if (index(u, "ESQ_BANNERSWEEPSRCPLANE2PTR_LOWORD") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE2PTR_HIWORD") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE2PTRRESET_LOWORD") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE2PTRRESET_HIWORD") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE2PTR_") > 0 || index(u, "ESQ_BANNERSWEEPSRCPLANE2PTRRESET") > 0) has_sweep2 = 1

    if (index(u, "ESQSHARED4_SETBANNERCOLORBASEANDLIMIT") > 0 || index(u, "SETBANNERCOLORBASEANDLIMIT") > 0 || index(u, "SETBANNERCOLORBASEAND") > 0) has_call_setbase = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (has_scratch_any && has_snap0) has_base0 = 1
    if (has_scratch_any && has_snap1) has_base1 = 1
    if (has_scratch_any && has_snap2) has_base2 = 1

    print "HAS_ENTRY=" has_entry
    print "HAS_BASE0=" has_base0
    print "HAS_BASE1=" has_base1
    print "HAS_BASE2=" has_base2
    print "HAS_2992_CONST=" has_2992
    print "HAS_3080_CONST=" has_3080
    print "HAS_6072_CONST=" has_6072
    print "HAS_RESET_OFFSET=" has_reset_offset
    print "HAS_SNAP0=" has_snap0
    print "HAS_SNAP1=" has_snap1
    print "HAS_SNAP2=" has_snap2
    print "HAS_RESET0=" has_reset0
    print "HAS_RESET1=" has_reset1
    print "HAS_RESET2=" has_reset2
    print "HAS_SWEEP0=" has_sweep0
    print "HAS_SWEEP1=" has_sweep1
    print "HAS_SWEEP2=" has_sweep2
    print "HAS_SETBASE_CALL=" has_call_setbase
    print "HAS_RTS=" has_rts
}
