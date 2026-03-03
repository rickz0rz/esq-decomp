BEGIN {
    has_label = 0
    has_btst = 0
    has_base = 0
    has_tail_sub = 0
    has_not_found = 0
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

    if (uline ~ /^TEXTDISP_FINDCONTROLTOKEN:/) has_label = 1
    if (uline ~ /BTST #7,\(A3\)/) has_btst = 1
    if (uline ~ /SUBI\.W #\$84,D0/) has_base = 1
    if (uline ~ /SUBQ\.W #8,D0/) has_tail_sub = 1
    if (uline ~ /^\.NOT_FOUND:/ || uline ~ /MOVEQ #0,D0/) has_not_found = 1
    if (uline ~ /MOVEA\.L \(A7\)\+,A3/ || uline ~ /RTS/) has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_BTST=" has_btst
    print "HAS_BASE_SUB=" has_base
    print "HAS_TAIL_SUB=" has_tail_sub
    print "HAS_NOT_FOUND=" has_not_found
    print "HAS_RETURN=" has_return
}
