BEGIN {
    has_entry=0
    has_ensure_call=0
    has_init_buffers_call=0
    has_init_buckets_call=0
    has_alloc_call=0
    has_init_rast_call=0
    has_setdrmd_call=0
    has_setfont_call=0
    has_textlength_call=0
    has_div_call=0
    has_topborder_call=0
    has_grid_init_flag=0
    has_main_rast_ptr=0
    has_header_rast_ptr=0
    has_col_start=0
    has_col_width=0
    has_row_height=0
    has_const99=0
    has_const100=0
    has_const112=0
    has_const624=0
    has_const12=0
    has_const8=0
    has_const3=0
    has_const2=0
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

    if (u ~ /^NEWGRID_INITGRIDRESOURCES:/ || u ~ /^NEWGRID_INITGRIDRESOUR[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2ENSUREBUFFERSALLOCATED/ || n ~ /NEWGRID2ENSUREBUFFERSALLOCA/) has_ensure_call=1
    if (n ~ /NEWGRIDJMPTBLDISPTEXTINITBUFFERS/ || n ~ /NEWGRIDJMPTBLDISPTEXTINITBU/ || n ~ /DISPTEXTINITBUFFERS/) has_init_buffers_call=1
    if (n ~ /NEWGRIDINITSHOWTIMEBUCKETS/) has_init_buckets_call=1
    if (n ~ /NEWGRIDJMPTBLMEMORYALLOCATEMEMORY/ || n ~ /NEWGRIDJMPTBLMEMORYALLOCATE/ || n ~ /MEMORYALLOCATEMEMORY/) has_alloc_call=1
    if (n ~ /LVOINITRASTPORT/) has_init_rast_call=1
    if (n ~ /LVOSETDRMD/) has_setdrmd_call=1
    if (n ~ /LVOSETFONT/) has_setfont_call=1
    if (n ~ /LVOTEXTLENGTH/ || n ~ /TEXTLENGTH/) has_textlength_call=1
    if (n ~ /NEWGRIDJMPTBLMATHDIVS32/ || n ~ /NEWGRIDJMPTBLMATHDIVS/ || n ~ /MATHDIVS32/) has_div_call=1
    if (n ~ /NEWGRIDDRAWTOPBORDERLINE/ || n ~ /NEWGRIDDRAWTOPBORDERL/) has_topborder_call=1
    if (n ~ /NEWGRIDGRIDRESOURCESINITIALIZEDFLAG/ || n ~ /NEWGRIDGRIDRESOURCESINIT/) has_grid_init_flag=1
    if (n ~ /NEWGRIDMAINRASTPORTPTR/ || n ~ /NEWGRIDMAINRASTPORTP/) has_main_rast_ptr=1
    if (n ~ /NEWGRIDHEADERRASTPORTPTR/ || n ~ /NEWGRIDHEADERRASTPORTP/) has_header_rast_ptr=1
    if (n ~ /NEWGRIDCOLUMNSTARTXPX/ || n ~ /NEWGRIDCOLUMNSTARTXP/) has_col_start=1
    if (n ~ /NEWGRIDCOLUMNWIDTHPX/ || n ~ /NEWGRIDCOLUMNWIDTHP/) has_col_width=1
    if (n ~ /NEWGRIDROWHEIGHTPX/ || n ~ /NEWGRIDROWHEIGHTP/) has_row_height=1
    if (u ~ /#99([^0-9]|$)/ || u ~ /#\$63/ || u ~ /99\.[Ww]/ || u ~ /\(\$63\)\.[Ww]/) has_const99=1
    if (u ~ /#100([^0-9]|$)/ || u ~ /#\$64/ || u ~ /100\.[Ww]/ || u ~ /\(\$64\)\.[Ww]/) has_const100=1
    if (u ~ /#112([^0-9]|$)/ || u ~ /#\$70/ || u ~ /112\.[Ww]/ || u ~ /\(\$70\)\.[Ww]/) has_const112=1
    if (u ~ /#624/ || u ~ /#\$270/ || u ~ /624\.[Ww]/ || u ~ /\$270/ || u ~ /#\$4E([^0-9A-F]|$)/ || u ~ /#78([^0-9]|$)/) has_const624=1
    if (u ~ /#12([^0-9]|$)/ || u ~ /#\$0C/ || u ~ /#\$C([^0-9A-F]|$)/ || u ~ /12\.[Ww]/ || u ~ /\(\$c\)\.[Ww]/) has_const12=1
    if (u ~ /#8([^0-9]|$)/ || u ~ /#\$08/ || u ~ /#\$8([^0-9A-F]|$)/ || u ~ /8\.[Ww]/ || u ~ /\(\$8\)\.[Ww]/) has_const8=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /#\$3([^0-9A-F]|$)/ || u ~ /3\.[Ww]/ || u ~ /\(\$3\)\.[Ww]/) has_const3=1
    if (u ~ /#2([^0-9]|$)/ || u ~ /#\$02/ || u ~ /#\$2([^0-9A-F]|$)/ || u ~ /2\.[Ww]/ || u ~ /\(\$2\)\.[Ww]/) has_const2=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_ENSURE_CALL="has_ensure_call
    print "HAS_INITBUFFERS_CALL="has_init_buffers_call
    print "HAS_INITBUCKETS_CALL="has_init_buckets_call
    print "HAS_ALLOCATE_CALL="has_alloc_call
    print "HAS_INITRAST_CALL="has_init_rast_call
    print "HAS_SETDRMD_CALL="has_setdrmd_call
    print "HAS_SETFONT_CALL="has_setfont_call
    print "HAS_TEXTLENGTH_CALL="has_textlength_call
    print "HAS_DIV_CALL="has_div_call
    print "HAS_TOPBORDER_CALL="has_topborder_call
    print "HAS_GRIDFLAG_GLOBAL="has_grid_init_flag
    print "HAS_MAINRAST_GLOBAL="has_main_rast_ptr
    print "HAS_HEADERRAST_GLOBAL="has_header_rast_ptr
    print "HAS_COLSTART_GLOBAL="has_col_start
    print "HAS_COLWIDTH_GLOBAL="has_col_width
    print "HAS_ROWHEIGHT_GLOBAL="has_row_height
    print "HAS_CONST_99="has_const99
    print "HAS_CONST_100="has_const100
    print "HAS_CONST_112="has_const112
    print "HAS_CONST_624="has_const624
    print "HAS_CONST_12="has_const12
    print "HAS_CONST_8="has_const8
    print "HAS_CONST_3="has_const3
    print "HAS_CONST_2="has_const2
    print "HAS_RETURN="has_return
}
