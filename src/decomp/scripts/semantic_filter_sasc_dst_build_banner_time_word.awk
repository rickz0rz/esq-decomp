BEGIN {
    call = 0
    zeroarg = 0
    outword = 0
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

    if (u ~ /DST_BUILDBANNERTIMEENTRY|DST_BUILDBANNERTIMEENTR/) call = 1
    if (u ~ /^CLR\.L -\(A7\)$/ || u ~ /^MOVE\.L #0,-\(A7\)$/ || u ~ /^MOVEQ\.L #\$0,D[0-7]$/ || u ~ /^MOVEQ #0,D[0-7]$/) zeroarg = 1
    if (u ~ /-2\(A5\)|\(.*\),D0|MOVE\.W.*,[D][0-7]/) outword = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_BUILD_ENTRY_CALL=" call
    print "HAS_ZERO_ARG=" zeroarg
    print "HAS_OUTWORD_RETURN=" outword
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
