BEGIN {
    has_entry=0
    has_draw_inline=0
    has_divs=0
    has_mulu=0
    has_alloc=0
    has_dealloc=0
    has_setpen=0
    has_setfont=0
    has_textlen=0
    has_const24=0
    has_const25=0
    has_const6=0
    has_space_rewrite=0
    has_const3=0
    has_const10=0
    has_const8=0
    has_prevue_font_gate=0
    has_inset_guard=0
    has_extra_spacing_flag=0
    has_center_round_fix=0
    saw_center_addq=0
    saw_center_asr=0
    has_saved_pen_restore=0
    has_txbaseline=0
    has_font_height=0
    has_const2115=0
    has_const2385=0
    has_drawy_running_load=0
    has_drawy_baseline_load=0
    has_drawy_storeback=0
    in_draw_y_window=0
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

    if (u ~ /^TLIBA1_DRAWFORMATTEDTEXTBLOCK:/ || u ~ /^TLIBA1_DRAWFORMATTEDTEXTBLOC[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TLIBA1DRAWINLINESTYLEDTEXT/ || n ~ /TLIBA1DRAWINLINESTYLED/) has_draw_inline=1
    if (n ~ /MATHDIVS32/) has_divs=1
    if (n ~ /MATHMULU32/) has_mulu=1
    if (n ~ /MEMORYALLOCATEMEMORY/) has_alloc=1
    if (n ~ /MEMORYDEALLOCATEMEMORY/) has_dealloc=1
    if (n ~ /LVOSETAPEN/) has_setpen=1
    if (n ~ /LVOSETFONT/) has_setfont=1
    if (n ~ /LVOTEXTLENGTH/ || n ~ /TEXTLENGTH/) has_textlen=1
    if (u ~ /#24/ || u ~ /#\$18/) has_const24=1
    if (u ~ /#25/ || u ~ /#\$19/) has_const25=1
    if (u ~ /#6([^0-9]|$)/ || u ~ /#\$06/ || u ~ /#\$6([^0-9A-F]|$)/) has_const6=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /#\$3([^0-9A-F]|$)/) has_const3=1
    if (u ~ /#10/ || u ~ /#\$0A/ || u ~ /#\$A([^0-9A-F]|$)/ || u ~ /\(\$A\)/) has_const10=1
    if (u ~ /#8([^0-9]|$)/ || u ~ /#\$08/ || u ~ /#\$8([^0-9A-F]|$)/) has_const8=1
    if (u ~ /#32([^0-9]|$)/ || u ~ /#\$20/) has_space_rewrite=1
    if (u ~ /TST\.W -38\(A5\)/ || u ~ /TST\.L \$40\(A7\)/ || u ~ /TST\.W \$36\(A7\)/) has_prevue_font_gate=1
    if ((u ~ /NOT\.B D[12]/) || (u ~ /CLEANUP_ALIGNEDINSETNIBBLE/ && u ~ /CMP\.L D[01],D[01]/)) has_inset_guard=1
    if (u ~ /TST\.W 8\(A0,D[0-7]\.L\)/ || u ~ /TST\.W \$8\(A0,D[0-7]\.L\)/ || u ~ /TST\.W \$8\(A0\)/ || u ~ /TST\.W \$8\(A6\)/) has_extra_spacing_flag=1
    if (u ~ /TST\.W 8\(A0,D[0-7]\.L\)/ || u ~ /TST\.W \$8\(A0,D[0-7]\.L\)/ || u ~ /TST\.W \$8\(A0\)/ || u ~ /TST\.W \$8\(A6\)/) in_draw_y_window=1
    if (in_draw_y_window && (u ~ /MOVE\.W -30\(A5\),D[0-7]/ || u ~ /MOVE\.W \$3C\(A7\),D[0-7]/)) has_drawy_running_load=1
    if (in_draw_y_window && (u ~ /MOVE\.W 58\(A3\),D[0-7]/ || u ~ /MOVE\.W \$3E\(A2\),D[0-7]/)) has_drawy_baseline_load=1
    if (in_draw_y_window && (u ~ /ADD\.W D[0-7],-30\(A5\)/ || u ~ /ADD\.W D[0-7],\$3C\(A7\)/ || u ~ /MOVE\.W D[0-7],\$3C\(A7\)/ || u ~ /MOVEM\.W D[0-7],\$3C\(A7\)/)) has_drawy_storeback=1
    if (in_draw_y_window && n ~ /TLIBA1DRAWINLINESTYLEDTEXT/) in_draw_y_window=0
    if (u ~ /ADDQ\.L #1,D1/ || u ~ /ADDQ\.L #\$1,\$30\(A7\)/ || u ~ /ADDQ\.L #\$1,\$50\(A7\)/) saw_center_addq=1
    if (u ~ /ASR\.L #1,D1/ || u ~ /ASR\.L #\$1,D0/ || u ~ /ASR\.L #\$1,D0/) saw_center_asr=1
    if (saw_center_addq && saw_center_asr) has_center_round_fix=1
    if (u ~ /MOVE\.B -21\(A5\),D0/ || u ~ /MOVE\.B \$38\(A7\),D0/ || u ~ /MOVE\.B \$5C\(A7\),D0/) has_saved_pen_restore=1
    if (u ~ /TXBASELINE/ || u ~ /58\(A/ || u ~ /\$3A\(/) has_txbaseline=1
    if (u ~ /TF_YSIZE/ || u ~ /20\(A/ || u ~ /\$14\(/) has_font_height=1
    if (u ~ /2115/ || u ~ /#\$843/ || u ~ /\$843/) has_const2115=1
    if (u ~ /2385/ || u ~ /#\$951/ || u ~ /\$951/) has_const2385=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DRAW_INLINE="has_draw_inline
    print "HAS_DIVS="has_divs
    print "HAS_MULU="has_mulu
    print "HAS_ALLOC="has_alloc
    print "HAS_DEALLOC="has_dealloc
    print "HAS_SETAPEN="has_setpen
    print "HAS_SETFONT="has_setfont
    print "HAS_TEXT_LENGTH="has_textlen
    print "HAS_CONST_24="has_const24
    print "HAS_CONST_25="has_const25
    print "HAS_CONST_6="has_const6
    print "HAS_SPACE_REWRITE="has_space_rewrite
    print "HAS_CONST_3="has_const3
    print "HAS_CONST_10="has_const10
    print "HAS_CONST_8="has_const8
    print "HAS_PREVUE_FONT_GATE="has_prevue_font_gate
    print "HAS_INSET_GUARD="has_inset_guard
    print "HAS_EXTRA_SPACING_FLAG="has_extra_spacing_flag
    print "HAS_CENTER_ROUND_FIX="has_center_round_fix
    print "HAS_SAVED_PEN_RESTORE="has_saved_pen_restore
    print "HAS_TX_BASELINE="has_txbaseline
    print "HAS_FONT_HEIGHT="has_font_height
    print "HAS_CONST_2115="has_const2115
    print "HAS_CONST_2385="has_const2385
    print "HAS_DRAWY_RUNNING_LOAD="has_drawy_running_load
    print "HAS_DRAWY_BASELINE_LOAD="has_drawy_baseline_load
    print "HAS_DRAWY_STOREBACK="has_drawy_storeback
    print "HAS_RETURN="has_return
}
