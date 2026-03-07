BEGIN{
    h_entry=0
    h_loop_bound=0
    h_find=0
    h_glyph=0
    h_table=0
    h_strlen=0
    h_tail_strlen=0
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
    if(l~/^ESQSHARED_REPLACEMOVIERATINGTOKEN:/ || l~/^ESQSHARED_REPLACEMOVIERATINGTOKE[A-Z0-9_]*:/)h_entry=1
    if(l~/^MOVEQ(\.L)? #\$?7,D[0-7]$/ || l~/^CMP\.[WL] D[0-7],D[0-7]$/)h_loop_bound=1
    if(l~/(JSR|BSR).*FINDSUBSTRIN/ || l~/(JSR|BSR).*FINDSUBSTRINGCASE/)h_find=1
    if(l~/ESQPARS2_MOVIERATINGTOKE[N]?GLYPHMA[P]?/ || l~/ESQPARS2_MOVIERATINGTOKENGLYPHMAP/)h_glyph=1
    if(l~/GLOBAL_TBL_MOVIE_RATINGS/)h_table=1
    if(l~/^TST\.B \(A[0-7]\)\+$/ || l~/^TST\.B \$0\(A[0-7],D[0-7]\.[WL]\)$/)h_strlen=1
    if(l~/^TST\.B \(A[0-7]\)\+$/ || l~/^TST\.B \$0\(A[0-7],D[0-7]\.[WL]\)$/)h_tail_strlen=1
    if(l~/(JSR|BSR).*_LVOCOPYMEM/ || l~/(JSR|BSR).*COPYMEM/)h_copy=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY=" h_entry
    print "HAS_LOOP_BOUND=" h_loop_bound
    print "HAS_FIND_CALL=" h_find
    print "HAS_GLYPH_MAP=" h_glyph
    print "HAS_RATING_TABLE=" h_table
    print "HAS_TOKEN_LEN_SCAN=" h_strlen
    print "HAS_TAIL_LEN_SCAN=" h_tail_strlen
    print "HAS_COPYMEM_CALL=" h_copy
    print "HAS_RTS=" h_rts
}
