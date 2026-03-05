BEGIN {
    has_label = 0
    has_state_select = 0
    has_state_read = 0
    has_state_cmp = 0
    has_wait_loop = 0
    has_save_call = 0
    has_clear_pending = 0
    has_forbid = 0
    has_done_state = 0
    has_dealloc = 0
    has_rts = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CTASKS_IFFTASKCLEANUP[A-Z0-9_]*:/) has_label = 1
    if (u ~ /CTASKS_IFFTASKSTATE/) has_state_read = 1
    if (u ~ /SUBQ.W #4/ || u ~ /SUBQ.W #5/ || u ~ /SUBQ.W #6/ || u ~ /SUBQ.W #\$4/ || u ~ /SUBQ.W #\$5/ || u ~ /SUBQ.W #\$6/ || u ~ /MOVEQ.L #\$B/ || u ~ /MOVEQ #11/ || u ~ /CMP.W D1,D0/) has_state_cmp = 1
    if (u ~ /BRUSH_LOADINPROGRESSFLAG/ && (u ~ /BNE\./ || u ~ /TST\.L/)) has_wait_loop = 1
    if (u ~ /GROUP_AF_JMPTBL_GCOMMAND_SAVEBRUSHRESULT/ || u ~ /GROUP_AF_JMPTBL_GCOMMAND_SAVEBRUSH/ || u ~ /GROUP_AF_JMPTBL_GCOMMAND_SAVEBRU/) has_save_call = 1
    if (u ~ /CTASKS_PENDINGLOGOBRUSHDESCRIPTOR/ || u ~ /CTASKS_PENDINGGADSBRUSHDESCRIPTOR/ || u ~ /CTASKS_PENDINGIFFBRUSHDESCRIPTOR/) has_clear_pending = 1
    if (u ~ /_LVOFORBID/) has_forbid = 1
    if (u ~ /CTASKS_IFFTASKDONEFLAG/ || u ~ /CLR.W CTASKS_IFFTASKSTATE/) has_done_state = 1
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) has_dealloc = 1
    if (u == "RTS") has_rts = 1
}
END {
    has_state_select = (has_state_read && has_state_cmp) ? 1 : 0
    print "HAS_LABEL=" has_label
    print "HAS_STATE_SELECT=" has_state_select
    print "HAS_WAIT_LOOP=" has_wait_loop
    print "HAS_SAVE_CALL=" has_save_call
    print "HAS_CLEAR_PENDING=" has_clear_pending
    print "HAS_FORBID=" has_forbid
    print "HAS_DONE_STATE=" has_done_state
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_RTS=" has_rts
}
