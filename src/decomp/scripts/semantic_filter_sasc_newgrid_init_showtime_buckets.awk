BEGIN {
    has_entry=0
    has_ptr_table=0
    has_entry_table=0
    has_const10=0
    has_const8=0
    has_const4=0
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

    if (u ~ /^NEWGRID_INITSHOWTIMEBUCKETS:/) has_entry=1
    if (n ~ /NEWGRIDSHOWTIMEBUCKETPTRTABLE/ || n ~ /NEWGRIDSHOWTIMEBUCKETPTRTABL/) has_ptr_table=1
    if (n ~ /NEWGRIDSHOWTIMEBUCKETENTRYTABLE/ || n ~ /NEWGRIDSHOWTIMEBUCKETENTRYTABL/) has_entry_table=1
    if (u ~ /#10([^0-9]|$)/ || u ~ /#\$0A/ || u ~ /#\$A([^0-9A-F]|$)/ || u ~ /10\.[Ww]/ || u ~ /\(\$A\)/) has_const10=1
    if (u ~ /#8([^0-9]|$)/ || u ~ /#\$08/ || u ~ /#\$8([^0-9A-F]|$)/ || u ~ /8\.[Ww]/ || u ~ /ASL\.L #3/ || u ~ /ASL\.L #\$3/) has_const8=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /4\.[Ww]/ || u ~ /4\(A/) has_const4=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_PTR_TABLE_GLOBAL="has_ptr_table
    print "HAS_ENTRY_TABLE_GLOBAL="has_entry_table
    print "HAS_CONST_10="has_const10
    print "HAS_CONST_8="has_const8
    print "HAS_CONST_4="has_const4
    print "HAS_RTS="has_rts
}
