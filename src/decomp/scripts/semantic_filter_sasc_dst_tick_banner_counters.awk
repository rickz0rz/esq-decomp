BEGIN {
    src = 0
    sub36 = 0
    phase_w = 0
    pcount = 0
    scount = 0
    dec = 0
    plus = 0
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

    if (u ~ /ESQ_STR_6/) src = 1
    if (u ~ /#\$36|#54|-54|-55/) sub36 = 1
    if (u ~ /WDISP_BANNERCHARPHASESHIFT/) phase_w = 1
    if (u ~ /DST_PRIMARYCOUNTDOWN/) pcount = 1
    if (u ~ /DST_SECONDARYCOUNTDOWN/) scount = 1
    if (u ~ /^SUBQ\.W #1,D[0-7]$/ || u ~ /^SUBQ\.W #\$1,D[0-7]$/ || u ~ /^SUBI\.W #\$36,D[0-7]$/ || u ~ /^ADD\.W #-5[45],D[0-7]$/) dec = 1
    if (u ~ /^ADDQ\.W #1,D[0-7]$/ || u ~ /^ADDQ\.W #\$1,D[0-7]$/) plus = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_SOURCE_CHAR=" src
    print "HAS_SUB_36=" sub36
    print "HAS_PHASE_WRITE=" phase_w
    print "HAS_PRIMARY_CHECK=" pcount
    print "HAS_SECONDARY_CHECK=" scount
    print "HAS_DECREMENT_LOGIC=" dec
    print "HAS_INCREMENT_LOGIC=" plus
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
