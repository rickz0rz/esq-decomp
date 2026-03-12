BEGIN{
    h_entry=0
    h_set40=0
    h_set41=0
    h_set42=0
    h_default_src=0
    h_copy_loop=0
    h_set46=0
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
    if(l~/^ESQSHARED_INITENTRYDEFAULTS:/ || l~/^ESQSHARED_INITENTRYDEFA[A-Z0-9_]*:/)h_entry=1
    if(l~/^MOVE\.B #\$?2,(40|\$28)\(A[0-7]\)$/)h_set40=1
    if((l~/^MOVEQ(\.L)? #\-1,D[0-7]$/ || l~/^MOVEQ(\.L)? #\$?-1,D[0-7]$/ || l~/^MOVEQ(\.L)? #\$?FF,D[0-7]$/) || l~/^MOVE\.B D[0-7],(41|\$29)\(A[0-7]\)$/)h_set41=1
    if(l~/^MOVE\.B D[0-7],(42|\$2A)\(A[0-7]\)$/ || l~/^MOVE\.B #\$?FF,(42|\$2A)\(A[0-7]\)$/)h_set42=1
    if(l~/ESQPARS_DEFAULTENTRYCODESTRING/)h_default_src=1
    if(l~/^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/ || l~/^MOVE\.B \(A[0-7]\),\(A[0-7]\)\+$/ || l~/^MOVE\.B \(A[0-7]\)\+,D[0-7]$/)h_copy_loop=1
    if(l~/^MOVE\.W #\$?3,(46|\$2E)\(A[0-7]\)$/ || l~/^MOVE\.W #\$?3,\(A[0-7]\)$/)h_set46=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY=" h_entry
    print "HAS_SET_BYTE_40=" h_set40
    print "HAS_SET_BYTE_41=" h_set41
    print "HAS_SET_BYTE_42=" h_set42
    print "HAS_DEFAULT_STRING_SRC=" h_default_src
    print "HAS_COPY_LOOP=" h_copy_loop
    print "HAS_SET_WORD_46=" h_set46
    print "HAS_RTS=" h_rts
}
