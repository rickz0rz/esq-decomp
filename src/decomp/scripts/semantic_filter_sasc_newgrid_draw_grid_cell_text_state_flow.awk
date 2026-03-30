BEGIN {
    has_entry=0
    has_ravesc_guard=0
    has_secondary_copy_loop=0
    has_secondary_hyphen=0
    has_secondary_append=0
    has_secondary_plus2=0
    has_layout_half_sample_width=0
    has_layout_const42=0
    has_layout_font_fetch=0
    has_align_mode_gate=0
    has_align_zero_path=0
    has_align_nonzero_path=0
    has_pen_compare_5=0
    has_pen_niche=0
    has_pen_alt3=0
    has_drmd_zero=0
    has_primary_scan=0
    has_primary_trim=0
    has_primary_textlen=0
    has_primary_mode_check=0
    has_primary_move=0
    has_primary_text=0
    has_secondary_scan=0
    has_secondary_trim=0
    has_secondary_textlen=0
    has_secondary_mode_check=0
    has_secondary_move=0
    has_secondary_text=0
    has_rts=0

    append_calls=0
    textlen_calls=0
    move_calls=0
    text_calls=0

    phase="init"
    saw_pen_compare_5=0
    saw_pen_niche_arg=0
    saw_pen_alt3_arg=0
    saw_drmd_zero_arg=0
    awaiting_setapen=0
    awaiting_setdrmd=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    u=trim($0)
    if (u=="") next
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^NEWGRID_DRAWGRIDCELLTEXT:/ || u ~ /^NEWGRID_DRAWGRIDCELLTEXT[A-Z0-9_]*:/) has_entry=1

    if (n ~ /GLOBALWORDSELECTCODEISRAVES/ && (u ~ /^TST\.W/ || u ~ /^MOVE\.W/)) has_ravesc_guard=1
    if ((u ~ /^MOVE\.B \(A0\)\+,/ || u ~ /^MOVE\.B \$0\(A2,D0\.L\),/) && (phase=="init" || phase=="merge")) {
        has_secondary_copy_loop=1
        phase="merge"
    }
    if (u ~ /#\$2D/ || u ~ /#45([^0-9]|$)/) has_secondary_hyphen=1
    if (n ~ /PARSEINIJMPTBLSTRINGAPPENDATN/ || n ~ /PARSEINIJMPTBLSTRINGAPPENDATNULL/) {
        append_calls++
        has_secondary_append=1
        phase="layout"
    }
    if (u ~ /ADDQ\.L #2,A0/ || u ~ /LEA \$2\(A2\),A1/) has_secondary_plus2=1

    if (n ~ /NEWGRIDSAMPLETIMETEXTWIDTHPX/ && u ~ /^MOVE\.W/) has_layout_half_sample_width=1
    if (u ~ /#42([^0-9]|$)/ || u ~ /#\$2A/) has_layout_const42=1
    if ((u ~ /MOVEA\.L 52\(A3\),A0/ || u ~ /MOVE\.L \$34\(A1\),A0/) && phase=="layout") has_layout_font_fetch=1
    if (u ~ /^TST\.L D7/ || n ~ /ALIGNMODE/ && u ~ /^TST\.L/) has_align_mode_gate=1
    if ((u ~ /SUBQ\.L #1,D2/ || u ~ /SUBQ\.L #\$1,D2/ || u ~ /SUBQ\.L #1,D1/ || u ~ /SUBQ\.L #\$1,D1/) && phase=="layout") has_align_zero_path=1
    if ((u ~ /SUBQ\.L #4,D2/ || u ~ /SUBQ\.L #\$4,D2/ || u ~ /SUBQ\.L #4,\$4C\(A7\)/ || u ~ /SUBQ\.L #\$4,\$4C\(A7\)/) && phase=="layout") has_align_nonzero_path=1

    if (u ~ /^MOVEQ #5,D0/ || u ~ /^MOVEQ\.L #\$5,D0/) saw_pen_compare_5=1
    if (saw_pen_compare_5 && n ~ /NEWGRIDGRIDOPERATIONID/) {
        has_pen_compare_5=1
        saw_pen_compare_5=0
    }
    if (n ~ /GCOMMANDNICHETEXTPEN/) {
        saw_pen_niche_arg=1
        awaiting_setapen=1
    }
    if (u ~ /MOVEQ #3,D0/ || u ~ /PEA \(\$3\)\.W/ || u ~ /PEA 3\.W/) {
        saw_pen_alt3_arg=1
        awaiting_setapen=1
    }
    if (u ~ /MOVEQ #0,D0/ || u ~ /CLR\.L -\(A7\)/) {
        saw_drmd_zero_arg=1
        awaiting_setdrmd=1
    }
    if (n ~ /LVOSETAPEN/) {
        if (saw_pen_niche_arg) has_pen_niche=1
        if (saw_pen_alt3_arg) has_pen_alt3=1
        saw_pen_niche_arg=0
        saw_pen_alt3_arg=0
        awaiting_setapen=0
    }
    if (n ~ /LVOSETDRMD/) {
        if (saw_drmd_zero_arg) has_drmd_zero=1
        saw_drmd_zero_arg=0
        awaiting_setdrmd=0
    }

    if (phase=="layout" && has_drmd_zero) phase="primary"

    if ((u ~ /^TST\.B \(A0\)\+/ || u ~ /^MOVE\.B \(A0\)\+,D0/) && phase=="primary") has_primary_scan=1
    if ((u ~ /CMP\.B -1\(A2,D6\.L\),D0/ || u ~ /CMP\.B \$FFFFFFFF\(A3,D0\.L\),D1/) && phase=="primary") has_primary_trim=1
    if (n ~ /LVOTEXTLENGTH/ && phase=="primary") {
        textlen_calls++
        has_primary_textlen=1
    }
    if (n ~ /CTASKSSTRC/ && (u ~ /#83/ || u ~ /#\$53/ || u ~ /MOVE\.B CTASKS_STR_C/ || u ~ /MOVE\.B CTASKSSTRC/)) has_primary_mode_check=1
    if (n ~ /LVOMOVE/ && phase=="primary") {
        move_calls++
        has_primary_move=1
    }
    if (n ~ /LVOTEXT/ && n !~ /TEXTLENGTH/ && phase=="primary") {
        text_calls++
        has_primary_text=1
        phase="secondary"
    }

    if ((u ~ /^TST\.B \(A0\)\+/ || u ~ /^MOVE\.B \(A0\)\+,D0/) && phase=="secondary") has_secondary_scan=1
    if ((u ~ /CMP\.B -1\(A0,D6\.L\),D0/ || u ~ /CMP\.B \$FFFFFFFF\(A2,D0\.L\),D1/) && phase=="secondary") has_secondary_trim=1
    if (n ~ /LVOTEXTLENGTH/ && phase=="secondary") {
        textlen_calls++
        has_secondary_textlen=1
    }
    if (phase=="secondary" && n ~ /CTASKSSTRC/ && (u ~ /#83/ || u ~ /#\$53/ || u ~ /MOVE\.B CTASKS_STR_C/ || u ~ /MOVE\.B CTASKSSTRC/)) has_secondary_mode_check=1
    if (n ~ /LVOMOVE/ && phase=="secondary") {
        move_calls++
        has_secondary_move=1
    }
    if (n ~ /LVOTEXT/ && n !~ /TEXTLENGTH/ && phase=="secondary") {
        text_calls++
        has_secondary_text=1
    }

    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_RAVESC_GUARD="has_ravesc_guard
    print "HAS_SECONDARY_COPY_LOOP="has_secondary_copy_loop
    print "HAS_SECONDARY_HYPHEN="has_secondary_hyphen
    print "HAS_SECONDARY_APPEND="has_secondary_append
    print "HAS_SECONDARY_PLUS2="has_secondary_plus2
    print "HAS_LAYOUT_HALF_SAMPLE_WIDTH="has_layout_half_sample_width
    print "HAS_LAYOUT_CONST_42="has_layout_const42
    print "HAS_LAYOUT_FONT_FETCH="has_layout_font_fetch
    print "HAS_ALIGN_MODE_GATE="has_align_mode_gate
    print "HAS_ALIGN_ZERO_PATH="has_align_zero_path
    print "HAS_ALIGN_NONZERO_PATH="has_align_nonzero_path
    print "HAS_PEN_COMPARE_5="has_pen_compare_5
    print "HAS_PEN_NICHE="has_pen_niche
    print "HAS_PEN_ALT3="has_pen_alt3
    print "HAS_DRMD_ZERO="has_drmd_zero
    print "HAS_PRIMARY_SCAN="has_primary_scan
    print "HAS_PRIMARY_TRIM="has_primary_trim
    print "HAS_PRIMARY_TEXTLEN="has_primary_textlen
    print "HAS_PRIMARY_MODE_CHECK="has_primary_mode_check
    print "HAS_PRIMARY_MOVE="has_primary_move
    print "HAS_PRIMARY_TEXT="has_primary_text
    print "HAS_SECONDARY_SCAN="has_secondary_scan
    print "HAS_SECONDARY_TRIM="has_secondary_trim
    print "HAS_SECONDARY_TEXTLEN="has_secondary_textlen
    print "HAS_SECONDARY_MODE_CHECK="has_secondary_mode_check
    print "HAS_SECONDARY_MOVE="has_secondary_move
    print "HAS_SECONDARY_TEXT="has_secondary_text
    print "HAS_SINGLE_APPEND_CALL="(append_calls == 1)
    print "HAS_PRIMARY_AND_SECONDARY_TEXTLEN="(textlen_calls >= 2)
    print "HAS_PRIMARY_AND_SECONDARY_MOVE="(move_calls >= 2)
    print "HAS_PRIMARY_AND_SECONDARY_TEXT="(text_calls >= 2)
    print "HAS_RTS="has_rts
}
