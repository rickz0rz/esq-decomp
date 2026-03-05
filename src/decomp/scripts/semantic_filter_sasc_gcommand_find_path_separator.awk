BEGIN {
    has_entry = 0
    has_scan_loop = 0
    has_distance = 0
    has_sep_cmp = 0
    has_advance_on_sep = 0
    has_backstep = 0
    has_return = 0
}

function trim(s, t) {
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

    if (u ~ /^GCOMMAND_FINDPATHSEPARATOR[A-Z0-9_]*:/) has_entry = 1

    if (u ~ /^TST\.B \(A[0-7]\)\+$/ || u ~ /^BNE\./) has_scan_loop = 1
    if (u ~ /^SUBA?\.L A[0-7],A[0-7]$/ || u ~ /^MOVE\.L A[0-7],D[0-7]$/ || u ~ /^TST\.L D[0-7]$/) has_distance = 1
    if (u ~ /^MOVEQ(\.L)? #':',D[0-7]$/ || u ~ /^MOVEQ(\.L)? #':',D[0-7]$/ || u ~ /^MOVEQ(\.L)? #'\/',D[0-7]$/ || u ~ /^CMP\.B D[0-7],D[0-7]$/) has_sep_cmp = 1
    if (u ~ /^ADDQ\.L #\$1,\-?[0-9]*\(A[0-7]\)$/ || u ~ /^ADDQ\.L #1,\-?[0-9]*\(A[0-7]\)$/ || u ~ /^ADDQ\.L #\$1,A[0-7]$/ || u ~ /^ADDQ\.L #1,A[0-7]$/) has_advance_on_sep = 1
    if (u ~ /^SUBQ\.L #\$1,\-?[0-9]*\(A[0-7]\)$/ || u ~ /^SUBQ\.L #1,\-?[0-9]*\(A[0-7]\)$/ || u ~ /^SUBQ\.L #\$1,A[0-7]$/ || u ~ /^SUBQ\.L #1,A[0-7]$/) has_backstep = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SCAN_LOOP=" has_scan_loop
    print "HAS_DISTANCE=" has_distance
    print "HAS_SEP_CMP=" has_sep_cmp
    print "HAS_ADVANCE_ON_SEP=" has_advance_on_sep
    print "HAS_BACKSTEP=" has_backstep
    print "HAS_RETURN=" has_return
}
