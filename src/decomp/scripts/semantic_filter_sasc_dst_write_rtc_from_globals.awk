BEGIN {
    call = 0
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

    if (u ~ /GROUP_AJ_JMPTBL_PARSEINI_WRITERTCFROMGLOBALS|GROUP_AJ_JMPTBL_PARSEINI_WRITERTCFRO|GROUP_AJ_JMPTBL_PARSEINI_WRITERT/) call = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_PARSEINI_RTC_CALL=" call
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
