BEGIN{
    h_entry=0
    h_load8=0
    h_year1900=0
    h_normalize_call=0
    h_mode_read=0
    h_mode_set=0
    h_write_rtc=0
    h_mode_restore=0
    h_rts=0
}
function t(s, x){
    x=s
    sub(/;.*/,"",x)
    sub(/^[ \t]+/,"",x)
    sub(/[ \t]+$/,"",x)
    gsub(/[ \t]+/," ",x)
    return toupper(x)
}
{
    l=t($0)
    if(l=="")next
    if(l~/^ESQPARS_APPLYRTCBYTESANDPERSIST:/ || l~/^ESQPARS_APPLYRTCBYTESANDPERSI[A-Z0-9_]*:/)h_entry=1
    if(l~/^MOVE\.B \([A][0-7]\),D[0-7]$/ || l~/^MOVE\.B \$[0-9A-F]+\([A][0-7]\),D[0-7]$/ || l~/^MOVE\.B [0-9]+\([A][0-7]\),D[0-7]$/)h_load8++
    if(l~/^ADD(\.W|I\.L) #\$?76C,D[0-7]$/ || l~/^ADD(\.W|I\.L) #1900,D[0-7]$/)h_year1900=1
    if(l~/(JSR|BSR).*NORMALIZECLOCKANDREDRAWB/)h_normalize_call=1
    if(l~/ESQPARS2_READMODEFLAGS/ && l~/MOVE\.W/)h_mode_read=1
    if(l~/^MOVE\.W #\$?100,ESQPARS2_READMODEFLAGS(\(A4\))?$/ || l~/^MOVE\.W #256,ESQPARS2_READMODEFLAGS(\(A4\))?$/)h_mode_set=1
    if(l~/(JSR|BSR).*PARSEINI_WRITERTC/)h_write_rtc=1
    if(l~/^MOVE\.W D[0-7],ESQPARS2_READMODEFLAGS(\(A4\))?$/)h_mode_restore=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY=" h_entry
    print "HAS_BYTE_LOADS=" (h_load8>=8 ? 1 : 0)
    print "HAS_YEAR_PLUS_1900=" h_year1900
    print "HAS_NORMALIZE_CALL=" h_normalize_call
    print "HAS_MODE_READ=" h_mode_read
    print "HAS_MODE_SET_256=" h_mode_set
    print "HAS_WRITE_RTC_CALL=" h_write_rtc
    print "HAS_MODE_RESTORE=" h_mode_restore
    print "HAS_RTS=" h_rts
}
