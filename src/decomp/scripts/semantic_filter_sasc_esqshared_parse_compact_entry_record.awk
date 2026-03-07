BEGIN{
    h_entry=0
    h_read_group=0
    h_read_slot=0
    h_read_key_loop=0
    h_delim_check=0
    h_key_nul=0
    h_read_mode=0
    h_update_call=0
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
    if(l~/^ESQSHARED_PARSECOMPACTENTRYRECORD:/ || l~/^ESQSHARED_PARSECOMPACTENTRYRECOR[A-Z0-9_]*:/)h_entry=1
    if(l~/^MOVE\.B \(A[0-7]\)\+,D[0-7]$/)h_read_group++
    if(h_read_group>=2)h_read_slot=1
    if(l~/^MOVE\.B D[0-7],-?[0-9]+\((A[0-7]|A5),D[0-7]\.[WL]\)$/ || l~/^MOVE\.B D[0-7],-?[0-9]+\((A5),D[0-7]\.[WL]\)$/ || l~/^MOVE\.B D[0-7],\$[0-9A-F]+\((A[0-7]|A5),D[0-7]\.[WL]\)$/)h_read_key_loop=1
    if(l~/^CMP\.B D[0-7],D[0-7]$/ || l~/^CMP\.B #\$?12,D[0-7]$/ || l~/^MOVEQ(\.L)? #18,D[0-7]$/ || l~/^MOVEQ(\.L)? #\$?12,D[0-7]$/)h_delim_check=1
    if(l~/^CLR\.B -?[0-9]+\((A[0-7]|A5),D[0-7]\.[WL]\)$/ || l~/^CLR\.B \$[0-9A-F]+\((A[0-7]|A5),D[0-7]\.[WL]\)$/ || l~/^MOVE\.B #\$?0,-?[0-9]+\((A[0-7]|A5),D[0-7]\.[WL]\)$/)h_key_nul=1
    if(h_read_group>=3)h_read_mode=1
    if(l~/(JSR|BSR).*UPDATEMATCHINGENTRIESB/ || l~/(JSR|BSR).*UPDATEMATCHINGENTRIESBYTITLE/)h_update_call=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY=" h_entry
    print "HAS_READ_GROUP=" (h_read_group>=1 ? 1 : 0)
    print "HAS_READ_SLOT=" h_read_slot
    print "HAS_KEY_LOOP_STORE=" h_read_key_loop
    print "HAS_DELIM_CHECK=" h_delim_check
    print "HAS_KEY_NUL_TERM=" h_key_nul
    print "HAS_READ_MODE=" h_read_mode
    print "HAS_UPDATE_CALL=" h_update_call
    print "HAS_RTS=" h_rts
}
