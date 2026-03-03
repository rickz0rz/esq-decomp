BEGIN {
    has_entry = 0
    has_lea = 0
    has_load = 0
    has_count = 0
    has_fill = 0
    has_dbf = 0
    has_rts = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQSHARED4_CLEARBANNERWORKRASTERWITHONES:/) has_entry = 1
    if (uline ~ /^LEA WDISP_BANNERWORKRASTERPTR,A1$/) has_lea = 1
    if (uline ~ /^MOVEA\.L \(A1\),A0$/) has_load = 1
    if (uline ~ /^MOVE\.L #0X149,D1$/ || uline ~ /^MOVE\.L #\$149,D1$/) has_count = 1
    if (uline ~ /^MOVE\.L #0XFFFFFFFF,\(A0\)\+$/ || uline ~ /^MOVE\.L #\$FFFFFFFF,\(A0\)\+$/) has_fill = 1
    if (uline ~ /^DBF D1,\.LAB_0C7F$/ || uline ~ /^DBF D1,1B$/) has_dbf = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LEA=" has_lea
    print "HAS_LOAD=" has_load
    print "HAS_COUNT=" has_count
    print "HAS_FILL=" has_fill
    print "HAS_DBF=" has_dbf
    print "HAS_RTS=" has_rts
}
