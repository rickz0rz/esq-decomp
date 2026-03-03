BEGIN {
    has_label = 0
    has_link = 0
    has_sched = 0
    has_fmt = 0
    has_hhmm = 0
    has_clock_tbl = 0
    has_clear = 0
    has_restore = 0
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

    if (uline ~ /^TEXTDISP_FORMATENTRYTIME:/) has_label = 1
    if (uline ~ /LINK.W A5,#-16/) has_link = 1
    if (uline ~ /COMPUTESCHEDULEOFFSETFORROW\(PC\)/) has_sched = 1
    if (uline ~ /CLEANUP_FORMATCLOCKFORMATENTRY\(PC\)/) has_fmt = 1
    if (uline ~ /^\.PARSE_HHMM:/ || uline ~ /CMP.B 3\(A0\),D0/) has_hhmm = 1
    if (uline ~ /GLOBAL_REF_STR_CLOCK_FORMAT/) has_clock_tbl = 1
    if (uline ~ /^\.CLEAR_OUTPUT:/ || uline ~ /CLR.B \(A3\)/) has_clear = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D4-D7\/A2-A3/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SCHED=" has_sched
    print "HAS_FMT=" has_fmt
    print "HAS_HHMM=" has_hhmm
    print "HAS_CLOCK_TBL=" has_clock_tbl
    print "HAS_CLEAR=" has_clear
    print "HAS_RESTORE=" has_restore
}
