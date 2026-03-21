BEGIN {
    has_label = 0
    has_link = 0
    has_textlen = 0
    has_ctrl24 = 0
    has_ctrl25 = 0
    has_space = 0
    has_store = 0
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

    if (uline ~ /^TEXTDISP_TRIMTEXTTOPIXELWIDTH:/) has_label = 1
    if (uline ~ /LINK.W A5,#-28/ || uline ~ /SUB.W #\$14,A7/) has_link = 1
    if (uline ~ /_LVOTEXTLENGTH/) has_textlen = 1
    if (uline ~ /MOVEQ #24,D1/ || uline ~ /MOVEQ #24,D0/ || uline ~ /MOVEQ.L #\$18,D1/) has_ctrl24 = 1
    if (uline ~ /MOVEQ #25,D1/ || uline ~ /MOVEQ #25,D4/ || uline ~ /MOVEQ.L #\$19,D1/ || uline ~ /MOVEQ.L #\$19,D6/) has_ctrl25 = 1
    if (uline ~ /MOVEQ #32,D0/ || uline ~ /CMP.B \(A0\),D0/ || uline ~ /MOVEQ.L #\$20,D0/ || uline ~ /CMP.B \(A3\),D0/) has_space = 1
    if (uline ~ /MOVE.B D4,\(A0\)/ || uline ~ /MOVE.B D0,\(A2\)/) has_store = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D4-D7\/A2-A3/ || uline ~ /MOVEM.L \(A7\)\+,D5\/D6\/D7\/A2\/A3\/A5/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_TEXTLEN=" has_textlen
    print "HAS_CTRL24=" has_ctrl24
    print "HAS_CTRL25=" has_ctrl25
    print "HAS_SPACE=" has_space
    print "HAS_STORE=" has_store
    print "HAS_RESTORE=" has_restore
}
