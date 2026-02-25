BEGIN {
    has_len_guard = 0
    has_overlap_check = 0
    has_forward_loop = 0
    has_backward_loop = 0
    has_len_decrement = 0
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

    if (u ~ /^(BLE|BLE\.S|JLE|JLE\.S) /) has_len_guard = 1

    if (u ~ /^CMPA\.L .*A0,A1$/ || u ~ /^CMP\.L .*A0,A1$/) has_overlap_check = 1
    if (u ~ /^(BCS|BCS\.S|BLO|BLO\.S|JCS|JCS\.S|JLO|JLO\.S|JLS|JLS\.S|BLS|BLS\.S) /) has_overlap_check = 1

    if (u ~ /^MOVE\.B \(A0\)\+,\(A1\)\+$/ || u ~ /^MOVE\.B \(A1\)\+,\(A0\)\+$/) has_forward_loop = 1
    if (u ~ /^MOVE\.B -\(A0\),-\(A1\)$/ || u ~ /^MOVE\.B -\(A1\),-\(A0\)$/) has_backward_loop = 1

    if (u ~ /^SUBQ\.L #1,D0$/ || u ~ /^SUBQ\.L #1,D[0-7]$/) has_len_decrement = 1
    if (u ~ /^DBRA D[0-7],/) has_len_decrement = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_LEN_GUARD=" has_len_guard
    print "HAS_OVERLAP_CHECK=" has_overlap_check
    print "HAS_FORWARD_LOOP=" has_forward_loop
    print "HAS_BACKWARD_LOOP=" has_backward_loop
    print "HAS_LEN_DECREMENT=" has_len_decrement
    print "HAS_RTS=" has_rts
}
