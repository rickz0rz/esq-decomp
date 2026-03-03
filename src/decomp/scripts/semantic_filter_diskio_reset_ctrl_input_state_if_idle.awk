BEGIN {h1=0;h2=0;h3=0;h4=0;h5=0;h6=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
    l=t($0)
    if(l=="") next
    if(l~/^DISKIO_RESETCTRLINPUTSTATEIFIDLE:/) h1=1
    if(l~/^TST\.W GLOBAL_UIBUSYFLAG$/) h2=1
    if(l~/^JSR _LVODISABLE\(A6\)$/) h3=1
    if(l~/^JSR _LVOENABLE\(A6\)$/) h4=1
    if(l~/^MOVE\.W D0,ESQPARS2_READMODEFLAGS$/) h5=1
    if(l~/^RTS$/) h6=1
}
END{
    print "HAS_ENTRY=" h1
    print "HAS_GUARD=" h2
    print "HAS_DISABLE=" h3
    print "HAS_ENABLE=" h4
    print "HAS_MODE_RESET=" h5
    print "HAS_RTS=" h6
}
