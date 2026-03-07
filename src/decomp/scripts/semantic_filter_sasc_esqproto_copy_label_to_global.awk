BEGIN{
    h_sentinel=0
    h_max10=0
    h_terminator=0
    h_global_copy=0
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
    if(l~/MOVEQ(\.L)? #(\$?12|18),D[0-7]/ || l~/CMPI\.B #(\$?12|18),/ || l~/CMP\.B D1,D0/)h_sentinel=1
    if(l~/MOVEQ(\.L)? #(\$?A|10),D[0-7]/ || l~/CMP\.(W|L) .*#(\$?A|10)/ || l~/CMP\.W D0,D7/)h_max10=1
    if(l~/CLR\.B/ || l~/MOVE\.B #\$?0,/)h_terminator=1
    if(l~/WDISP_STATUSLISTMATCHPATTERN/)h_global_copy=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_SENTINEL_0x12_CHECK=" h_sentinel
    print "HAS_MAXLEN10_CHECK=" h_max10
    print "HAS_NUL_TERMINATOR_WRITE=" h_terminator
    print "HAS_GLOBAL_COPY=" h_global_copy
    print "HAS_RTS=" h_rts
}
