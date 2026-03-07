BEGIN {
    has_entry=0
    has_bucket_count=0
    has_bucket_ptr_table=0
    has_separator=0
    append_calls=0
    has_loop_counter=0
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

    if (u ~ /^NEWGRID_APPENDSHOWTIMEBUCKETS:/ || u ~ /^NEWGRID_APPENDSHOWTIMEBUCKET[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDSHOWTIMEBUCKETCOUNT/) has_bucket_count=1
    if (n ~ /NEWGRIDSHOWTIMEBUCKETPTRTABLE/) has_bucket_ptr_table=1
    if (n ~ /NEWGRIDSHOWTIMEBUCKETSEPARATOR/) has_separator=1
    if ((u ~ /^(JSR|BSR|JMP)(\.[A-Z])?[ \t]/) && n ~ /PARSEINIJMPTBLSTRINGAPPENDATN/) append_calls++
    if (u ~ /ADDQ\.L #1,D[0-7]/ || u ~ /CMP\.L .*D7/) has_loop_counter=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_BUCKET_COUNT_GLOBAL="has_bucket_count
    print "HAS_BUCKET_PTR_TABLE_GLOBAL="has_bucket_ptr_table
    print "HAS_SEPARATOR_GLOBAL="has_separator
    print "APPEND_CALLS="append_calls
    print "HAS_LOOP_COUNTER="has_loop_counter
    print "HAS_RTS="has_rts
}
