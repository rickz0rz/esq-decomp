BEGIN {
    has_count6 = 0
    has_ff_check = 0
    has_zero_check = 0
    has_inner_count8 = 0
    has_btst_or_shift = 0
    has_bset_or_or = 0
    has_store = 0
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

    if (u ~ /#5,D[0-7]/ || u ~ /#6,D[0-7]/ || u ~ /#5,/) has_count6 = 1
    if (u ~ /#\$?FF,D[0-7]/ || u ~ /#255,D[0-7]/ || u ~ /CMPI\.B #\$?FF/ || u ~ /CMP\.B #-3,D[0-7]/) has_ff_check = 1
    if (u ~ /^BEQ(\.S)? / || u ~ /^JEQ / || u ~ /^TST\.B D[0-7]$/) has_zero_check = 1
    if (u ~ /#7,D[0-7]/ || u ~ /#8,D[0-7]/) has_inner_count8 = 1

    if (u ~ /^BTST / || u ~ /^LSL\./ || u ~ /^LSR\./ || u ~ /^ASL\./ || u ~ /^ASR\./ || u ~ /^AND\.[BWL] /) has_btst_or_shift = 1
    if (u ~ /^BSET / || u ~ /^OR\.[BWL] D[0-7],D[0-7]$/ || u ~ /^OR\.[BWL] .*\(A[0-7]/) has_bset_or_or = 1

    if (u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_store = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_COUNT6=" has_count6
    print "HAS_FF_CHECK=" has_ff_check
    print "HAS_ZERO_CHECK=" has_zero_check
    print "HAS_INNER_COUNT8=" has_inner_count8
    print "HAS_BTST_OR_SHIFT=" has_btst_or_shift
    print "HAS_BSET_OR_OR=" has_bset_or_or
    print "HAS_STORE=" has_store
    print "HAS_RTS=" has_rts
}
