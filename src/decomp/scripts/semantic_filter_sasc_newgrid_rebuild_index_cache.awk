BEGIN {
    has_entry=0
    has_cache_ptr=0
    has_saved_flags=0
    has_set_flags_0100=0
    has_clear_bound_012e=0
    has_store_minus1=0
    has_primary_count=0
    has_entry_call=0
    has_wildcard_call=0
    has_secondary_count=0
    has_cache_store=0
    has_restore_flags=0
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

    if (u ~ /^NEWGRID_REBUILDINDEXCACHE:/ || u ~ /^NEWGRID_REBUILDINDEXCAC[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDSECONDARYINDEXCACHEPTR/) has_cache_ptr=1
    if (n ~ /ESQPARS2READMODEFLAGS/) has_saved_flags=1
    if (u ~ /#\$100/ || u ~ /256\.[Ww]/ || u ~ /MOVE\.W #256/ || u ~ /#256([^0-9]|$)/) has_set_flags_0100=1
    if (u ~ /#\$12E/ || u ~ /302\.[Ww]/ || u ~ /#302([^0-9]|$)/) has_clear_bound_012e=1
    if (u ~ /#-1/ || u ~ /#\$FFFFFFFF/ || u ~ /MOVEQ\.L #\$FF,D0/ || u ~ /MOVEQ #-1/) has_store_minus1=1
    if (n ~ /TEXTDISPPRIMARYGROUPENTRYCOUNT/ || n ~ /TEXTDISPPRIMARYGROUPENTRYCOUN/) has_primary_count=1
    if (n ~ /ESQDISPGETENTRYPOINTERBYMODE/) has_entry_call=1
    if (n ~ /TLIBAFINDFIRSTWILDCARDMATCHINDEX/ || n ~ /TLIBAFINDFIRSTWILDCARDMATCHINDE/) has_wildcard_call=1
    if (n ~ /TEXTDISPSECONDARYGROUPENTRYCOUNT/ || n ~ /TEXTDISPSECONDARYGROUPENTRYCOUN/) has_secondary_count=1
    if (u ~ /^MOVE\.L D6,\(A0\)$/ || u ~ /^MOVE\.L D6,0\(A0,D0\.L\)$/) has_cache_store=1
    if (n ~ /MOVEWD5ESQPARS2READMODEFLAGS/) has_restore_flags=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_CACHE_PTR="has_cache_ptr
    print "HAS_SAVED_FLAGS="has_saved_flags
    print "HAS_SET_FLAGS_0100="has_set_flags_0100
    print "HAS_CLEAR_BOUND_012E="has_clear_bound_012e
    print "HAS_STORE_MINUS1="has_store_minus1
    print "HAS_PRIMARY_COUNT="has_primary_count
    print "HAS_ENTRY_CALL="has_entry_call
    print "HAS_WILDCARD_CALL="has_wildcard_call
    print "HAS_SECONDARY_COUNT="has_secondary_count
    print "HAS_CACHE_STORE="has_cache_store
    print "HAS_RESTORE_FLAGS="has_restore_flags
    print "HAS_RTS="has_rts
}
