BEGIN {
    has_label = 0
    has_link = 0
    has_mode_dispatch = 0
    has_find_control = 0
    has_find_quoted = 0
    has_wildcard = 0
    has_compare = 0
    has_substring = 0
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

    if (uline ~ /^TEXTDISP_FINDENTRYMATCHINDEX:/) has_label = 1
    if (uline ~ /LINK.W A5,#-56/) has_link = 1
    if (uline ~ /^\.DISPATCH_MODE:/ || uline ~ /^\.MODE_FORWARD:/ || uline ~ /^\.MODE_BACKWARD:/) has_mode_dispatch = 1
    if (uline ~ /BSR.W TEXTDISP_FINDCONTROLTOKEN/) has_find_control = 1
    if (uline ~ /BSR.W TEXTDISP_FINDQUOTEDSPAN/) has_find_quoted = 1
    if (uline ~ /ESQ_TESTBIT1BASED\(PC\)/) has_wildcard = 1
    if (uline ~ /JSR STRING_COMPARENOCASE\(PC\)/) has_compare = 1
    if (uline ~ /ESQ_FINDSUBSTRINGCASEFOLD\(PC\)/) has_substring = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D5-D7\/A2-A3/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_MODE_DISPATCH=" has_mode_dispatch
    print "HAS_FIND_CONTROL=" has_find_control
    print "HAS_FIND_QUOTED=" has_find_quoted
    print "HAS_WILDCARD_GATE=" has_wildcard
    print "HAS_COMPARE=" has_compare
    print "HAS_SUBSTRING=" has_substring
    print "HAS_RESTORE=" has_restore
}
