BEGIN {
    has_label = 0
    has_link = 0
    has_tag_checks = 0
    has_candidate_loop = 0
    has_time_offset = 0
    has_match_call = 0
    has_finalize = 0
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

    if (uline ~ /^TEXTDISP_SELECTBESTMATCHFROMLIST:/) has_label = 1
    if (uline ~ /LINK.W A5,#-24/) has_link = 1
    if (uline ~ /TEXTDISP_TAG_PPV/ && uline ~ /TEXTDISP_TAG_SBE/ && uline ~ /TEXTDISP_TAG_SPORTS/) has_tag_checks = 1
    if (uline ~ /^\.CANDIDATE_LOOP:/) has_candidate_loop = 1
    if (uline ~ /BSR.W TEXTDISP_COMPUTETIMEOFFSET/) has_time_offset = 1
    if (uline ~ /BSR.W TEXTDISP_FINDENTRYMATCHINDEX/) has_match_call = 1
    if (uline ~ /^\.FINALIZE_CANDIDATES:/) has_finalize = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D2-D7\/A2-A3/) has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_TAG_CHECKS=" has_tag_checks
    print "HAS_CANDIDATE_LOOP=" has_candidate_loop
    print "HAS_TIME_OFFSET=" has_time_offset
    print "HAS_MATCH_CALL=" has_match_call
    print "HAS_FINALIZE=" has_finalize
    print "HAS_RETURN=" has_return
}
