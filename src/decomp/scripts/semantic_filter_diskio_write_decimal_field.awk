BEGIN {h1=0;h2=0;h3=0;h4=0;h5=0;h6=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
    l=t($0)
    if(l=="") next
    if(l~/^DISKIO_WRITEDECIMALFIELD:/) h1=1
    if(l~/^JSR GROUP_AE_JMPTBL_WDISP_SPRINTF\(PC\)$/) h2=1
    if(l~/^TST\.B \(A1\)\+$/) h3=1
    if(l~/^BSR\.W DISKIO_WRITEBUFFEREDBYTES$/) h4=1
    if(l~/^UNLK A5$/) h5=1
    if(l~/^RTS$/) h6=1
}
END{
    print "HAS_ENTRY=" h1
    print "HAS_SPRINTF=" h2
    print "HAS_SCAN_LOOP=" h3
    print "HAS_WRITECALL=" h4
    print "HAS_UNLK=" h5
    print "HAS_RTS=" h6
}
