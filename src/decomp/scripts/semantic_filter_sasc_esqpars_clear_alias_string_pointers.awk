BEGIN{
    h_alias_count=0
    h_alias_table=0
    h_replace=0
    h_free=0
    h_clear_slot=0
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
    if(l~/TEXTDISP_ALIASCOUNT/)h_alias_count=1
    if(l~/TEXTDISP_ALIASPTRTABLE/)h_alias_table=1
    if(l~/(JSR|BSR).*ESQPARS_REPLACEOWNEDSTRING/)h_replace=1
    if(l~/(JSR|BSR).*ESQIFF_JMPTBL_MEMORY_DEALLOCATEM/ || l~/(JSR|BSR).*ESQIFF_JMPTBL_MEMORY_DEALLOCATEMEMORY/)h_free=1
    if(l~/CLR\.L \(A0\)/ || l~/CLR\.L \$0\(A0,D0\.L\)/ || l~/MOVE\.L #\$?0,\(A0\)/)h_clear_slot=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ALIAS_COUNT_LOOP=" h_alias_count
    print "HAS_ALIAS_TABLE_ACCESS=" h_alias_table
    print "HAS_REPLACEOWNEDSTRING_CALL=" h_replace
    print "HAS_DEALLOCATE_CALL=" h_free
    print "HAS_TABLE_SLOT_CLEAR=" h_clear_slot
    print "HAS_RTS=" h_rts
}
