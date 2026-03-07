BEGIN {
    has_entry=0
    has_workflow=0
    has_entry_index=0
    has_column_adjust=0
    has_should_open=0
    has_update_grid=0
    has_process_entries=0
    has_find_next=0
    has_validate=0
    has_mode_index=0
    has_column_index=0
    has_flag32=0
    has_flag48=0
    has_const3=0
    has_const4=0
    has_const5=0
    has_const6=0
    has_const89=0
    has_const32=0
    has_const48=0
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

    if (u ~ /^NEWGRID_HANDLEGRIDSELECTION:/ || u ~ /^NEWGRID_HANDLEGRIDSELECTIO[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDGRIDSELECTIONWORKFLOWSTATE/ || n ~ /NEWGRIDGRIDSELECTIONWORKFLOWSTA/) has_workflow=1
    if (n ~ /NEWGRIDGRIDSELECTIONENTRYINDEX/) has_entry_index=1
    if (n ~ /NEWGRIDGRIDSELECTIONCOLUMNADJUST/ || n ~ /NEWGRIDGRIDSELECTIONCOLUMNADJUS/) has_column_adjust=1
    if (n ~ /NEWGRIDSHOULDOPENEDITOR/) has_should_open=1
    if (n ~ /NEWGRIDUPDATEGRIDSTATE/) has_update_grid=1
    if (n ~ /NEWGRIDPROCESSGRIDENTRIES/) has_process_entries=1
    if (n ~ /NEWGRIDFINDNEXTFLAGGEDENTRY/) has_find_next=1
    if (n ~ /NEWGRIDVALIDATESELECTIONCODE/) has_validate=1
    if (n ~ /NEWGRIDGETGRIDMODEINDEX/) has_mode_index=1
    if (n ~ /NEWGRIDCOMPUTECOLUMNINDEX/) has_column_index=1
    if (n ~ /CONFIGNEWGRIDSELECTIONCODE32ENABLEDFLAG/ || n ~ /CONFIGNEWGRIDSELECTIONCODE32ENA/) has_flag32=1
    if (n ~ /CONFIGNEWGRIDSELECTIONCODE4849ENABLEDFLAG/ || n ~ /CONFIGNEWGRIDSELECTIONCODE4849/) has_flag48=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /#\$3([^0-9A-F]|$)/ || u ~ /3\.[Ww]/ || u ~ /\(\$3\)/) has_const3=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /4\.[Ww]/ || u ~ /\(\$4\)/) has_const4=1
    if (u ~ /#5([^0-9]|$)/ || u ~ /#\$05/ || u ~ /#\$5([^0-9A-F]|$)/ || u ~ /5\.[Ww]/ || u ~ /\(\$5\)/) has_const5=1
    if (u ~ /#6([^0-9]|$)/ || u ~ /#\$06/ || u ~ /#\$6([^0-9A-F]|$)/ || u ~ /6\.[Ww]/ || u ~ /\(\$6\)/) has_const6=1
    if (u ~ /#89([^0-9]|$)/ || u ~ /#\$59/ || u ~ /89\.[Ww]/ || u ~ /\(\$59\)/) has_const89=1
    if (u ~ /#32([^0-9]|$)/ || u ~ /#\$20/ || u ~ /32\.[Ww]/ || u ~ /\(\$20\)/) has_const32=1
    if (u ~ /#48([^0-9]|$)/ || u ~ /#\$30/ || u ~ /48\.[Ww]/ || u ~ /\(\$30\)/) has_const48=1
    if (u ~ /#-1([^0-9]|$)/ || u ~ /#\$FF/ || u ~ /#\$FFFFFFFF/ || u ~ /MOVEQ\.L #\$FF,D[0-7]/) has_const_minus1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_WORKFLOW_GLOBAL="has_workflow
    print "HAS_ENTRY_INDEX_GLOBAL="has_entry_index
    print "HAS_COLUMN_ADJUST_GLOBAL="has_column_adjust
    print "HAS_SHOULD_OPEN_CALL="has_should_open
    print "HAS_UPDATE_GRID_CALL="has_update_grid
    print "HAS_PROCESS_ENTRIES_CALL="has_process_entries
    print "HAS_FIND_NEXT_CALL="has_find_next
    print "HAS_VALIDATE_CALL="has_validate
    print "HAS_MODE_INDEX_CALL="has_mode_index
    print "HAS_COLUMN_INDEX_CALL="has_column_index
    print "HAS_FLAG32_GLOBAL="has_flag32
    print "HAS_FLAG48_49_GLOBAL="has_flag48
    print "HAS_CONST_3="has_const3
    print "HAS_CONST_4="has_const4
    print "HAS_CONST_5="has_const5
    print "HAS_CONST_6="has_const6
    print "HAS_CONST_89="has_const89
    print "HAS_CONST_32="has_const32
    print "HAS_CONST_48="has_const48
    print "HAS_CONST_MINUS1="has_const_minus1
    print "HAS_RTS="has_rts
}
