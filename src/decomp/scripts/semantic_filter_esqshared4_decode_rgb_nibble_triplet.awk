BEGIN {
    has_read2 = 0
    has_read1 = 0
    has_read0 = 0
    has_mask2 = 0
    has_mask1 = 0
    has_mask0 = 0
    has_lsl2 = 0
    has_lsl1 = 0
    has_add10 = 0
    has_add20 = 0
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

    if (u ~ /^MOVE\.B \(A1\)\+,D2$/) has_read2 = 1
    if (u ~ /^MOVE\.B \(A1\)\+,D1$/) has_read1 = 1
    if (u ~ /^MOVE\.B \(A1\)\+,D0$/) has_read0 = 1

    if (u ~ /^ANDI\.[WL] #15,D2$/ || u ~ /^ANDI\.[WL] #\$?F,D2$/) has_mask2 = 1
    if (u ~ /^ANDI\.[WL] #15,D1$/ || u ~ /^ANDI\.[WL] #\$?F,D1$/) has_mask1 = 1
    if (u ~ /^ANDI\.[WL] #15,D0$/ || u ~ /^ANDI\.[WL] #\$?F,D0$/) has_mask0 = 1

    if (u ~ /^LSL\.[WL] #8,D2$/) has_lsl2 = 1
    if (u ~ /^LSL\.[WL] #4,D1$/) has_lsl1 = 1
    if (u ~ /^ADD\.[WL] D1,D0$/) has_add10 = 1
    if (u ~ /^ADD\.[WL] D2,D0$/) has_add20 = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_READ2=" has_read2
    print "HAS_READ1=" has_read1
    print "HAS_READ0=" has_read0
    print "HAS_MASK2=" has_mask2
    print "HAS_MASK1=" has_mask1
    print "HAS_MASK0=" has_mask0
    print "HAS_LSL2=" has_lsl2
    print "HAS_LSL1=" has_lsl1
    print "HAS_ADD10=" has_add10
    print "HAS_ADD20=" has_add20
    print "HAS_RTS=" has_rts
}
