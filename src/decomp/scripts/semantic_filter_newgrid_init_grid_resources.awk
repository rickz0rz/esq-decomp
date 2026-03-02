BEGIN {
    label=0; ensure=0; initbuf=0; initbucket=0; alloc=0; initrast=0; setdr=0; setfont=0; textlen=0; div=0; topborder=0;
    gridflag=0; mainrp=0; headrp=0; colstart=0; colw=0; rowh=0; c99=0; c100=0; c112=0; c624=0; c12=0; c8=0; c3=0; c2=0; rts=0
}

/^NEWGRID_InitGridResources:$/ { label=1 }
/NEWGRID2_EnsureBuffersAllocated/ { ensure=1 }
/NEWGRID_JMPTBL_DISPTEXT_InitBuffers/ { initbuf=1 }
/NEWGRID_InitShowtimeBuckets/ { initbucket=1 }
/NEWGRID_JMPTBL_MEMORY_AllocateMemory/ { alloc=1 }
/LVOInitRastPort|_LVOInitRastPort/ { initrast=1 }
/LVOSetDrMd|_LVOSetDrMd/ { setdr=1 }
/LVOSetFont|_LVOSetFont/ { setfont=1 }
/LVOTextLength|_LVOTextLength/ { textlen=1 }
/NEWGRID_JMPTBL_MATH_DivS32/ { div=1 }
/NEWGRID_DrawTopBorderLine/ { topborder=1 }
/NEWGRID_GridResourcesInitializedFlag/ { gridflag=1 }
/NEWGRID_MainRastPortPtr/ { mainrp=1 }
/NEWGRID_HeaderRastPortPtr/ { headrp=1 }
/NEWGRID_ColumnStartXPx/ { colstart=1 }
/NEWGRID_ColumnWidthPx/ { colw=1 }
/NEWGRID_RowHeightPx/ { rowh=1 }
/#99([^0-9]|$)|#\$63|99\.[Ww]/ { c99=1 }
/#100([^0-9]|$)|#\$64|100\.[Ww]/ { c100=1 }
/#112([^0-9]|$)|#\$70|112\.[Ww]/ { c112=1 }
/#624|#\$270|624\.[Ww]/ { c624=1 }
/#12([^0-9]|$)|#\$0c|12\.[Ww]/ { c12=1 }
/#8([^0-9]|$)|#\$08|8\.[Ww]/ { c8=1 }
/#3([^0-9]|$)|#\$03|3\.[Ww]/ { c3=1 }
/#2([^0-9]|$)|#\$02|2\.[Ww]/ { c2=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (ensure) print "HAS_ENSURE_CALL"
    if (initbuf) print "HAS_INITBUFFERS_CALL"
    if (initbucket) print "HAS_INITBUCKETS_CALL"
    if (alloc) print "HAS_ALLOCATE_CALL"
    if (initrast) print "HAS_INITRAST_CALL"
    if (setdr) print "HAS_SETDRMD_CALL"
    if (setfont) print "HAS_SETFONT_CALL"
    if (textlen) print "HAS_TEXTLENGTH_CALL"
    if (div) print "HAS_DIV_CALL"
    if (topborder) print "HAS_TOPBORDER_CALL"
    if (gridflag) print "HAS_GRIDFLAG_GLOBAL"
    if (mainrp) print "HAS_MAINRAST_GLOBAL"
    if (headrp) print "HAS_HEADERRAST_GLOBAL"
    if (colstart) print "HAS_COLSTART_GLOBAL"
    if (colw) print "HAS_COLWIDTH_GLOBAL"
    if (rowh) print "HAS_ROWHEIGHT_GLOBAL"
    if (c99) print "HAS_CONST_99"
    if (c100) print "HAS_CONST_100"
    if (c112) print "HAS_CONST_112"
    if (c624) print "HAS_CONST_624"
    if (c12) print "HAS_CONST_12"
    if (c8) print "HAS_CONST_8"
    if (c3) print "HAS_CONST_3"
    if (c2) print "HAS_CONST_2"
    if (rts) print "HAS_RTS"
}
