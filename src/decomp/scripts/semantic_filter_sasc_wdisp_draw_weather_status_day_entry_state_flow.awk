BEGIN {
    has_entry = 0
    has_day_guard = 0
    has_panel_div3 = 0
    has_panel_mul20 = 0
    has_brush_mode_guard = 0
    has_brush_lookup = 0
    has_default_brush = 0
    has_mode_branch = 0
    has_acc_capture = 0
    has_palette_copy = 0
    has_row_copy = 0
    has_brush_select = 0
    has_restore_palette = 0
    has_high_unknown = 0
    has_high_printf = 0
    has_low_unknown = 0
    has_low_printf = 0
    has_temp_append = 0
    has_temp_draw = 0
    has_forecast_ptr = 0
    has_forecast_skip_class3 = 0
    has_wrapped_probe = 0
    has_wrapped_draw = 0
    has_weekday_mod = 0
    has_weekday_table = 0
    has_weekday_draw = 0
    has_return = 0

    prev1 = ""
    prev2 = ""
    wrap_zero_window = 0
    wrap_one_window = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (wrap_zero_window > 0) {
        wrap_zero_window--
    }
    if (wrap_one_window > 0) {
        wrap_one_window--
    }

    if (u ~ /^WDISP_DRAWWEATHERSTATUSDAYENTRY:/ || u ~ /^WDISP_DRAWWEATHERSTATUSDAYENTR[A-Z0-9_]*:/) {
        has_entry = 1
    }
    if ((u ~ /^TST\.L D7$/ || u ~ /^BMI\./ || u ~ /^CMP\.L D0,D7$/ || u ~ /^BGE\./) ||
        n ~ /DAYINDEX/) {
        has_day_guard = 1
    }
    if (u ~ /MATH_DIVS32\(PC\)/ || u ~ /BSR\.W MATH_DIVS32/ || n ~ /MATHDIVS32/) {
        has_panel_div3 = 1
    }
    if (((u ~ /MATH_MULU32\(PC\)/ || u ~ /BSR\.W MATH_MULU32/ || n ~ /MATHMULU32/) &&
         (prev1 ~ /MOVEQ(\.L)? #\$14,D1/ || prev1 ~ /PEA \(\$14\)\.W/ || prev2 ~ /PEA \(\$14\)\.W/)) ||
        n ~ /WDISPSTATUSDAYENTRY0/ || n ~ /CXD33/) {
        has_panel_mul20 = 1
    }
    if (u ~ /CMP\.L \$10\(A3\),D0/ || u ~ /CMP\.L 16\(A0\),D0/ || n ~ /BRUSHINDEX/) {
        has_brush_mode_guard = 1
    }
    if (n ~ /FINDBRUSHBYPREDICATE/ || n ~ /FINDBRUSHBYPR/) {
        has_brush_lookup = 1
    }
    if (u ~ /MOVEQ(\.L)? #\$5A,D0/ || u ~ /MOVEQ #90,D1/ || n ~ /CLRLS88A7/) {
        has_default_brush = 1
    }
    if (u ~ /TST\.L \$10\(A3\)/ || u ~ /TST\.L 16\(A0\)/) {
        has_mode_branch = 1
    }
    if (u ~ /MOVE\.W #\$1,WDISP_ACCUMULATORCAPTUREACTIVE/ ||
        u ~ /CLR\.W WDISP_ACCUMULATORCAPTUREACTIVE/ ||
        u ~ /MOVE\.W #1,WDISP_ACCUMULATORCAPTUREACTIVE/) {
        has_acc_capture = 1
    }
    if (u ~ /WDISP_PALETTETRIPLESRBASE/ || u ~ /PLANEMASKFORINDEX/ || n ~ /PALETTEBYTES/) {
        has_palette_copy = 1
    }
    if (u ~ /_LVOCOPYMEM/ || n ~ /ACCUMULATORROWTABLE/ || n ~ /ACCUMULATORROWS/) {
        has_row_copy = 1
    }
    if (n ~ /SELECTBRUSHSLOT/ || n ~ /SELECTBRUSHSL/) {
        has_brush_select = 1
    }
    if (n ~ /RESTOREBASEPALETTETRIPLES/ || n ~ /RESTOREBASEP/) {
        has_restore_palette = 1
    }
    if (n ~ /UNKNOWNNUMWITHSLASH/) {
        has_high_unknown = 1
    }
    if (n ~ /GLOBALSTRPERCENTDSLASH/ || (n ~ /SPRINTF/ && prev1 ~ /PERCENT_D_SLASH/)) {
        has_high_printf = 1
    }
    if (n ~ /WDISPSTRUNKNOWNNUM/ && n !~ /WITHSLASH/) {
        has_low_unknown = 1
    }
    if ((n ~ /GLOBALSTRPERCENTD/ && n !~ /SLASH/) || (n ~ /SPRINTF/ && prev1 ~ /GLOBAL_STR_PERCENT_D/)) {
        has_low_printf = 1
    }
    if (n ~ /APPENDATNULL/) {
        has_temp_append = 1
    }
    if ((n ~ /TEXTLENGTH/ || n ~ /LVOMOVE/ || n ~ /LVOTEXT/) && has_temp_append) {
        has_temp_draw = 1
    }
    if (n ~ /PTYPEWEATHERFORECASTMSGPTR/) {
        has_forecast_ptr = 1
    }
    if (n ~ /WDISPCHARCLASSTABLE/ || n ~ /BTST#3/ || n ~ /8U/) {
        has_forecast_skip_class3 = 1
    }
    if (u ~ /^CLR\.L -?\(A7\)$/) {
        wrap_zero_window = 8
    }
    if (u ~ /^PEA .*1.*\.W$/) {
        wrap_one_window = 8
    }
    if (n ~ /WDISPJMPTBLNEWGRIDDRAWWRAPPED/ || n ~ /DRAWWRAPPEDTEXT/ || n ~ /DRAWWRAPPED/) {
        if (wrap_zero_window > 0) {
            has_wrapped_probe = 1
        }
        if (wrap_one_window > 0) {
            has_wrapped_draw = 1
        }
    }
    if (n ~ /CLOCKCURRENTDAYOFWEEKINDEX/ || (n ~ /MATHDIVS32/ && prev1 ~ /MOVEQ(\.L)? #\$7,D1/)) {
        has_weekday_mod = 1
    }
    if (n ~ /GLOBALJMPTBLDAYSOFWEEK/) {
        has_weekday_table = 1
    }
    if ((n ~ /SETAPEN/ || n ~ /LVOMOVE/ || n ~ /LVOTEXT/) && has_weekday_table) {
        has_weekday_draw = 1
    }
    if (u == "RTS") {
        has_return = 1
    }

    prev2 = prev1
    prev1 = u
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DAY_GUARD=" has_day_guard
    print "HAS_PANEL_DIV3=" has_panel_div3
    print "HAS_PANEL_MUL20=" has_panel_mul20
    print "HAS_BRUSH_MODE_GUARD=" has_brush_mode_guard
    print "HAS_BRUSH_LOOKUP=" has_brush_lookup
    print "HAS_DEFAULT_BRUSH=" has_default_brush
    print "HAS_MODE_BRANCH=" has_mode_branch
    print "HAS_ACC_CAPTURE=" has_acc_capture
    print "HAS_PALETTE_COPY=" has_palette_copy
    print "HAS_ROW_COPY=" has_row_copy
    print "HAS_BRUSH_SELECT=" has_brush_select
    print "HAS_RESTORE_PALETTE=" has_restore_palette
    print "HAS_HIGH_UNKNOWN=" has_high_unknown
    print "HAS_HIGH_PRINTF=" has_high_printf
    print "HAS_LOW_UNKNOWN=" has_low_unknown
    print "HAS_LOW_PRINTF=" has_low_printf
    print "HAS_TEMP_APPEND=" has_temp_append
    print "HAS_TEMP_DRAW=" has_temp_draw
    print "HAS_FORECAST_PTR=" has_forecast_ptr
    print "HAS_FORECAST_SKIP_CLASS3=" has_forecast_skip_class3
    print "HAS_WRAPPED_PROBE=" has_wrapped_probe
    print "HAS_WRAPPED_DRAW=" has_wrapped_draw
    print "HAS_WEEKDAY_MOD=" has_weekday_mod
    print "HAS_WEEKDAY_TABLE=" has_weekday_table
    print "HAS_WEEKDAY_DRAW=" has_weekday_draw
    print "HAS_RETURN=" has_return
}
