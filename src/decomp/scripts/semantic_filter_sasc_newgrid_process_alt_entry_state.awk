BEGIN {
    has_entry=0
    has_workflow_global=0
    has_cursor_global=0
    has_attempt_global=0
    has_find_next=0
    has_handle_alt=0
    has_draw_empty=0
    has_validate=0
    has_mode_index=0
    has_column_index=0
    has_flag35=0
    has_const5=0
    has_const6=0
    has_const89=0
    has_const51=0
    has_const_minus1=0
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

    if (u ~ /^NEWGRID_PROCESSALTENTRYSTATE:/ || u ~ /^NEWGRID_PROCESSALTENTRYSTAT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDALTENTRYWORKFLOWSTATE/) has_workflow_global=1
    if (n ~ /NEWGRIDALTENTRYCURSOR/) has_cursor_global=1
    if (n ~ /NEWGRIDALTENTRYATTEMPTCOUNTER/) has_attempt_global=1
    if (n ~ /NEWGRIDFINDNEXTENTRYWITHMARKERS/) has_find_next=1
    if (n ~ /NEWGRIDHANDLEALTGRIDSTATE/) has_handle_alt=1
    if (n ~ /NEWGRIDDRAWEMPTYGRIDMESSAGE/) has_draw_empty=1
    if (n ~ /NEWGRIDVALIDATESELECTIONCODE/) has_validate=1
    if (n ~ /NEWGRIDGETGRIDMODEINDEX/) has_mode_index=1
    if (n ~ /NEWGRIDCOMPUTECOLUMNINDEX/) has_column_index=1
    if (n ~ /CONFIGNEWGRIDSELECTIONCODE35ENABLEDFLAG/ || n ~ /CONFIGNEWGRIDSELECTIONCODE35ENA/) has_flag35=1
    if (u ~ /#5([^0-9]|$)/ || u ~ /#\$05/ || u ~ /#\$5([^0-9A-F]|$)/ || u ~ /5\.[Ww]/ || u ~ /\(\$5\)/) has_const5=1
    if (u ~ /#6([^0-9]|$)/ || u ~ /#\$06/ || u ~ /#\$6([^0-9A-F]|$)/ || u ~ /6\.[Ww]/ || u ~ /\(\$6\)/) has_const6=1
    if (u ~ /#89([^0-9]|$)/ || u ~ /#\$59/ || u ~ /89\.[Ww]/ || u ~ /\(\$59\)/) has_const89=1
    if (u ~ /#51([^0-9]|$)/ || u ~ /#\$33/ || u ~ /51\.[Ww]/ || u ~ /\(\$33\)/) has_const51=1
    if (u ~ /#-1([^0-9]|$)/ || u ~ /#\$FF/ || u ~ /#\$FFFFFFFF/ || u ~ /MOVEQ\.L #\$FF,D[0-7]/) has_const_minus1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_WORKFLOW_GLOBAL="has_workflow_global
    print "HAS_CURSOR_GLOBAL="has_cursor_global
    print "HAS_ATTEMPT_GLOBAL="has_attempt_global
    print "HAS_FIND_NEXT_CALL="has_find_next
    print "HAS_HANDLE_ALT_CALL="has_handle_alt
    print "HAS_DRAW_EMPTY_CALL="has_draw_empty
    print "HAS_VALIDATE_CALL="has_validate
    print "HAS_MODE_INDEX_CALL="has_mode_index
    print "HAS_COLUMN_INDEX_CALL="has_column_index
    print "HAS_FLAG35_GLOBAL="has_flag35
    print "HAS_CONST_5="has_const5
    print "HAS_CONST_6="has_const6
    print "HAS_CONST_89="has_const89
    print "HAS_CONST_51="has_const51
    print "HAS_CONST_MINUS1="has_const_minus1
    print "HAS_RTS="has_rts
}
