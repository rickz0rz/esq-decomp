BEGIN {
    has_entry=0
    has_index_guard=0
    has_alloc=0
    has_title_ptr_select=0
    has_summary_sprintf=0
    has_detail_sprintf=0
    has_sanitize_call=0
    has_time_format=0
    has_flag_appends=0
    has_draw_calls=0
    has_dealloc=0
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

    if (u ~ /^ED2_DRAWENTRYDETAILSPANEL:/ || u ~ /^ED2_DRAWENTRYDETAILSPANE[A-Z0-9_]*:/) has_entry=1
    if (n ~ /SELECTEDENTRYINDEX/ && n ~ /PRIMARYGROUPENTRYCOUNT/ || n ~ /CMPWD1D0/ || n ~ /MOVEWD1ED2SELECTEDENTRYINDEX/ || n ~ /RESETINDEX/) has_index_guard=1
    if (n ~ /ALLOCATEMEMORY/ || n ~ /ALLOCATEMEM/) has_alloc=1
    if (n ~ /PRIMARYTITLEPTRTABLE/ || n ~ /SELECTEDENTRYTITLEPTR/) has_title_ptr_select=1
    if (n ~ /PICLUPOS1/ || n ~ /WDISPSPRINTF/) has_summary_sprintf=1
    if (n ~ /CHANSOURCECALLLTRS1/ || n ~ /WDISPSPRINTF/) has_detail_sprintf=1
    if (n ~ /COPYANDSANITIZESLOTSTRING/ || n ~ /COPYANDSANITIZESLOTSTRIN/) has_sanitize_call=1
    if (n ~ /FORMATENTRYTIMEFORINDEX/ || n ~ /TEXTDISPFORMATE/) has_time_format=1
    if (n ~ /APPENDATNULL/ || n ~ /MOVIE/ || n ~ /SPORTSPROG/ || n ~ /PREVDAYSDATA/) has_flag_appends=1
    if (n ~ /DRAWCENTEREDWRAPPEDTEXTLINES/ || n ~ /TLIBA3DRAWCENTER/) has_draw_calls=1
    if (n ~ /DEALLOCATEMEMORY/ || n ~ /DEALLOCATEM/) has_dealloc=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INDEX_GUARD=" has_index_guard
    print "HAS_ALLOC=" has_alloc
    print "HAS_TITLE_PTR_SELECT=" has_title_ptr_select
    print "HAS_SUMMARY_SPRINTF=" has_summary_sprintf
    print "HAS_DETAIL_SPRINTF=" has_detail_sprintf
    print "HAS_SANITIZE_CALL=" has_sanitize_call
    print "HAS_TIME_FORMAT=" has_time_format
    print "HAS_FLAG_APPENDS=" has_flag_appends
    print "HAS_DRAW_CALLS=" has_draw_calls
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_RTS=" has_rts
}
