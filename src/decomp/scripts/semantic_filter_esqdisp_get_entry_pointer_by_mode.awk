BEGIN {
    has_label=0; has_link=0; has_save=0; has_mode1=0; has_primary_count=0
    has_primary_table=0; has_mode2=0; has_secondary_count=0; has_secondary_table=0
    has_restore=0; has_rts=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^ESQDISP_GETENTRYPOINTERBYMODE:/) has_label=1
    if (index(u,"LINK.W A5,#-4")>0) has_link=1
    if (index(u,"MOVEM.L D6-D7,-(A7)")>0 || index(u,"MOVEM.L D6/D7,-(A7)")>0) has_save=1
    if (index(u,"MOVEQ #1,D0")>0 && index(u,"CMP.L D0,D6")>0) has_mode1=1
    if (index(u,"TEXTDISP_PRIMARYGROUPENTRYCOUNT")>0) has_primary_count=1
    if (index(u,"TEXTDISP_PRIMARYENTRYPTRTABLE")>0) has_primary_table=1
    if (index(u,"MOVEQ #2,D0")>0 && index(u,"CMP.L D0,D6")>0) has_mode2=1
    if (index(u,"TEXTDISP_SECONDARYGROUPENTRYCOUNT")>0) has_secondary_count=1
    if (index(u,"TEXTDISP_SECONDARYENTRYPTRTABLE")>0) has_secondary_table=1
    if (index(u,"MOVEM.L (A7)+,D6-D7")>0 || index(u,"MOVEM.L (A7)+,D6/D7")>0) has_restore=1
    if (u=="RTS") has_rts=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_LINK="has_link
    print "HAS_SAVE="has_save
    print "HAS_MODE1="has_mode1
    print "HAS_PRIMARY_COUNT="has_primary_count
    print "HAS_PRIMARY_TABLE="has_primary_table
    print "HAS_MODE2="has_mode2
    print "HAS_SECONDARY_COUNT="has_secondary_count
    print "HAS_SECONDARY_TABLE="has_secondary_table
    print "HAS_RESTORE="has_restore
    print "HAS_RTS="has_rts
}
