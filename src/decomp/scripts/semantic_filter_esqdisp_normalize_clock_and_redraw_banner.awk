BEGIN {
    has_entry = 0
    has_normalize = 0
    has_update_queue = 0
    has_refresh = 0
    has_draw_clock = 0
    has_draw_status = 0
    has_restore = 0
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

    if (uline ~ /^ESQDISP_NORMALIZECLOCKANDREDRAWBANNER:/) has_entry = 1
    if (uline ~ /ESQFUNC_JMPTBL_PARSEINI_NORMALIZECLOCKDATA/) has_normalize = 1
    if (uline ~ /DST_UPDATEBANNERQUEUE/) has_update_queue = 1
    if (uline ~ /DST_REFRESHBANNERBUFFER/) has_refresh = 1
    if (uline ~ /ESQFUNC_JMPTBL_CLEANUP_DRAWCLOCKBANNER/) has_draw_clock = 1
    if (uline ~ /ESQDISP_DRAWSTATUSBANNER_IMPL/) has_draw_status = 1
    if (uline ~ /MOVE\.L -4\(A5\),4\(A0\)/ && uline ~ /MOVEA\.L -8\(A5\),A3/) has_restore = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_NORMALIZE=" has_normalize
    print "HAS_UPDATE_QUEUE=" has_update_queue
    print "HAS_REFRESH=" has_refresh
    print "HAS_DRAW_CLOCK=" has_draw_clock
    print "HAS_DRAW_STATUS=" has_draw_status
    print "HAS_RESTORE=" has_restore
    print "HAS_RETURN=" has_return
}
