BEGIN {
    has_entry=0
    has_process_call=0
    has_init_selection_call=0
    has_update_selection_call=0
    has_prompt_call=0
    has_testmode_call=0
    has_validate_call=0
    has_getmode_call=0
    has_column_call=0
    has_clear_markers_call=0
    has_dispatch_state=0
    has_cached_mode=0
    has_selection_ctx=0
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

    if (u ~ /^NEWGRID2_HANDLEGRIDSTATE:/ || u ~ /^NEWGRID2_HANDLEGRIDSTAT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2PROCESSGRIDSTATE/) has_process_call=1
    if (n ~ /NEWGRIDINITSELECTIONWINDOWALT/) has_init_selection_call=1
    if (n ~ /NEWGRIDUPDATESELECTIONFROMINPUT/) has_update_selection_call=1
    if (n ~ /NEWGRIDDRAWSHOWTIMESPROMPT/) has_prompt_call=1
    if (n ~ /NEWGRIDTESTMODEFLAGACTIVE/) has_testmode_call=1
    if (n ~ /NEWGRIDVALIDATESELECTIONCODE/) has_validate_call=1
    if (n ~ /NEWGRIDGETGRIDMODEINDEX/) has_getmode_call=1
    if (n ~ /NEWGRIDCOMPUTECOLUMNINDEX/) has_column_call=1
    if (n ~ /NEWGRIDCLEARMARKERSIFSELECTABLE/) has_clear_markers_call=1
    if (n ~ /NEWGRID2DISPATCHSTATEINDEX/) has_dispatch_state=1
    if (n ~ /NEWGRID2CACHEDMODEINDEX/) has_cached_mode=1
    if (n ~ /NEWGRID2SHOWTIMESSELECTIONCONTE/) has_selection_ctx=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_PROCESS_CALL="has_process_call
    print "HAS_INIT_SELECTION_CALL="has_init_selection_call
    print "HAS_UPDATE_SELECTION_CALL="has_update_selection_call
    print "HAS_PROMPT_CALL="has_prompt_call
    print "HAS_TESTMODE_CALL="has_testmode_call
    print "HAS_VALIDATE_CALL="has_validate_call
    print "HAS_GETMODE_CALL="has_getmode_call
    print "HAS_COLUMN_CALL="has_column_call
    print "HAS_CLEAR_MARKERS_CALL="has_clear_markers_call
    print "HAS_DISPATCH_STATE_GLOBAL="has_dispatch_state
    print "HAS_CACHED_MODE_GLOBAL="has_cached_mode
    print "HAS_SELECTION_CTX_GLOBAL="has_selection_ctx
    print "HAS_RTS="has_rts
}
