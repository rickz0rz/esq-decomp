BEGIN {
    has_save = 0
    has_source_off = 0
    has_tail_off = 0
    has_blt_off = 0
    has_current_off = 0
    has_word_copy = 0
    has_long_copy = 0
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

    if (u ~ /^MOVEM\.L D0-D1\/A0-A2,-\(A7\)$/) has_save = 1
    if (u ~ /ESQPARS2_BANNERCOPYSOURCEOFFSET/) has_source_off = 1
    if (u ~ /ESQPARS2_BANNERCOPYTAILOFFSET/) has_tail_off = 1
    if (u ~ /ESQSHARED_BLITADDRESSOFFSET/) has_blt_off = 1
    if (u ~ /GCOMMAND_BANNERROWBYTEOFFSETCURRENT/) has_current_off = 1
    if (u ~ /^MOVE\.W \(A2\)\+,\(A1\)\+$/) has_word_copy = 1
    if (u ~ /^MOVE\.L \(A2\)\+,\(A1\)\+$/) has_long_copy = 1
    if (u ~ /^MOVEM\.L \(A7\)\+,D0-D1\/A0-A2$/) has_restore = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SAVE=" has_save
    print "HAS_SOURCE_OFF=" has_source_off
    print "HAS_TAIL_OFF=" has_tail_off
    print "HAS_BLT_OFF=" has_blt_off
    print "HAS_CURRENT_OFF=" has_current_off
    print "HAS_WORD_COPY=" has_word_copy
    print "HAS_LONG_COPY=" has_long_copy
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
