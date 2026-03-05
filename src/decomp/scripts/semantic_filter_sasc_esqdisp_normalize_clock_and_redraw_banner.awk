BEGIN {
    has_entry = 0
    has_normalize = 0
    has_update_queue = 0
    has_refresh = 0
    has_draw_clock = 0
    has_draw_status = 0
    has_save_bitmap = 0
    has_restore_bitmap = 0
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

    if (uline ~ /^ESQDISP_NORMALIZECLOCKANDREDRAWBANNER:/ || uline ~ /^ESQDISP_NORMALIZECLOCKANDREDRAWB:/ || uline ~ /^ESQDISP_NORMALIZECLOCKANDRE[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /ESQFUNC_JMPTBL_PARSEINI_NORMALIZECLOCKDATA/ || uline ~ /ESQFUNC_JMPTBL_PARSEINI_NORMALIZECLOC/ || uline ~ /ESQFUNC_JMPTBL_PARSEINI_NORMALIZ/) has_normalize = 1
    if (uline ~ /DST_UPDATEBANNERQUEUE/ || uline ~ /DST_UPDATEBANNERQUEU/) has_update_queue = 1
    if (uline ~ /DST_REFRESHBANNERBUFFER/ || uline ~ /DST_REFRESHBANNERBUFF/) has_refresh = 1
    if (uline ~ /ESQFUNC_JMPTBL_CLEANUP_DRAWCLOCKBANNER/ || uline ~ /ESQFUNC_JMPTBL_CLEANUP_DRAWCLOCKBAN/ || uline ~ /ESQFUNC_JMPTBL_CLEANUP_DRAWCLOCK/) has_draw_clock = 1
    if (uline ~ /ESQDISP_DRAWSTATUSBANNER_IMPL/ || uline ~ /ESQDISP_DRAWSTATUSBANNER_IMP/) has_draw_status = 1
    if (uline ~ /^MOVE\.L 4\(A0\),-4\(A5\)$/ || uline ~ /^MOVE\.L 4\(A0\),D0$/ || uline ~ /^MOVE\.L 4\(A0\),/ || uline ~ /^MOVE\.L \(A1\),A3$/) has_save_bitmap = 1
    if (uline ~ /^MOVE\.L -4\(A5\),4\(A0\)$/ || uline ~ /^MOVE\.L D0,4\(A0\)$/ || uline ~ /^MOVE\.L A3,\(A0\)$/) has_restore_bitmap = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_NORMALIZE=" has_normalize
    print "HAS_UPDATE_QUEUE=" has_update_queue
    print "HAS_REFRESH=" has_refresh
    print "HAS_DRAW_CLOCK=" has_draw_clock
    print "HAS_DRAW_STATUS=" has_draw_status
    print "HAS_SAVE_BITMAP=" has_save_bitmap
    print "HAS_RESTORE_BITMAP=" has_restore_bitmap
    print "HAS_RETURN=" has_return
}
