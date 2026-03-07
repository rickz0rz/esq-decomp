BEGIN {
    has_entry=0
    has_pending_op=0
    has_last_result=0
    has_grid_op=0
    has_reinit_flag=0
    has_handle_selection=0
    has_alt_entry=0
    has_handle_state=0
    has_secondary=0
    has_schedule=0
    has_showtimes=0
    has_boolize=0
    has_boolize_ff=0
    has_boolize_00=0
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

    if (u ~ /^NEWGRID2_DISPATCHGRIDOPERATION:/ || u ~ /^NEWGRID2_DISPATCHGRIDOPERATIO[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2PENDINGOPERATIONID/) has_pending_op=1
    if (n ~ /NEWGRID2LASTDISPATCHRESULT/) has_last_result=1
    if (n ~ /NEWGRIDGRIDOPERATIONID/) has_grid_op=1
    if (n ~ /ESQDISPPENDINGGRIDREINITFLAG/) has_reinit_flag=1
    if (n ~ /NEWGRIDHANDLEGRIDSELECTION/) has_handle_selection=1
    if (n ~ /NEWGRIDPROCESSALTENTRYSTATE/) has_alt_entry=1
    if (n ~ /NEWGRID2HANDLEGRIDSTATE/) has_handle_state=1
    if (n ~ /NEWGRIDPROCESSSECONDARYSTATE/) has_secondary=1
    if (n ~ /NEWGRIDPROCESSSCHEDULESTATE/) has_schedule=1
    if (n ~ /NEWGRIDPROCESSSHOWTIMESWORKFLOW/) has_showtimes=1
    if (u ~ /SNE D0/ || u ~ /NEG\.B D0/) has_boolize=1
    if (u ~ /MOVEQ(\.L)? #\$?FF,D0/) has_boolize_ff=1
    if (u ~ /MOVEQ(\.L)? #\$?0,D0/) has_boolize_00=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_PENDING_OP_GLOBAL="has_pending_op
    print "HAS_LAST_RESULT_GLOBAL="has_last_result
    print "HAS_GRID_OP_GLOBAL="has_grid_op
    print "HAS_REINIT_FLAG_GLOBAL="has_reinit_flag
    print "HAS_HANDLE_SELECTION_CALL="has_handle_selection
    print "HAS_ALT_ENTRY_CALL="has_alt_entry
    print "HAS_HANDLE_STATE_CALL="has_handle_state
    print "HAS_SECONDARY_CALL="has_secondary
    print "HAS_SCHEDULE_CALL="has_schedule
    print "HAS_SHOWTIMES_CALL="has_showtimes
    if (has_boolize == 0 && has_boolize_ff == 1 && has_boolize_00 == 1) has_boolize=1
    print "HAS_BOOLIZE_PATH="has_boolize
    print "HAS_RTS="has_rts
}
