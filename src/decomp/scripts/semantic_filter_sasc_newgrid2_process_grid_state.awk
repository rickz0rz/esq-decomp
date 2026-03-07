BEGIN {
    has_entry=0
    has_render_latch=0
    has_prime_flag=0
    has_set_layout=0
    has_prime_test=0
    has_draw_entry=0
    has_alloc=0
    has_set_line=0
    has_append_row=0
    has_layout_append=0
    has_dealloc=0
    has_draw_frame=0
    has_visible_count=0
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

    if (u ~ /^NEWGRID2_PROCESSGRIDSTATE:/ || u ~ /^NEWGRID2_PROCESSGRIDSTAT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDRENDERSTATELATCH/) has_render_latch=1
    if (n ~ /NEWGRIDPRIMETIMELAYOUTENABLE/) has_prime_flag=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTSETLAYO/) has_set_layout=1
    if (n ~ /NEWGRIDTESTPRIMETIMEWINDOW/) has_prime_test=1
    if (n ~ /NEWGRIDDRAWGRIDENTRY/) has_draw_entry=1
    if (n ~ /SCRIPTJMPTBLMEMORYALLOCATEMEM/) has_alloc=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTSETCURR/) has_set_line=1
    if (n ~ /NEWGRIDAPPENDSHOWTIMESFORROW/) has_append_row=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTLAYOUTA/) has_layout_append=1
    if (n ~ /SCRIPTJMPTBLMEMORYDEALLOCATEM/) has_dealloc=1
    if (n ~ /NEWGRIDDRAWGRIDFRAMEVARIANT4/) has_draw_frame=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTE/) has_visible_count=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_RENDER_LATCH_GLOBAL="has_render_latch
    print "HAS_PRIME_FLAG_GLOBAL="has_prime_flag
    print "HAS_SET_LAYOUT_CALL="has_set_layout
    print "HAS_PRIME_TEST_CALL="has_prime_test
    print "HAS_DRAW_ENTRY_CALL="has_draw_entry
    print "HAS_ALLOC_CALL="has_alloc
    print "HAS_SET_LINE_CALL="has_set_line
    print "HAS_APPEND_ROW_CALL="has_append_row
    print "HAS_LAYOUT_APPEND_CALL="has_layout_append
    print "HAS_DEALLOC_CALL="has_dealloc
    print "HAS_DRAW_FRAME_CALL="has_draw_frame
    print "HAS_VISIBLE_COUNT_CALL="has_visible_count
    print "HAS_RTS="has_rts
}
