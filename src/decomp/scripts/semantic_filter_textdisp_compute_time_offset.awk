BEGIN {
    has_label = 0
    has_link = 0
    has_sched = 0
    has_window = 0
    has_now = 0
    has_ampm = 0
    has_daymul = 0
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
    uline = toupper(line)

    if (uline ~ /^TEXTDISP_COMPUTETIMEOFFSET:/) has_label = 1
    if (uline ~ /LINK.W A5,#-36/) has_link = 1
    if (uline ~ /COMPUTESCHEDULEOFFSETFORROW\(PC\)/) has_sched = 1
    if (uline ~ /TLIBA2_COMPUTEBROADCASTTIMEWINDOW\(PC\)/) has_window = 1
    if (uline ~ /GLOBAL_WORD_CURRENT_HOUR/ && uline ~ /GLOBAL_WORD_CURRENT_MINUTE/) has_now = 1
    if (uline ~ /CLOCK_CURRENTAMPMFLAG/ && uline ~ /\.USE_ZERO_BIAS:/) has_ampm = 1
    if (uline ~ /MOVE.L #\$5A0,D1/) has_daymul = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D2-D7\/A3/) has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SCHED=" has_sched
    print "HAS_WINDOW=" has_window
    print "HAS_NOW=" has_now
    print "HAS_AMPM=" has_ampm
    print "HAS_DAYMUL=" has_daymul
    print "HAS_RETURN=" has_return
}
