BEGIN {h1=0;h2=0;h3=0;h4=0;h5=0;h6=0;h7=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
    l=t($0)
    if(l=="") next
    if(l~/^DISKIO_QUERYVOLUMESOFTERRORCOUNT:/) h1=1
    if(l~/^JSR _LVOLOCK\(A6\)$/) h2=1
    if(l~/^JSR GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY\(PC\)$/) h3=1
    if(l~/^JSR _LVOINFO\(A6\)$/) h4=1
    if(l~/^JSR GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY\(PC\)$/) h5=1
    if(l~/^JSR _LVOUNLOCK\(A6\)$/) h6=1
    if(l~/^RTS$/) h7=1
}
END{
    print "HAS_ENTRY=" h1
    print "HAS_LOCK=" h2
    print "HAS_ALLOC=" h3
    print "HAS_INFO=" h4
    print "HAS_FREE=" h5
    print "HAS_UNLOCK=" h6
    print "HAS_RTS=" h7
}
