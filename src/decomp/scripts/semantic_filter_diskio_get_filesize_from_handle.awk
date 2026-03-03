BEGIN {h1=0;h2=0;h3=0;h4=0;h5=0;h6=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
    l=t($0)
    if(l=="") next
    if(l~/^DISKIO_GETFILESIZEFROMHANDLE:/) h1=1
    if(l~/^MOVEM\.L D2-D3\/D6-D7,-\(A7\)$/) h2=1
    if(l~/^JSR _LVOSEEK\(A6\)$/) h3=1
    if(l~/^MOVE\.L D0,D6$/) h4=1
    if(l~/^MOVE\.L D6,D0$/) h5=1
    if(l~/^RTS$/) h6=1
}
END{
    print "HAS_ENTRY=" h1
    print "HAS_SAVE_RESTORE=" h2
    print "HAS_SEEK_CALL=" h3
    print "HAS_CAPTURE_SIZE=" h4
    print "HAS_RETURN_SIZE=" h5
    print "HAS_RTS=" h6
}
