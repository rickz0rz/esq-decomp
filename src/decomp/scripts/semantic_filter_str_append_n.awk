BEGIN {
    has_src_scan = 0
    has_dst_scan = 0
    has_bound_min = 0
    has_copy_loop = 0
    has_nul_term = 0
    has_return_dst = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^TST\.B \(A[0-7]\)\+$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_src_scan = 1
    if (u ~ /FIND_END_SRC|\.L[0-9]+:/) {
        # no-op marker; rely on instruction matches
    }

    if (u ~ /^TST\.B \(A[0-7]\)\+$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_dst_scan = 1

    if (u ~ /^CMP\.L .*,[AD][0-7]$/ || u ~ /^CMPA?\.L .*,[AD][0-7]$/ || u ~ /^BLS(\.S)? / || u ~ /^BHI(\.S)? / || u ~ /^JLS / || u ~ /^JHI / || u ~ /^JCC / || u ~ /^BCC(\.S)? /) {
        has_bound_min = 1
    }

    if (u ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/ || u ~ /^MOVE\.B .*0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVE\.B .*0\(A[0-7],D[0-7]\)$/) has_copy_loop = 1
    if (u ~ /^SUBQ\.L #1,D[0-7]$/ || u ~ /^DBRA D[0-7],/) has_copy_loop = 1

    if (u ~ /^CLR\.B .*$/ || u ~ /^MOVE\.B #0,.*$/) has_nul_term = 1

    if (u ~ /^MOVE\.L A[0-7],D0$/ || u ~ /^MOVE\.L .*D0$/) has_return_dst = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SRC_SCAN=" has_src_scan
    print "HAS_DST_SCAN=" has_dst_scan
    print "HAS_BOUND_MIN=" has_bound_min
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_NUL_TERM=" has_nul_term
    print "HAS_RETURN_DST=" has_return_dst
    print "HAS_RTS=" has_rts
}
