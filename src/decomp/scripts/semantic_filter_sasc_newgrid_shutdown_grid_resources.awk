BEGIN {
    has_entry=0
    has_dealloc_call=0
    has_freebuffers_call=0
    has_disptext_free_call=0
    has_reset_buckets_call=0
    has_main_rast_ptr=0
    has_grid_init_flag=0
    has_const100=0
    has_const148=0
    has_return=0
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

    if (u ~ /^NEWGRID_SHUTDOWNGRIDRESOURCES:/ || u ~ /^NEWGRID_SHUTDOWNGRIDRES[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDJMPTBLMEMORYDEALLOCATEMEMORY/ || n ~ /NEWGRIDJMPTBLMEMORYDEALLOC/) has_dealloc_call=1
    if (n ~ /NEWGRID2FREEBUFFERSIFALLOCATED/ || n ~ /NEWGRID2FREEBUFFERSIFALLOCA/) has_freebuffers_call=1
    if (n ~ /NEWGRIDJMPTBLDISPTEXTFREEBUFFERS/ || n ~ /NEWGRIDJMPTBLDISPTEXTFREEBU/) has_disptext_free_call=1
    if (n ~ /NEWGRIDRESETSHOWTIMEBUCKETS/ || n ~ /NEWGRIDRESETSHOWTIMEBUCKE/) has_reset_buckets_call=1
    if (n ~ /NEWGRIDMAINRASTPORTPTR/ || n ~ /NEWGRIDMAINRASTPORTP/) has_main_rast_ptr=1
    if (n ~ /NEWGRIDGRIDRESOURCESINITIALIZEDFLAG/ || n ~ /NEWGRIDGRIDRESOURCESINIT/) has_grid_init_flag=1
    if (u ~ /#100([^0-9]|$)/ || u ~ /#\$64/ || u ~ /100\.[Ww]/ || u ~ /\(\$64\)\.[Ww]/) has_const100=1
    if (u ~ /#148([^0-9]|$)/ || u ~ /#\$94/ || u ~ /148\.[Ww]/ || u ~ /\(\$94\)\.[Ww]/) has_const148=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DEALLOC_CALL="has_dealloc_call
    print "HAS_FREEBUFFERS_CALL="has_freebuffers_call
    print "HAS_DISPTEXT_FREE_CALL="has_disptext_free_call
    print "HAS_RESET_BUCKETS_CALL="has_reset_buckets_call
    print "HAS_MAINRAST_GLOBAL="has_main_rast_ptr
    print "HAS_GRIDFLAG_GLOBAL="has_grid_init_flag
    print "HAS_CONST_100="has_const100
    print "HAS_CONST_148="has_const148
    print "HAS_RETURN="has_return
}
