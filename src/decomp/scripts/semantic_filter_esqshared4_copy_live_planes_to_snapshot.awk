BEGIN {
    has_live0 = 0
    has_live1 = 0
    has_live2 = 0
    has_dst0 = 0
    has_copy = 0
    has_count = 0
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

    if (u ~ /ESQSHARED_LIVEPLANEBASE0/) has_live0 = 1
    if (u ~ /ESQSHARED_LIVEPLANEBASE1/) has_live1 = 1
    if (u ~ /ESQSHARED_LIVEPLANEBASE2/) has_live2 = 1
    if (u ~ /ESQPARS2_BANNERSNAPSHOTPLANE0DSTPTR/) has_dst0 = 1

    if (u ~ /^MOVE\.L \(A[0-7]\)\+,\(A[0-7]\)\+$/) has_copy = 1
    if (u ~ /^MOVE\.[WL] #\$?2B,D[0-7]$/ || u ~ /^MOVE\.[WL] #43,D[0-7]$/ || u ~ /^MOVEQ #43,D[0-7]$/) has_count = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_LIVE0=" has_live0
    print "HAS_LIVE1=" has_live1
    print "HAS_LIVE2=" has_live2
    print "HAS_DST0=" has_dst0
    print "HAS_COPY=" has_copy
    print "HAS_COUNT=" has_count
    print "HAS_RTS=" has_rts
}
