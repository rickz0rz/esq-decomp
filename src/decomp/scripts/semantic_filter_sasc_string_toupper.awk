BEGIN {h_entry=0; h_low=0; h_high=0; h_sub=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
    l=t($0)
    if(l=="") next
    if(l~/^STRING_TOUPPERCHAR:/) h_entry=1
    if(l~/(CMPI?\.B #'A'|CMPI?\.B #'a'|MOVEQ\.L #\$61,D0)/) h_low=1
    if(l~/(CMPI?\.B #'Z'|CMPI?\.B #'z'|MOVEQ\.L #\$7A,D0)/) h_high=1
    if(l~/^SUBI\.B #\$20,D[067]$/) h_sub=1
    if(l~/^RTS$/) h_rts=1
}
END {
    print "HAS_ENTRY=" h_entry
    print "HAS_LOW_CHECK=" h_low
    print "HAS_HIGH_CHECK=" h_high
    print "HAS_SUB20=" h_sub
    print "HAS_RTS=" h_rts
}
