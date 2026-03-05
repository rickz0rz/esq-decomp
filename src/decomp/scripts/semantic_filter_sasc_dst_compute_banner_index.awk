BEGIN {
    build_call = 0
    div_call = 0
    c12 = 0
    cmp29 = 0
    c26 = 0
    div48 = 0
    add1 = 0
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

    if (u ~ /DST_BUILDBANNERTIMEENTRY|DST_BUILDBANNERTIMEENTR/) build_call = 1
    if (u ~ /_CXD33|GROUP_AG_JMPTBL_MATH_DIVS32|DATETIME_MODBYDIVS32HELPER/) div_call = 1
    if (u ~ /#12|#\$C|12\.W/) c12 = 1
    if (u ~ /#\$1D|#29|29\.W/) cmp29 = 1
    if (u ~ /#\$26|#38|38\.W/) c26 = 1
    if (u ~ /#\$30|#48|48\.W|DIVS/) div48 = 1
    if (u ~ /^ADDQ\.W #1,D[0-7]$/ || u ~ /^ADDQ\.L #1,D[0-7]$/ || u ~ /^ADDQ\.W #\$1,D[0-7]$/ || u ~ /^ADDQ\.L #\$1,D[0-7]$/) add1 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_BUILD_ENTRY_CALL=" build_call
    print "HAS_MONTH_DIV_CALL=" div_call
    print "HAS_CONST_12=" c12
    print "HAS_DAY_GT_29_TEST=" cmp29
    print "HAS_CONST_26=" c26
    print "HAS_DIV_48_FOLD=" div48
    print "HAS_FINAL_ADD1=" add1
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
