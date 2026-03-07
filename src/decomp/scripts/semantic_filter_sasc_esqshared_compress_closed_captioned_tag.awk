BEGIN{
    h_entry=0
    h_find=0
    h_guard=0
    h_pipe=0
    h_src_offset=0
    h_copy=0
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
    if(l~/^ESQSHARED_COMPRESSCLOSEDCAPTIONEDTAG:/ || l~/^ESQSHARED_COMPRESSCLOSEDCAPTIONE[A-Z0-9_]*:/)h_entry=1
    if(l~/(JSR|BSR).*FINDSUBSTRIN/ || l~/(JSR|BSR).*FINDSUBSTRINGCASEFOLD/ || l~/(JSR|BSR).*FINDSUBSTRINGCASE/)h_find=1
    if(l~/^TST\.L D[0-7]$/ || l~/^TST\.L A[0-7]$/ || l~/^BEQ\.[SWB] \./)h_guard=1
    if(l~/^MOVE\.B #\$?7C,\(A[0-7]\)\+$/ || l~/^MOVE\.B #124,\(A[0-7]\)\+$/ || l~/^MOVE\.B #\$?7C,\(A[0-7]\)$/ || l~/^MOVE\.B #124,\(A[0-7]\)$/)h_pipe=1
    if(l~/^LEA 3\(A[0-7]\),A[0-7]$/ || l~/^LEA \$3\(A[0-7]\),A[0-7]$/ || l~/^LEA 4\(A[0-7]\),A[0-7]$/ || l~/^LEA \$4\(A[0-7]\),A[0-7]$/ || l~/^ADDI?\.L #\$?4,A[0-7]$/)h_src_offset=1
    if(l~/(JSR|BSR).*COPYMEM/)h_copy=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY=" h_entry
    print "HAS_FIND_CALL=" h_find
    print "HAS_NULL_GUARD=" h_guard
    print "HAS_PIPE_MARKER_WRITE=" h_pipe
    print "HAS_SRC_PLUS4_SETUP=" h_src_offset
    print "HAS_COPYMEM_CALL=" h_copy
    print "HAS_RTS=" h_rts
}
