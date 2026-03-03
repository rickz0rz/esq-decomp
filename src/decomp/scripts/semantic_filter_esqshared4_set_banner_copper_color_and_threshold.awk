BEGIN {
    has_first_store = 0
    has_second_store = 0
    has_row_a = 0
    has_row_b = 0
    has_start_a = 0
    has_start_b = 0
    has_end_a = 0
    has_end_b = 0
    has_threshold = 0
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

    if (u ~ /^MOVE\.B D0,\(A4\)$/) has_first_store = 1
    if (u ~ /ESQ_COPPERLISTBANNERB/ && u ~ /^LEA /) has_second_store = 1
    if (u ~ /ESQ_BANNERSWEEPWAITROWA/) has_row_a = 1
    if (u ~ /ESQ_BANNERSWEEPWAITROWB/) has_row_b = 1
    if (u ~ /ESQ_BANNERSWEEPWAITSTARTPROGRAMA/) has_start_a = 1
    if (u ~ /ESQ_BANNERSWEEPWAITSTARTPROGRAMB/) has_start_b = 1
    if (u ~ /ESQ_BANNERSWEEPWAITENDPROGRAMA/) has_end_a = 1
    if (u ~ /ESQ_BANNERSWEEPWAITENDPROGRAMB/) has_end_b = 1
    if (u ~ /ESQPARS2_BANNERCOLORTHRESHOLD/) has_threshold = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_FIRST_STORE=" has_first_store
    print "HAS_SECOND_STORE=" has_second_store
    print "HAS_ROW_A=" has_row_a
    print "HAS_ROW_B=" has_row_b
    print "HAS_START_A=" has_start_a
    print "HAS_START_B=" has_start_b
    print "HAS_END_A=" has_end_a
    print "HAS_END_B=" has_end_b
    print "HAS_THRESHOLD=" has_threshold
    print "HAS_RTS=" has_rts
}
