BEGIN {
    parse_count = 0
    copy_count = 0
    update = 0
    c32 = 0
    c33 = 0
    c4 = 0
    c19 = 0
    pri = 0
    sec = 0
    has_rts_or_jmp = 0
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

    if (u ~ /DATETIME_PARSESTRING|DATETIME_PARSESTRIN/) parse_count++
    if (u ~ /DATETIME_COPYPAIRANDRECALC|DATETIME_COPYPAIRANDRE/) copy_count++
    if (u ~ /DST_UPDATEBANNERQUEUE|DST_UPDATEBANNERQUEU/) update = 1
    if (u ~ /#\$32|#50|50\.W/) c32 = 1
    if (u ~ /#\$33|#51|51\.W/ || u ~ /^SUBQ\.[WL] #1,D[0-7]$/ || u ~ /^SUBQ\.[WL] #\$1,D[0-7]$/) c33 = 1
    if (u ~ /#\$4|#4|4\.W/) c4 = 1
    if (u ~ /#\$13|#19|19\.W|\(\$13\)\.W|PEA 19\.W/) c19 = 1
    if (u ~ /DST_BANNERWINDOWPRIMARY/) pri = 1
    if (u ~ /DST_BANNERWINDOWSECONDARY/) sec = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_PARSE_CALLS=" (parse_count >= 2 ? 1 : 0)
    print "HAS_COPY_CALLS=" (copy_count >= 1 ? 1 : 0)
    print "HAS_UPDATE_CALL=" update
    print "HAS_CMD_32=" c32
    print "HAS_CMD_33=" c33
    print "HAS_CONST_4=" c4
    print "HAS_CONST_19=" c19
    print "HAS_PRIMARY_REF=" pri
    print "HAS_SECONDARY_REF=" sec
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
