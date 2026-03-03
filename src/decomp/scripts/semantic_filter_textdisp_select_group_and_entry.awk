BEGIN {
    has_label = 0
    has_init = 0
    has_build_list = 0
    has_select_best = 0
    has_group2 = 0
    has_select_index = 0
    has_no_match = 0
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

    if (uline ~ /^TEXTDISP_SELECTGROUPANDENTRY:/) has_label = 1
    if (uline ~ /TEXTDISP_PRIMARYFIRSTMATCHINDEX/ && uline ~ /TEXTDISP_SECONDARYFIRSTMATCHINDEX/) has_init = 1
    if (uline ~ /BSR.W TEXTDISP_BUILDMATCHINDEXLIST/) has_build_list = 1
    if (uline ~ /BSR.W TEXTDISP_SELECTBESTMATCHFROMLIST/) has_select_best = 1
    if (uline ~ /^\.TRY_GROUP2:/ || uline ~ /TEXTDISP_SECONDARYGROUPRECORDLENGTH/) has_group2 = 1
    if (uline ~ /^\.SELECT_INDEX:/ || uline ~ /TEXTDISP_CURRENTMATCHINDEX/) has_select_index = 1
    if (uline ~ /^\.NO_MATCH:/ || uline ~ /MOVEQ #0,D0/) has_no_match = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D5-D7\/A2-A3/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_INIT=" has_init
    print "HAS_BUILD_LIST=" has_build_list
    print "HAS_SELECT_BEST=" has_select_best
    print "HAS_GROUP2=" has_group2
    print "HAS_SELECT_INDEX=" has_select_index
    print "HAS_NO_MATCH=" has_no_match
    print "HAS_RESTORE=" has_restore
}
