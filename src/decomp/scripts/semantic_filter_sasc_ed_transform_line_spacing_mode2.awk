BEGIN{
    h_mulu=0
    h_copy_pad=0
    h_right_scan=0
    h_left_scan=0
    h_fill_write=0
    h_scratch_write=0
    h_live_write=0
    h_tail_copy=0
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

    if(l~/(JSR|BSR).*ESQIFF_JMPTBL_MATH_MULU32/)h_mulu=1
    if(l~/(JSR|BSR).*ESQFUNC_JMPTBL_STRING_COPYPADNUL/)h_copy_pad=1

    if((l~/MOVEQ(\.L)? #\$?27,D[0-7]/) && l~/SUB\.L D7,D1/)h_right_scan=1
    if((l~/MOVEQ(\.L)? #\$?20,D[0-7]/) && (l~/CMP\.B .*D[0-7]/ || l~/CMP\.B .*#\$?20/))h_left_scan=1
    if((l~/MOVE\.B \$[0-9A-F]+\(A7\),\$[0-9A-F]+\(A7,D[0-7]\.L\)/) || (l~/MOVE\.B \(A0\),-90\(A5,D[067]\.L\)/))h_fill_write=1

    if(l~/ED_EDITBUFFERSCRATCH/)h_scratch_write=1
    if(l~/ED_EDITBUFFERLIVE/)h_live_write=1
    if(l~/MOVEQ(\.L)? #\$?28,D0/ && l~/SUB\.L D7,D0/)h_tail_copy=1

    if(l=="RTS")h_rts=1
}
END{
    print "HAS_MULU32_CALL=" h_mulu
    print "HAS_COPY_PAD_NUL_CALL=" h_copy_pad
    print "HAS_RIGHT_SPACE_SCAN=" h_right_scan
    print "HAS_LEFT_SPACE_SCAN=" h_left_scan
    print "HAS_FILL_CHAR_WRITE=" h_fill_write
    print "TOUCHES_SCRATCH_BUFFER=" h_scratch_write
    print "TOUCHES_LIVE_BUFFER=" h_live_write
    print "HAS_TAIL_COPY_SPLIT=" h_tail_copy
    print "HAS_RTS=" h_rts
}
