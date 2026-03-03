BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_cmp = 0
    has_compare_call = 0
    has_not_found = 0
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

    if (uline ~ /^TEXTDISP_FINDALIASINDEXBYNAME:/) has_label = 1
    if (uline ~ /LINK.W A5,#-24/) has_link = 1
    if (uline ~ /MOVEM.L D7\/A2-A3,-\(A7\)/) has_save = 1
    if (uline ~ /CMP.W D0,D7/ && uline ~ /BGE.S .NOT_FOUND/) has_cmp = 1
    if (uline ~ /JSR STRING_COMPARENOCASEN\(PC\)/) has_compare_call = 1
    if (uline ~ /^\.NOT_FOUND:/ || uline ~ /MOVEQ #-1,D0/) has_not_found = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D7\/A2-A3/ && uline ~ /UNLK A5/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_CMP=" has_cmp
    print "HAS_COMPARE_CALL=" has_compare_call
    print "HAS_NOT_FOUND=" has_not_found
    print "HAS_RESTORE=" has_restore
}
