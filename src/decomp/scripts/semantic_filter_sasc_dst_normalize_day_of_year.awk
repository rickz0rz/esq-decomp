BEGIN {
    leap_calls = 0
    d365 = 0
    d366 = 0
    cmp_loop = 0
    sub_year = 0
    has_rts_or_jmp = 0
    boolize = 0
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

    if (u ~ /DATETIME_ISLEAPYEAR/) leap_calls++
    if (u ~ /#\$16D|#365|365\.W/) d365 = 1
    if (u ~ /#366|#\$16E|366\.W/) d366 = 1
    if (u ~ /^SEQ [D][0-7]$|^EXT\.W [D][0-7]$|^EXT\.L [D][0-7]$/) boolize = 1
    if (u ~ /^CMP\.W [DDAA][0-7],[DDAA][0-7]$|^CMP\.L [DDAA][0-7],[DDAA][0-7]$/ || u ~ /^CMP\.W D[0-7],D[0-7]$/ || u ~ /^CMP\.L D[0-7],D[0-7]$/) cmp_loop = 1
    if (u ~ /^SUB\.W [D][0-7],[D][0-7]$|^SUB\.L [D][0-7],[D][0-7]$|^ADDQ\.W #1,[D][0-7]$|^ADDQ\.L #1,[D][0-7]$/) sub_year = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_REPEATED_LEAPYEAR_CALL=" (leap_calls >= 2 ? 1 : 0)
    print "HAS_365_CASE=" ((d365 || boolize) ? 1 : 0)
    print "HAS_366_CASE=" d366
    print "HAS_NORMALIZE_COMPARE_LOOP=" cmp_loop
    print "HAS_SUBTRACT_AND_INCREMENT=" sub_year
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
