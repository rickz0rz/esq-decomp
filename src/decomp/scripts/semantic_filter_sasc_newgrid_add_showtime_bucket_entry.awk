BEGIN {
    has_entry=0
    has_bucket_count=0
    has_bucket_entry_table=0
    has_bucket_ptr_table=0
    has_find_char=0
    has_parse_long=0
    has_replace_owned=0
    has_wildcard_insert_loop=0
    has_shift_loop=0
    has_success_flag=0
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

    if (u ~ /^NEWGRID_ADDSHOWTIMEBUCKETENTRY:/ || u ~ /^NEWGRID_ADDSHOWTIMEBUCKETENTR[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDSHOWTIMEBUCKETCOUNT/) has_bucket_count=1
    if (n ~ /NEWGRIDSHOWTIMEBUCKETENTRYTABLE/) has_bucket_entry_table=1
    if (n ~ /NEWGRIDSHOWTIMEBUCKETPTRTABLE/) has_bucket_ptr_table=1
    if (n ~ /PARSEINIJMPTBLSTRFINDCHARPTR/) has_find_char=1
    if (n ~ /SCRIPT3JMPTBLPARSEREADSIGNEDL/) has_parse_long=1
    if (n ~ /PARSEINIJMPTBLESQPARSREPLACEO/) has_replace_owned=1
    if (u ~ /CMP\.L .*D6/ || n ~ /SHOWTIMEBUCKETPTRTABLE/) has_wildcard_insert_loop=1
    if (u ~ /SUBQ\.L #1,D[0-7]/ || n ~ /SHOWTIMEBUCKETPTRTABLE/) has_shift_loop=1
    if (u ~ /MOVEQ #1,D0/ || u ~ /MOVEQ\.L #\$1,D0/) has_success_flag=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_BUCKET_COUNT_GLOBAL="has_bucket_count
    print "HAS_BUCKET_ENTRY_TABLE_GLOBAL="has_bucket_entry_table
    print "HAS_BUCKET_PTR_TABLE_GLOBAL="has_bucket_ptr_table
    print "HAS_FIND_CHAR_CALL="has_find_char
    print "HAS_PARSE_LONG_CALL="has_parse_long
    print "HAS_REPLACE_OWNED_CALL="has_replace_owned
    print "HAS_INSERT_SCAN_HINT="has_wildcard_insert_loop
    print "HAS_SHIFT_LOOP_HINT="has_shift_loop
    print "HAS_SUCCESS_FLAG="has_success_flag
    print "HAS_RTS="has_rts
}
