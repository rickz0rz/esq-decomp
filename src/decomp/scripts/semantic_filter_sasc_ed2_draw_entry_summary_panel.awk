BEGIN {
    has_entry=0
    has_index_guard=0
    has_entry_ptr_select=0
    has_sprintf_header=0
    has_sprintf_detail=0
    has_append_flag8=0
    has_append_flag16=0
    has_draw_lines=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ED2_DRAWENTRYSUMMARYPANEL:/ || u ~ /^ED2_DRAWENTRYSUMMARYPANE[A-Z0-9_]*:/) has_entry=1
    if (n ~ /SELECTEDENTRYINDEX/ && n ~ /PRIMARYGROUPENTRYCOUNT/ || n ~ /CMPWD1D0/ || n ~ /MOVEWD2ED2SELECTEDENTRYINDEX/) has_index_guard=1
    if (n ~ /PRIMARYENTRYPTRTABLE/ || n ~ /SELECTEDENTRYDATAPTR/) has_entry_ptr_select=1
    if (n ~ /GLOBALSTRCLUCLUPOS1/ || n ~ /WDISPSPRINTF/) has_sprintf_header=1
    if (n ~ /GLOBALSTRCHANSOURCECALLLTRS/ || n ~ /WDISPSPRINTF/) has_sprintf_detail=1
    if (n ~ /ED2STRHILITESRC/ || n ~ /ED2STRSTEREO/ || n ~ /ED2STRSUMBYSRC/ || n ~ /ED2STRNONE/) has_append_flag8=1
    if (n ~ /ED2STRGRID/ || n ~ /ED2STRDMPLEX/ || n ~ /ED2STRCF2DPPV/ || n ~ /ED2STRDNICHE/) has_append_flag16=1
    if (n ~ /DRAWCENTEREDWRAPPEDTEXTLINES/ || n ~ /TLIBA3DRAWCENTER/) has_draw_lines=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INDEX_GUARD=" has_index_guard
    print "HAS_ENTRY_PTR_SELECT=" has_entry_ptr_select
    print "HAS_SPRINTF_HEADER=" has_sprintf_header
    print "HAS_SPRINTF_DETAIL=" has_sprintf_detail
    print "HAS_APPEND_FLAG8=" has_append_flag8
    print "HAS_APPEND_FLAG16=" has_append_flag16
    print "HAS_DRAW_LINES=" has_draw_lines
    print "HAS_RTS=" has_rts
}
