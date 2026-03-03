BEGIN {h1=0;h2=0;h3=0;h4=0;h5=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
    l=t($0)
    if(l=="") next
    if(l~/^DISKIO_FORCEUIREFRESHIFIDLE:/) h1=1
    if(l~/^TST\.W GLOBAL_UIBUSYFLAG$/) h2=1
    if(l~/^MOVE\.W #\$100,ESQPARS2_READMODEFLAGS$/) h3=1
    if(l~/^JSR GROUP_AG_JMPTBL_TEXTDISP_RESETSELECTIONANDREFRESH(\(PC\))?$/) h4=1
    if(l~/^RTS$/) h5=1
}
END{
    print "HAS_ENTRY=" h1
    print "HAS_GUARD=" h2
    print "HAS_SETFLAG=" h3
    print "HAS_REFRESH_CALL=" h4
    print "HAS_RTS=" h5
}
