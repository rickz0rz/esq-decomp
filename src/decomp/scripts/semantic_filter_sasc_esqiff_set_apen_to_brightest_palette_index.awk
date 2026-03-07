BEGIN{
    h_depth=0
    h_r=0
    h_g=0
    h_b=0
    h_mul3=0
    h_best_update=0
    h_setapen=0
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
    if(l~/WDISP_PALETTEDEPTHLOG2/)h_depth=1
    if(l~/WDISP_PALETTETRIPLESRBASE/)h_r=1
    if(l~/WDISP_PALETTETRIPLESGBASE/)h_g=1
    if(l~/WDISP_PALETTETRIPLESBBASE/)h_b=1
    if(l~/MULS .*#\$?3/ || l~/MULS D1,D0/ || (l~/ADD\.L D1,D1/ || l~/ADD\.L D0,D1/))h_mul3=1
    if(l~/MOVE\.L D7,.*-14\(A5\)/ || l~/MOVE\.L D0,.*-14\(A5\)/ || l~/MOVE\.L D0,D6/)h_best_update=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/ || l~/(JSR|BSR).*SETAPEN/)h_setapen=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_DEPTH_READ=" h_depth
    print "HAS_R_BASE_READ=" h_r
    print "HAS_G_BASE_READ=" h_g
    print "HAS_B_BASE_READ=" h_b
    print "HAS_INDEX_TIMES3=" h_mul3
    print "HAS_BEST_INDEX_UPDATE=" h_best_update
    print "HAS_SETAPEN_CALL=" h_setapen
    print "HAS_RTS=" h_rts
}
