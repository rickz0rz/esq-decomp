BEGIN{h_call=0}
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
    if(l~/(JMP|JSR|BSR).*ESQPARS_REPLACEOWNEDSTRING/)h_call=1
}
END{
    print "HAS_FORWARD_TO_ESQPARS_REPLACEOWNEDSTRING=" h_call
}
