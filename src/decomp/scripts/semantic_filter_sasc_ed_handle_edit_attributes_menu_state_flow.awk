BEGIN {
    h_entry = 0
    h_initial_cursor_draw = 0
    h_backspace_gate = 0
    h_backspace_blank = 0
    h_nav_lookup = 0
    h_nav_cursor_13 = 0
    h_nav_cursor_12 = 0
    h_parse_ad_number = 0
    h_store_ad_number = 0
    h_too_big_error = 0
    h_too_small_error = 0
    h_mode2_commit = 0
    h_mode5_help = 0
    h_digit_gate = 0
    h_digit_store = 0
    h_digit_advance = 0
    h_redraw_cursor = 0
    h_rts = 0
    imm12_window = 0
    imm13_window = 0
    buffer_window = 0
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = norm($0)
    if (l == "") {
        next
    }

    if (imm12_window > 0) {
        imm12_window--
    }
    if (imm13_window > 0) {
        imm13_window--
    }
    if (buffer_window > 0) {
        buffer_window--
    }

    if (l ~ /^ED_HANDLEEDITATTRIBUTESMENU:/ || l ~ /^ED_HANDLEEDITATTRIBUTESMENU[A-Z0-9_]*:/) {
        h_entry = 1
    }

    if (l ~ /(JSR|BSR).*ED_DRAWCURSORCHAR/) {
        h_initial_cursor_draw = 1
    }

    if (l ~ /^MOVEQ(\.L)? #\$?C,D[0-7]$/ || l ~ /^MOVEQ #12,D[0-7]$/) {
        imm12_window = 2
    }
    if (l ~ /^MOVEQ(\.L)? #\$?D,D[0-7]$/ || l ~ /^MOVEQ #13,D[0-7]$/) {
        imm13_window = 2
    }
    if (imm12_window > 0 && l ~ /^CMP\.L D[0-7],D[0-7]$/) {
        h_backspace_gate = 1
    }
    if (l ~ /^MOVE\.B #\$?20,/ || l ~ /^MOVE\.B #32,/) {
        h_backspace_blank = 1
    }

    if (l ~ /ED_STATERINGINDEX/ || l ~ /ED_STATERINGTABLE/ || l ~ /ED_LASTMENUINPUTCHAR/) {
        h_nav_lookup = 1
    }
    if (imm13_window > 0 && l ~ /ED_EDITCURSOROFFSET/) {
        h_nav_cursor_13 = 1
    }
    if (imm12_window > 0 && l ~ /ED_EDITCURSOROFFSET/ && l !~ /^CMP\.L /) {
        h_nav_cursor_12 = 1
    }

    if (l ~ /ED_PARSEADNUMBERFROMDIGITS/ || l ~ /GROUP_AG_JMPTBL_MATH_MULU32/ ||
        l ~ /ED_ADNUMBERINPUTDIGITTENS/ || l ~ /ED_ADNUMBERINPUTDIGITONES/) {
        h_parse_ad_number = 1
    }
    if (l ~ /GLOBAL_REF_LONG_CURRENT_EDITING_/ || l ~ /GLOBAL_REF_LONG_CURRENT_EDITING_AD_NUMBER/) {
        h_store_ad_number = 1
    }

    if (l ~ /ED2_STR_NUMBER_TOO_BIG/) {
        h_too_big_error = 1
    }
    if (l ~ /ED2_STR_NUMBER_TOO_SMALL/) {
        h_too_small_error = 1
    }

    if ((l ~ /ED_MENUSTATEID/ && l ~ /#\$?4/) ||
        l ~ /ED_DRAWADEDITINGSCREEN/ ||
        l ~ /ED_LOADCURRENTADINTOBUFFERS/ ||
        l ~ /ED_SAVETEXTADSONEXITFLAG/) {
        h_mode2_commit = 1
    }

    if ((l ~ /ED_MENUSTATEID/ && l ~ /#\$?5/) ||
        l ~ /ED_DRAWHELPPANELS/ ||
        l ~ /ED_UPDATEADNUMBERDISPLAY/ ||
        l ~ /ED2_STR_PUSH_ESC_TO_EXIT/ ||
        l ~ /ED2_STR_PUSH_RETURN_TO_ENTER/ ||
        l ~ /ED2_STR_PUSH_ANY_KEY_TO_SELECT/ ||
        l ~ /_LVOSETDRMD/) {
        h_mode5_help = 1
    }

    if ((l ~ /ED_LASTKEYCODE/ && l ~ /#\$?30/) ||
        (l ~ /ED_LASTKEYCODE/ && l ~ /#\$?39/) ||
        l ~ /CMP\.B D[0-7],D[0-7]/) {
        h_digit_gate = 1
    }
    if (l ~ /EDITBUFFERSCRATCH/) {
        buffer_window = 3
    }
    if (buffer_window > 0 &&
        (l ~ /^MOVE\.B ED_LASTKEYCODE,\(A0\)$/ ||
         l ~ /^MOVE\.B D[07],\$0\(A1,D[01]\.L\)$/ ||
         l ~ /^MOVE\.B D0,\$0\(A1,D[01]\.L\)$/)) {
        h_digit_store = 1
    }
    if (l ~ /^MOVE\.B ED_LASTKEYCODE,\(A0\)$/) {
        h_digit_store = 1
    }
    if (l ~ /ADDQ\.L #\$?1,ED_EDITCURSOROFFSET/ || l ~ /CMPI\.L #\$?D,ED_EDITCURSOROFFSET/) {
        h_digit_advance = 1
    }

    if (l ~ /(JSR|BSR).*ED_REDRAWCURSORCHAR/) {
        h_redraw_cursor = 1
    }

    if (l == "RTS") {
        h_rts = 1
    }
}

END {
    print "HAS_ENTRY=" h_entry
    print "HAS_INITIAL_CURSOR_DRAW=" h_initial_cursor_draw
    print "HAS_BACKSPACE_GATE=" h_backspace_gate
    print "HAS_BACKSPACE_BLANK=" h_backspace_blank
    print "HAS_NAV_LOOKUP=" h_nav_lookup
    print "HAS_NAV_CURSOR_13=" h_nav_cursor_13
    print "HAS_NAV_CURSOR_12=" h_nav_cursor_12
    print "HAS_PARSE_AD_NUMBER=" h_parse_ad_number
    print "HAS_STORE_AD_NUMBER=" h_store_ad_number
    print "HAS_TOO_BIG_ERROR=" h_too_big_error
    print "HAS_TOO_SMALL_ERROR=" h_too_small_error
    print "HAS_MODE2_COMMIT=" h_mode2_commit
    print "HAS_MODE5_HELP=" h_mode5_help
    print "HAS_DIGIT_GATE=" h_digit_gate
    print "HAS_DIGIT_STORE=" h_digit_store
    print "HAS_DIGIT_ADVANCE=" h_digit_advance
    print "HAS_REDRAW_CURSOR=" h_redraw_cursor
    print "HAS_RTS=" h_rts
}
