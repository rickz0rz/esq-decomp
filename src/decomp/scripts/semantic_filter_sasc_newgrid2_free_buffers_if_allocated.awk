BEGIN {
    has_entry=0
    has_scratch_ptr=0
    has_cache_ptr=0
    dealloc_calls=0
    clear_scratch=0
    clear_cache=0
    has_1000=0
    has_1208=0
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

    if (u ~ /^NEWGRID2_FREEBUFFERSIFALLOCATED:/ || u ~ /^NEWGRID2_FREEBUFFERSIFALLOCAT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDENTRYTEXTSCRATCHPTR/) has_scratch_ptr=1
    if (n ~ /NEWGRIDSECONDARYINDEXCACHEPTR/) has_cache_ptr=1
    if ((u ~ /^(JSR|BSR|JMP)(\.[A-Z])?[ \t]/) && n ~ /SCRIPTJMPTBLMEMORYDEALLOCATEM/) dealloc_calls++
    if (u ~ /^CLR\.L NEWGRID_ENTRYTEXTSCRATCHPTR(\(A4\))?$/ || u ~ /^MOVE\.L #0,NEWGRID_ENTRYTEXTSCRATCHPTR(\(A4\))?$/) clear_scratch=1
    if (u ~ /^CLR\.L NEWGRID_SECONDARYINDEXCACHEPTR(\(A4\))?$/ || u ~ /^MOVE\.L #0,NEWGRID_SECONDARYINDEXCACHEPTR(\(A4\))?$/) clear_cache=1
    if (u ~ /#1000([^0-9]|$)/ || u ~ /#\$3E8([^0-9A-F]|$)/ || u ~ /1000\.[WwLl]/ || u ~ /\(\$3E8\)\.[WwLl]/) has_1000=1
    if (u ~ /#1208([^0-9]|$)/ || u ~ /#\$4B8([^0-9A-F]|$)/ || u ~ /1208\.[WwLl]/ || u ~ /\(\$4B8\)\.[WwLl]/) has_1208=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SCRATCH_PTR_GLOBAL="has_scratch_ptr
    print "HAS_CACHE_PTR_GLOBAL="has_cache_ptr
    print "DEALLOC_CALLS="dealloc_calls
    print "HAS_CLEAR_SCRATCH="clear_scratch
    print "HAS_CLEAR_CACHE="clear_cache
    print "HAS_CONST_1000="has_1000
    print "HAS_CONST_1208="has_1208
    print "HAS_RTS="has_rts
}
