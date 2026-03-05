BEGIN {
    has_global_dst = 0
    has_copy_loop = 0
    has_terminator_store = 0
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

    if (u ~ /WDISP_STATUSLISTMATCHPATTERN/) has_global_dst = 1
    if (u ~ /MOVE.B \(A0\)\+,\(A1\)\+/ || (u ~ /MOVE.B D0,\(A0\)/) || (u ~ /MOVE.B \(A3\)\+,D0/)) has_copy_loop = 1
    if (u ~ /CLR.B/ || u ~ /MOVE.B #0/) has_terminator_store = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_GLOBAL_DST=" has_global_dst
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_TERMINATOR_STORE=" has_terminator_store
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
