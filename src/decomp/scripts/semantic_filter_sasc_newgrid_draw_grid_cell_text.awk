BEGIN{h_entry=0;h_secondary_merge=0;h_layout=0;h_pen=0;h_drmd=0;h_trim=0;h_textlen=0;h_move=0;h_text=0;h_modecheck=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l ~ /^NEWGRID_DRAWGRIDCELLTEXT:/ || l ~ /^NEWGRID_DRAWGRIDCELLTEXT[A-Z0-9_]*:/)h_entry=1
    if(l ~ /(JSR|BSR).*STRING_APPENDATNULL/ || l ~ /APPENDATN/ || l ~ /#\$2D/)h_secondary_merge=1
    if(l ~ /SAMPLETIMETEXTWIDTHPX/ || l ~ /ROWHEIGHTPX/ || l ~ /ASR\.L #1/)h_layout=1
    if(l ~ /(JSR|BSR).*LVOSETAPEN/ || l ~ /LVOSETAPEN/ || l ~ /GCOMMAND_NICHETEXTPEN/)h_pen=1
    if(l ~ /(JSR|BSR).*LVOSETDRMD/ || l ~ /LVOSETDRMD/)h_drmd=1
    if(l ~ /#\$20/ || l ~ /TRAILING SPACE/ || l ~ /SUBQ\.L #1,D6/ || l ~ /TRIM_LEN/)h_trim=1
    if(l ~ /(JSR|BSR).*LVOTEXTLENGTH/ || l ~ /_LVOTEXTLENGTH/)h_textlen=1
    if(l ~ /(JSR|BSR).*LVOMOVE/ || l ~ /_LVOMOVE/)h_move=1
    if(l ~ /(JSR|BSR).*LVOTEXT/ || l ~ /_LVOTEXT/)h_text=1
    if(l ~ /CTASKS_STR_C/ || l ~ /#\$53/)h_modecheck=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY="h_entry
    print "HAS_SECONDARY_MERGE="h_secondary_merge
    print "HAS_LAYOUT_MATH="h_layout
    print "HAS_SET_PEN="h_pen
    print "HAS_SET_DRMD="h_drmd
    print "HAS_TRIM="h_trim
    print "HAS_TEXT_LENGTH="h_textlen
    print "HAS_MOVE="h_move
    print "HAS_TEXT_DRAW="h_text
    print "HAS_MODE_CHECK="h_modecheck
    print "HAS_RTS="h_rts
}
