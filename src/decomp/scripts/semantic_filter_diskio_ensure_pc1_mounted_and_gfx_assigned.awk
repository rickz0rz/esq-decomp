BEGIN {h1=0;h2=0;h3=0;h4=0;h5=0;h6=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
    l=t($0)
    if(l=="") next
    if(l~/^DISKIO_ENSUREPC1MOUNTEDANDGFXASSIGNED:/) h1=1
    if(l~/^MOVEM\.L D2-D3,-\(A7\)$/) h2=1
    if(l~/^TST\.W DISKIO_PC1MOUNTASSIGNFLAG$/) h3=1
    if(l~/^MOVE\.W #1,DISKIO_PC1MOUNTASSIGNFLAG$/) h4=1
    if(l~/^JSR _LVOEXECUTE\(A6\)$/) h5=1
    if(l~/^RTS$/) h6=1
}
END{
    print "HAS_ENTRY=" h1
    print "HAS_SAVE=" h2
    print "HAS_GUARD=" h3
    print "HAS_SETFLAG=" h4
    print "HAS_EXECUTE=" h5
    print "HAS_RTS=" h6
}
