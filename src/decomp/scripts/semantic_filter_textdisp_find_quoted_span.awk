BEGIN {
    has_label = 0
    has_link = 0
    has_find_quote = 0
    has_mark_quotes = 0
    has_trim_lead = 0
    has_trim_trail = 0
    has_return_len = 0
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

    if (uline ~ /^TEXTDISP_FINDQUOTEDSPAN:/) has_label = 1
    if (uline ~ /LINK.W A5,#-12/) has_link = 1
    if (uline ~ /JSR STR_FINDCHARPTR\(PC\)/) has_find_quote = 1
    if (uline ~ /^\.MARK_HAS_QUOTES:/ || uline ~ /MOVEQ #1,D0/ && uline ~ /MOVE.L D0,\(A0\)/) has_mark_quotes = 1
    if (uline ~ /^\.TRIM_LEADING_CTRL:/ || uline ~ /BTST #3,\(A1\)/) has_trim_lead = 1
    if (uline ~ /^\.TRIM_TRAILING_CTRL:/ || uline ~ /SUBQ.L #1,-8\(A5\)/) has_trim_trail = 1
    if (uline ~ /SUB.L -4\(A5\),D0/ || uline ~ /ADDQ.L #1,D7/) has_return_len = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_FIND_QUOTE=" has_find_quote
    print "HAS_MARK_QUOTES=" has_mark_quotes
    print "HAS_TRIM_LEAD=" has_trim_lead
    print "HAS_TRIM_TRAIL=" has_trim_trail
    print "HAS_RETURN_LEN=" has_return_len
}
