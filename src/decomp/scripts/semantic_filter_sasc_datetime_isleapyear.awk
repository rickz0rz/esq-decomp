BEGIN {
    normalize = 0
    d4 = 0
    d100 = 0
    d400 = 0
    saw_64 = 0
    saw_shift2 = 0
    ret0 = 0
    ret1 = 0
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

    if (u ~ /#\$76C/ || u ~ /#1900/) normalize = 1
    if (u ~ /#4([^0-9]|$)|#\$4([^0-9A-F]|$)|[[:space:]]4\.W$/) d4 = 1
    if (u ~ /#100([^0-9]|$)|#\$64([^0-9A-F]|$)|[[:space:]]100\.W$/) {
        d100 = 1
        saw_64 = 1
    }
    if (u ~ /#400([^0-9]|$)|#\$190([^0-9A-F]|$)|[[:space:]]400\.W$/) d400 = 1
    if (u ~ /LSL\.L #\$2,D1|LSL\.L #2,D1/) saw_shift2 = 1

    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^MOVEQ\.L #\$0,D0$/ || u ~ /^CLR\.L D0$/) ret0 = 1
    if (u ~ /^MOVEQ #1,D0$/ || u ~ /^MOVEQ\.L #\$1,D0$/) ret1 = 1

    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    if (!d400 && saw_64 && saw_shift2) d400 = 1
    print "HAS_1900_NORMALIZE=" normalize
    print "HAS_DIV_BY_4_TEST=" d4
    print "HAS_DIV_BY_100_TEST=" d100
    print "HAS_DIV_BY_400_TEST=" d400
    print "HAS_RET_0=" ret0
    print "HAS_RET_1=" ret1
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
