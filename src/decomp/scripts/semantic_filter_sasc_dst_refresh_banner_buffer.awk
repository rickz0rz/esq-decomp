BEGIN {
    tick = 0
    add = 0
    day = 0
    cur = 0
    phase = 0
    fmt = 0
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

    if (u ~ /DST_TICKBANNERCOUNTERS/) tick = 1
    if (u ~ /DST_ADDTIMEOFFSET/) add = 1
    if (u ~ /CLOCK_DAYSLOTINDEX|CLOCK_DAYSLOTINDE/) day = 1
    if (u ~ /CLOCK_CURRENTDAYOFWEEKINDEX|CLOCK_CURRENTDAYOFWEEKINDE/) cur = 1
    if (u ~ /WDISP_BANNERCHARPHASESHIFT/) phase = 1
    if (u ~ /CLOCK_FORMATVARIANTCODE/) fmt = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_TICK_CALL=" tick
    print "HAS_ADD_OFFSET_CALL=" add
    print "HAS_DAY_SLOT_REF=" day
    print "HAS_CURRENT_SLOT_REF=" cur
    print "HAS_PHASE_SHIFT_REF=" phase
    print "HAS_FORMAT_VARIANT_REF=" fmt
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
