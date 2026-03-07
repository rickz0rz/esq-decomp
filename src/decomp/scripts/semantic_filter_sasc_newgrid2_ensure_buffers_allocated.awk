BEGIN {
    has_entry=0
    has_alloc_flag=0
    alloc_calls=0
    has_rebuild_call=0
    has_cache_ptr=0
    has_scratch_ptr=0
    has_flag_clear=0
    has_1208=0
    has_1000=0
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

    if (u ~ /^NEWGRID2_ENSUREBUFFERSALLOCATED:/ || u ~ /^NEWGRID2_ENSUREBUFFERSALLOCAT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2BUFFERALLOCATIONFLAG/) has_alloc_flag=1
    if ((u ~ /^(JSR|BSR|JMP)(\.[A-Z])?[ \t]/) && n ~ /SCRIPTJMPTBLMEMORYALLOCATEMEM/) alloc_calls++
    if (n ~ /NEWGRIDREBUILDINDEXCACHE/) has_rebuild_call=1
    if (n ~ /NEWGRIDSECONDARYINDEXCACHEPTR/) has_cache_ptr=1
    if (n ~ /NEWGRIDENTRYTEXTSCRATCHPTR/) has_scratch_ptr=1
    if ((u ~ /^CLR\.L NEWGRID2_BUFFERALLOCATIONFLAG(\(A4\))?$/) || (u ~ /^MOVE\.L #0,NEWGRID2_BUFFERALLOCATIONFLAG(\(A4\))?$/) || (u ~ /^MOVEQ #0,D[0-7]$/ && n ~ /NEWGRID2BUFFERALLOCATIONFLAG/)) has_flag_clear=1
    if (u ~ /#1208([^0-9]|$)/ || u ~ /#\$4B8([^0-9A-F]|$)/ || u ~ /1208\.[WwLl]/ || u ~ /\(\$4B8\)\.[WwLl]/) has_1208=1
    if (u ~ /#1000([^0-9]|$)/ || u ~ /#\$3E8([^0-9A-F]|$)/ || u ~ /1000\.[WwLl]/ || u ~ /\(\$3E8\)\.[WwLl]/) has_1000=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_ALLOC_FLAG="has_alloc_flag
    print "ALLOC_CALLS="alloc_calls
    print "HAS_REBUILD_CALL="has_rebuild_call
    print "HAS_CACHE_PTR_GLOBAL="has_cache_ptr
    print "HAS_SCRATCH_PTR_GLOBAL="has_scratch_ptr
    print "HAS_FLAG_CLEAR="has_flag_clear
    print "HAS_CONST_1208="has_1208
    print "HAS_CONST_1000="has_1000
    print "HAS_RTS="has_rts
}
