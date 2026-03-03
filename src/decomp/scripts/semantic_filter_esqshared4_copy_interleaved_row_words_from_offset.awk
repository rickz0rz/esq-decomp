BEGIN {
    has_save = 0
    has_base_off = 0
    has_tail_off = 0
    has_copy6 = 0
    has_copy10 = 0
    has_copy14 = 0
    has_restore = 0
    has_rts = 0
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

    if (u ~ /^MOVEM\.L D0\/A0-A2,-\(A7\)$/) has_save = 1
    if (u ~ /ESQSHARED4_INTERLEAVECOPYBASEOFFSET/) has_base_off = 1
    if (u ~ /ESQSHARED4_INTERLEAVECOPYTAILOFFSETCURRENT/) has_tail_off = 1
    if (u ~ /^MOVE\.W 6\(A2\),6\(A1\)$/) has_copy6 = 1
    if (u ~ /^MOVE\.W 10\(A2\),10\(A1\)$/) has_copy10 = 1
    if (u ~ /^MOVE\.W 14\(A2\),14\(A1\)$/) has_copy14 = 1
    if (u ~ /^MOVEM\.L \(A7\)\+,D0\/A0-A2$/) has_restore = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SAVE=" has_save
    print "HAS_BASE_OFF=" has_base_off
    print "HAS_TAIL_OFF=" has_tail_off
    print "HAS_COPY6=" has_copy6
    print "HAS_COPY10=" has_copy10
    print "HAS_COPY14=" has_copy14
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
