BEGIN {
    has_label=0; has_save=0; has_timeword=0; has_scale=0; has_norm=0; has_restore=0; has_rts=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^ESQDISP_COMPUTESCHEDULEOFFSETFORROW:/) has_label=1
    if (index(u,"MOVEM.L D5-D7,-(A7)")>0 || index(u,"MOVEM.L D5/D6/D7,-(A7)")>0) has_save=1
    if (index(u,"DST_BUILDBANNERTIMEWORD(PC)")>0) has_timeword=1
    if (index(u,"ADD.L D1,D1")>0 && index(u,"MOVE.L D7,D0")>0) has_scale=1
    if (index(u,"DISPLIB_NORMALIZEVALUEBYSTEP(PC)")>0 && index(u,"PEA 48.W")>0 && index(u,"PEA 1.W")>0) has_norm=1
    if (index(u,"MOVEM.L (A7)+,D5-D7")>0 || index(u,"MOVEM.L (A7)+,D5/D6/D7")>0) has_restore=1
    if (u=="RTS") has_rts=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_SAVE="has_save
    print "HAS_TIMEWORD="has_timeword
    print "HAS_SCALE="has_scale
    print "HAS_NORM="has_norm
    print "HAS_RESTORE="has_restore
    print "HAS_RTS="has_rts
}
