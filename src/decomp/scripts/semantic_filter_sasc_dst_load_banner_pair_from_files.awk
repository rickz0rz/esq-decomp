BEGIN {
    rebuild = 0
    load = 0
    find_count = 0
    parse_count = 0
    copy_count = 0
    free_call = 0
    update = 0
    g2 = 0
    g3 = 0
    c4 = 0
    c19 = 0
    c889 = 0
    zero_ret = 0
    one_ret = 0
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

    if (u ~ /DST_REBUILDBANNERPAIR|DST_REBUILDBANNERPAI/) rebuild = 1
    if (u ~ /DISKIO_LOADFILETOWORKBUFFER|DISKIO_LOADFILETOWORKBUFFE/) load = 1
    if (u ~ /GROUP_AJ_JMPTBL_STRING_FINDSUBSTRING|GROUP_AJ_JMPTBL_STRING_FINDSUBSTRIN|GROUP_AJ_JMPTBL_STRING_FINDSUBST/) find_count++
    if (u ~ /DATETIME_PARSESTRING|DATETIME_PARSESTRIN/) parse_count++
    if (u ~ /DATETIME_COPYPAIRANDRECALC|DATETIME_COPYPAIRANDRE/) copy_count++
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY|GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) free_call = 1
    if (u ~ /DST_UPDATEBANNERQUEUE|DST_UPDATEBANNERQUEU/) update = 1
    if (u ~ /GLOBAL_STR_G2/) g2 = 1
    if (u ~ /GLOBAL_STR_G3/) g3 = 1
    if (u ~ /#\$4|#4|4\.W|\(\$4\)\.W|PEA 4\.W/) c4 = 1
    if (u ~ /#\$13|#19|19\.W|\(\$13\)\.W|PEA 19\.W/) c19 = 1
    if (u ~ /#\$379|#889|889\.W|\(\$379\)\.W|PEA 889\.W/) c889 = 1
    if (u ~ /^MOVEQ #0,D[0-7]$/ || u ~ /^MOVEQ\.L #\$0,D[0-7]$/) zero_ret = 1
    if (u ~ /^MOVEQ #1,D[0-7]$/ || u ~ /^MOVEQ\.L #\$1,D[0-7]$/) one_ret = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_REBUILD_CALL=" rebuild
    print "HAS_LOAD_CALL=" load
    print "HAS_TWO_FIND_CALLS=" (find_count >= 2 ? 1 : 0)
    print "HAS_PARSE_PATHS=" (parse_count >= 2 ? 1 : 0)
    print "HAS_TWO_COPY_CALLS=" (copy_count >= 2 ? 1 : 0)
    print "HAS_DEALLOCATE_CALL=" free_call
    print "HAS_UPDATE_QUEUE_CALL=" update
    print "HAS_G2_TOKEN=" g2
    print "HAS_G3_TOKEN=" g3
    print "HAS_CONST_4=" c4
    print "HAS_CONST_19=" c19
    print "HAS_CONST_889=" c889
    print "HAS_ZERO_RETURN_PATH=" zero_ret
    print "HAS_ONE_RETURN_PATH=" one_ret
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
