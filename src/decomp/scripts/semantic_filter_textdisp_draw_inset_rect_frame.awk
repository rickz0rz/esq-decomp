BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_mode2 = 0
    has_mode3 = 0
    has_draw_call = 0
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

    if (uline ~ /^TEXTDISP_DRAWINSETRECTFRAME:/) has_label = 1
    if (uline ~ /LINK.W A5,#-8/) has_link = 1
    if (uline ~ /MOVEM.L D2-D7\/A3,-\(A7\)/) has_save = 1
    if (uline ~ /CMP.W D1,D7/ && uline ~ /\.CHECK_MODE_3/) has_mode2 = 1
    if (uline ~ /\.CHECK_MODE_3:/ || uline ~ /MOVEQ #3,D1/) has_mode3 = 1
    if (uline ~ /TLIBA1_DRAWFORMATTEDTEXTBLOCK/) has_draw_call = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D2-D7\/A3/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_MODE2=" has_mode2
    print "HAS_MODE3=" has_mode3
    print "HAS_DRAW_CALL=" has_draw_call
    print "HAS_RESTORE=" has_restore
}
