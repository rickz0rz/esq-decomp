BEGIN {
    leap = 0
    build = 0
    classify = 0
    sec2struct = 0
    divs = 0
    mulu = 0
    day = 0
    cacheyear = 0
    mode = 0
    pri = 0
    sec = 0
    fmt = 0
    c54 = 0
    c60 = 0
    c89 = 0
    c30 = 0
    c12 = 0
    c24 = 0
    ce10 = 0
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

    if (u ~ /DATETIME_ISLEAPYEAR/) leap = 1
    if (u ~ /DATETIME_BUILDFROMBASEDAY|DATETIME_BUILDFROMBASEDA/) build = 1
    if (u ~ /DATETIME_CLASSIFYVALUEINRANGE|DATETIME_CLASSIFYVALUEINRAN/) classify = 1
    if (u ~ /DATETIME_SECONDSTOSTRUCT/) sec2struct = 1
    if (u ~ /GROUP_AG_JMPTBL_MATH_DIVS32|GROUP_AG_JMPTBL_MATH_DIVS3/) divs = 1
    if (u ~ /GROUP_AG_JMPTBL_MATH_MULU32|GROUP_AG_JMPTBL_MATH_MULU3/) mulu = 1
    if (u ~ /CLOCK_DAYSLOTINDEX|CLOCK_DAYSLOTINDE/) day = 1
    if (u ~ /CLOCK_CACHEYEAR/) cacheyear = 1
    if (u ~ /ESQ_SECONDARYSLOTMODEFLAGCHAR/) mode = 1
    if (u ~ /DST_BANNERWINDOWPRIMARY/) pri = 1
    if (u ~ /DST_BANNERWINDOWSECONDARY/) sec = 1
    if (u ~ /CLOCK_FORMATVARIANTCODE/) fmt = 1
    if (u ~ /#\$36|#54|54\.W/) c54 = 1
    if (u ~ /#\$3C|#60|60\.W|\(\$3C\)\.W|PEA 60\.W/) c60 = 1
    if (u ~ /#\$59|#89|89\.W/) c89 = 1
    if (u ~ /#\$1E|#30|30\.W|\(\$1E\)\.W|PEA 30\.W/) c30 = 1
    if (u ~ /#\$C|#12|12\.W|\(\$C\)\.W|PEA 12\.W/) c12 = 1
    if (u ~ /#\$18|#24|24\.W|\(\$18\)\.W|PEA 24\.W/) c24 = 1
    if (u ~ /#\$E10|#3600|3600\.W|\(\$E10\)\.W|PEA 3600\.W/) ce10 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_LEAP_CALL=" leap
    print "HAS_BUILD_FROM_BASE_DAY_CALL=" build
    print "HAS_CLASSIFY_CALL=" classify
    print "HAS_SECONDS_TO_STRUCT_CALL=" sec2struct
    print "HAS_DIVS_CALL=" divs
    print "HAS_MULU_CALL=" mulu
    print "HAS_DAY_SLOT_REF=" day
    print "HAS_CACHE_YEAR_REF=" cacheyear
    print "HAS_MODE_REF=" mode
    print "HAS_PRIMARY_REF=" pri
    print "HAS_SECONDARY_REF=" sec
    print "HAS_FORMAT_VARIANT_REF=" fmt
    print "HAS_CONST_54=" c54
    print "HAS_CONST_60=" c60
    print "HAS_CONST_89=" c89
    print "HAS_CONST_30=" c30
    print "HAS_CONST_12=" c12
    print "HAS_CONST_24=" c24
    print "HAS_CONST_E10=" ce10
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
