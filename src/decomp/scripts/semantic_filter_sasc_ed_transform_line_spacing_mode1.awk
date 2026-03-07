BEGIN{
    h_mulu=0
    h_copy_pad=0
    h_lead_loop=0
    h_tail_loop=0
    h_fill_write=0
    h_scratch_write=0
    h_live_write=0
    h_suffix_write=0
    h_tailbuf_write=0
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

    if((l~/MOVEQ(\.L)? #\$?20,D[0-7]/) && (l~/CMP\.B .*D[0-7]/ || l~/CMP\.B .*#\$?20/))h_lead_loop=1
    if((l~/MOVEQ(\.L)? #\$?27,D[0-7]/) && l~/SUB\.L D4,D1/)h_tail_loop=1
    if((l~/MOVE\.B \$17\(A7\),\$18\(A7,D[0-7]\.L\)/) || (l~/MOVE\.B \(A0\),-90\(A5,D[067]\.L\)/))h_fill_write=1

    if(l~/ED_EDITBUFFERSCRATCH/)h_scratch_write=1
    if(l~/ED_EDITBUFFERLIVE/)h_live_write=1
    if(l~/ED_LINETRANSFORMSUFFIXSCRATCHBUF/ || l~/ED_LINETRANSFORMSUFFIXSCRATCHBUFFER/)h_suffix_write=1
    if(l~/ED_LINETRANSFORMTAILSCRATCHBUFFE/ || l~/ED_LINETRANSFORMTAILSCRATCHBUFFER/)h_tailbuf_write=1

    if(l=="RTS")h_rts=1
}
END{
    print "HAS_MULU32_CALL=" h_mulu
    print "HAS_COPY_PAD_NUL_CALL=" h_copy_pad
    print "HAS_SPACE_SCAN_LOGIC=" h_lead_loop
    print "HAS_TRAILING_SCAN_LOGIC=" h_tail_loop
    print "HAS_FILL_CHAR_WRITE=" h_fill_write
    print "TOUCHES_SCRATCH_BUFFER=" h_scratch_write
    print "TOUCHES_LIVE_BUFFER=" h_live_write
    print "TOUCHES_SUFFIX_BUFFER=" h_suffix_write
    print "TOUCHES_TAIL_BUFFER=" h_tailbuf_write
    print "HAS_RTS=" h_rts
}
