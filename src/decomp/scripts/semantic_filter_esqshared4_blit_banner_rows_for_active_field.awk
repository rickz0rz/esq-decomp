BEGIN {
    has_save = 0
    has_span = 0
    has_stride = 0
    has_select = 0
    has_add58 = 0
    has_list_a = 0
    has_list_b = 0
    has_tail = 0
    has_source = 0
    has_interleave_call = 0
    has_copy_call = 0
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

    if (u ~ /^MOVEM\.L D0\/A0-A1,-\(A7\)$/) has_save = 1
    if (u ~ /ESQPARS2_BANNERROWCOPYSPANBYTES/) has_span = 1
    if (u ~ /ESQPARS2_BANNERROWCOPYSTRIDEBYTES/) has_stride = 1
    if (u ~ /ESQPARS2_ACTIVECOPPERLISTSELECTFLAG/) has_select = 1
    if (u ~ /^ADDI\.[WL] #\$?58,D0$/ || u ~ /^ADDI\.[WL] #88,D0$/) has_add58 = 1
    if (u ~ /ESQ_COPPERLISTBANNERA/) has_list_a = 1
    if (u ~ /ESQ_COPPERLISTBANNERB/) has_list_b = 1
    if (u ~ /ESQPARS2_BANNERCOPYTAILOFFSET/) has_tail = 1
    if (u ~ /ESQPARS2_BANNERCOPYSOURCEOFFSET/) has_source = 1
    if (u ~ /ESQSHARED4_COPYINTERLEAVEDROWWORDSFROMOFFSET/) has_interleave_call = 1
    if (u ~ /ESQSHARED4_COPYBANNERROWSWITHBYTEOFFSET/) has_copy_call = 1
    if (u ~ /^MOVEM\.L \(A7\)\+,D0\/A0-A1$/) has_restore = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SAVE=" has_save
    print "HAS_SPAN=" has_span
    print "HAS_STRIDE=" has_stride
    print "HAS_SELECT=" has_select
    print "HAS_ADD58=" has_add58
    print "HAS_LIST_A=" has_list_a
    print "HAS_LIST_B=" has_list_b
    print "HAS_TAIL=" has_tail
    print "HAS_SOURCE=" has_source
    print "HAS_INTERLEAVE_CALL=" has_interleave_call
    print "HAS_COPY_CALL=" has_copy_call
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
