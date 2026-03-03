BEGIN {
    has_label = 0
    has_save = 0
    has_width_math = 0
    has_blit = 0
    has_stack_adj = 0
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

    if (uline ~ /^CLEANUP_DRAWCLOCKFORMATFRAME:/) has_label = 1
    if (uline ~ /MOVEM.L D2-D3,-\(A7\)/) has_save = 1
    if (uline ~ /MOVE.L #660,D0/ || uline ~ /SUB.L D2,D0/) has_width_math = 1
    if (uline ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPRASTPORT/) has_blit = 1
    if (uline ~ /LEA 36\(A7\),A7/) has_stack_adj = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D2-D3/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_WIDTH_MATH=" has_width_math
    print "HAS_BLIT=" has_blit
    print "HAS_STACK_ADJ=" has_stack_adj
    print "HAS_RESTORE=" has_restore
}
