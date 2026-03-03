BEGIN {
    has_label = 0
    has_link = 0
    has_schedule_call = 0
    has_format_call = 0
    has_hhmm_path = 0
    has_divs = 0
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

    if (uline ~ /^TEXTDISP_FORMATENTRYTIMEFORINDEX:/) has_label = 1
    if (uline ~ /LINK.W A5,#-12/) has_link = 1
    if (uline ~ /COMPUTESCHEDULEOFFSETFORROW\(PC\)/) has_schedule_call = 1
    if (uline ~ /CLEANUP_FORMATCLOCKFORMATENTRY\(PC\)/) has_format_call = 1
    if (uline ~ /^\.PARSE_HHMM:/ || uline ~ /CMP.B 3\(A0\),D0/) has_hhmm_path = 1
    if (uline ~ /DIVS #\$1E,D0/) has_divs = 1
    if (uline ~ /^\.CLEAR_OUTPUT:/ || uline ~ /CLR.B \(A3\)/) has_clear = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D5-D7\/A2-A3\/A6/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SCHEDULE_CALL=" has_schedule_call
    print "HAS_FORMAT_CALL=" has_format_call
    print "HAS_HHMM_PATH=" has_hhmm_path
    print "HAS_DIVS=" has_divs
    print "HAS_CLEAR=" has_clear
    print "HAS_RESTORE=" has_restore
}
