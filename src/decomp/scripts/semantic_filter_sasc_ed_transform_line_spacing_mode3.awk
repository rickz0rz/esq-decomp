BEGIN{
    h_mulu=0
    h_copy_pad=0
    h_lead_scan=0
    h_trail_scan=0
    h_space_cmp=0
    h_half_gap=0
    h_swap_case=0
    h_scratch_write=0
    h_live_write=0
    h_suffix_write=0
    h_tail_write=0
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

    if(l~/MOVEQ(\.L)? #(\$?20|32),D[0-7]/)h_space_cmp=1
    if(l~/CMP\.B .*D5\.L\),D0/ || l~/CMP\.B -49\(A5,D7\.L\),D0/)h_lead_scan=1
    if(l~/CMP\.B .*D1\.L\),D2/)h_trail_scan=1
    if(l~/ASR\.L #\$?1,D0/)h_half_gap=1
    if(l~/ED_LINETRANSFORMSUFFIXSCRATCHBUF/ || l~/ED_LINETRANSFORMTAILSCRATCHBUFFE/)h_swap_case=1

    if(l~/ED_EDITBUFFERSCRATCH/)h_scratch_write=1
    if(l~/ED_EDITBUFFERLIVE/)h_live_write=1
    if(l~/ED_LINETRANSFORMSUFFIXSCRATCHBUF/ || l~/ED_LINETRANSFORMSUFFIXSCRATCHBUFFER/)h_suffix_write=1
    if(l~/ED_LINETRANSFORMTAILSCRATCHBUFFE/ || l~/ED_LINETRANSFORMTAILSCRATCHBUFFER/)h_tail_write=1

    if(l=="RTS")h_rts=1
}
END{
    print "HAS_MULU32_CALL=" h_mulu
    print "HAS_COPY_PAD_NUL_CALL=" h_copy_pad
    print "HAS_LEADING_SCAN=" (h_lead_scan && h_space_cmp ? 1 : 0)
    print "HAS_TRAILING_SCAN=" (h_trail_scan && h_space_cmp ? 1 : 0)
    print "HAS_HALF_GAP_SHIFT=" h_half_gap
    print "HAS_SWAP_SPACING_PATH=" h_swap_case
    print "TOUCHES_SCRATCH_BUFFER=" h_scratch_write
    print "TOUCHES_LIVE_BUFFER=" h_live_write
    print "TOUCHES_SUFFIX_BUFFER=" h_suffix_write
    print "TOUCHES_TAIL_BUFFER=" h_tail_write
    print "HAS_RTS=" h_rts
}
