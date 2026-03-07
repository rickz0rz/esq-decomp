BEGIN{
    h_btst0=0
    h_btst2=0
    h_ret0=0
    h_ret1=0
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
    if(l~/BTST #\$?0,40\(A3\)/ || l~/BTST #\$?0,\$28\(A[0-7]\)/)h_btst0=1
    if(l~/BTST #\$?2,40\(A3\)/ || l~/BTST #\$?2,\$28\(A[0-7]\)/)h_btst2=1
    if(l~/MOVEQ(\.L)? #\$?0,D0/)h_ret0=1
    if(l~/MOVEQ(\.L)? #\$?1,D0/)h_ret1=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_BTST_BIT0=" h_btst0
    print "HAS_BTST_BIT2=" h_btst2
    print "HAS_RET0_PATH=" h_ret0
    print "HAS_RET1_PATH=" h_ret1
    print "HAS_RTS=" h_rts
}
