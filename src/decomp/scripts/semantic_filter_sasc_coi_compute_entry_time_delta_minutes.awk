BEGIN {
    has_label = 0
    has_guard = 0
    has_scan_loop = 0
    has_wildcard_path = 0
    has_halfhour_fallback = 0
    has_offset_call = 0
    has_return_move = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^COI_COMPUTEENTRYTIMEDELTAMINUTES[A-Z0-9_]*:/) has_label = 1
    if (u ~ /TST.W D7/ || u ~ /CMP.W D0,D7/ || u ~ /COI_COMPUTEENTRYTIMEDELTAMINUTES_RETURN/) has_guard = 1
    if (u ~ /TST.L 56\(A3,D0.L\)/ || u ~ /ADDQ.W #1,D6/ || u ~ /BRA\.[BWS]? .*0365/ || u ~ /__COI_COMPUTEENTRYTIMEDELTAMINUTES__/) has_scan_loop = 1
    if (u ~ /GROUP_AE_JMPTBL_TLIBA_FINDFIRSTWILDCARDMATCHINDEX/ || u ~ /GROUP_AE_JMPTBL_TLIBA_FINDFIRSTWILDCARD/ || u ~ /GROUP_AE_JMPTBL_TLIBA_FINDFIRSTW/ || u ~ /GROUP_AE_JMPTBL_ESQDISP_GETENTRYAUXPOINTERBYMODE/ || u ~ /GROUP_AE_JMPTBL_ESQDISP_GETENTRY/) has_wildcard_path = 1
    if (u ~ /CLOCK_HALFHOURSLOTINDEX/ || u ~ /MULU #30/ || u ~ /MOVE.L #2880,D1/ || u ~ /#\$B40/) has_halfhour_fallback = 1
    if (u ~ /GROUP_AE_JMPTBL_TEXTDISP_COMPUTETIMEOFFSET/ || u ~ /GROUP_AE_JMPTBL_TEXTDISP_COMPUTE/) has_offset_call = 1
    if (u ~ /MOVE.L D0,D5/ || u ~ /MOVE.L D1,D5/ || u ~ /MOVE.L D[0-7],D0/) has_return_move = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_GUARD=" has_guard
    print "HAS_SCAN_LOOP=" has_scan_loop
    print "HAS_WILDCARD_PATH=" has_wildcard_path
    print "HAS_HALFHOUR_FALLBACK=" has_halfhour_fallback
    print "HAS_OFFSET_CALL=" has_offset_call
    print "HAS_RETURN_MOVE=" has_return_move
}
