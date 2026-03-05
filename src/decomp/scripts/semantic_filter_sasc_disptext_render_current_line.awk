BEGIN {
    has_entry = 0
    has_finalize = 0
    has_lockstep_checks = 0
    has_setapen = 0
    has_setdrmd = 0
    has_marker_probe = 0
    has_inset_draw = 0
    has_plain_draw = 0
    has_offset_store = 0
    has_index_increment = 0
    has_return = 0
    saw_lvomove = 0
    saw_lvotext = 0
    saw_add_one = 0
    saw_current_idx_ref = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /DISPTEXT_FINALIZELINETABLE/) has_finalize = 1
    if (l ~ /DISPTEXT_LINEWIDTHPX/ || l ~ /DISPTEXT_CURRENTLINEINDEX/ || l ~ /DISPTEXT_TARGETLINEINDEX/) has_lockstep_checks = 1
    if (l ~ /LVOSETAPEN/) has_setapen = 1
    if (l ~ /LVOSETDRMD/) has_setdrmd = 1
    if (l ~ /GROUP_AI_JMPTBL_STR_FINDCHARPTR/ || l ~ /GROUP_AI_JMPTBL_STR_FINDCHARP/) has_marker_probe = 1
    if (l ~ /GROUP_AI_JMPTBL_TLIBA1_DRAWTEXTWITHINSETSEGMENTS/ || l ~ /GROUP_AI_JMPTBL_TLIBA1_DRAWTEXTWITHI/ || l ~ /GROUP_AI_JMPTBL_TLIBA1_DRAWTEXTW/) has_inset_draw = 1
    if (l ~ /LVOMOVE/) saw_lvomove = 1
    if (l ~ /LVOTEXT/) saw_lvotext = 1
    if (l ~ /DISPTEXT_CONTROLMARKERXOFFSETPX/) has_offset_store = 1
    if (l ~ /DISPTEXT_CURRENTLINEINDEX/) saw_current_idx_ref = 1
    if (l ~ /ADDQ\.(W|L) #\$?1,D[0-7]/ || l ~ /ADD\.L #\$?1,D[0-7]/ || l ~ /ADD\.W #\$?1,D[0-7]/) saw_add_one = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    if (saw_lvomove && saw_lvotext) has_plain_draw = 1
    if (saw_current_idx_ref && saw_add_one) has_index_increment = 1
    print "HAS_ENTRY=" has_entry
    print "HAS_FINALIZE=" has_finalize
    print "HAS_LOCKSTEP_CHECKS=" has_lockstep_checks
    print "HAS_SETAPEN=" has_setapen
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_MARKER_PROBE=" has_marker_probe
    print "HAS_INSET_DRAW=" has_inset_draw
    print "HAS_PLAIN_DRAW=" has_plain_draw
    print "HAS_OFFSET_STORE=" has_offset_store
    print "HAS_INDEX_INCREMENT=" has_index_increment
    print "HAS_RETURN=" has_return
}
