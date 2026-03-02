BEGIN {
    has_target_dispatch = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /DISKIOCLOSEBUFFEREDFILEANDFLUSH/) has_target_dispatch = 1
    if (u ~ /^JMP / || u ~ /^RTS$/ || u ~ /^JSR / || u ~ /^JBSR /) has_rts_or_jmp = 1
}

END {
    print "HAS_TARGET_DISPATCH=" has_target_dispatch
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
