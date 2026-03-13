BEGIN {
    has_entry=0
    has_bucket_count=0
    has_entry_table=0
    has_replace_owned=0
    has_const10=0
    has_const3100=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^NEWGRID_RESETSHOWTIMEBUCKETS:/) has_entry=1
    if (n ~ /NEWGRIDSHOWTIMEBUCKETCOUNT/) has_bucket_count=1
    if (n ~ /NEWGRIDSHOWTIMEBUCKETENTRYTABLE/ || n ~ /NEWGRIDSHOWTIMEBUCKETENTRYTABL/) has_entry_table=1
    if (n ~ /PARSEINIJMPTBLESQPARSREPLACEOWNEDSTRING/ || n ~ /PARSEINIJMPTBLESQPARSREPLACEOWNEDS/ || n ~ /PARSEINIJMPTBLESQPARSREPLACEO/ || n ~ /ESQPARSREPLACEOWNEDSTRING/ || n ~ /ESQPARSREPLACEOWNEDSTR/) has_replace_owned=1
    if (u ~ /#10([^0-9]|$)/ || u ~ /#\$0A/ || u ~ /#\$A([^0-9A-F]|$)/ || u ~ /10\.[Ww]/ || u ~ /\(\$A\)/) has_const10=1
    if (u ~ /#\$3100/ || u ~ /#12544/ || u ~ /3100/) has_const3100=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_BUCKET_COUNT_GLOBAL="has_bucket_count
    print "HAS_ENTRY_TABLE_GLOBAL="has_entry_table
    print "HAS_REPLACE_OWNED_CALL="has_replace_owned
    print "HAS_CONST_10="has_const10
    print "HAS_CONST_3100="has_const3100
    print "HAS_RTS="has_rts
}
