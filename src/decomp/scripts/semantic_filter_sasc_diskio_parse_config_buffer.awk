BEGIN {
    has_entry = 0
    has_parse = 0
    parse_count = 0
    has_guard_checks = 0
    guard_check_count = 0
    guard_cmp_count = 0
    has_slot08_default_n = 0
    has_slot08_store = 0
    has_slot_a_default = 0
    has_slot10_digit_clamp = 0
    has_custom_budget_digit_clamp = 0
    yes_no_y_count = 0
    yes_no_n_count = 0
    has_yes_no_y_family = 0
    has_yes_no_n_family = 0
    has_brush_select = 0
    has_line_mode_store = 0
    has_line_mode_lsv = 0
    has_slot19_store = 0
    has_slot20_store = 0
    has_slot25_store = 0
    has_slot26_store = 0
    has_alt_span_store = 0
    has_time_window_store = 0
    has_gate_duration_store = 0
    has_gate_duration_clamp = 0
    has_selection16_store = 0
    has_clock_mode_store = 0
    has_clock_format_12hr = 0
    has_clock_format_24hr = 0
    has_clock_format_store = 0
    has_logo_scan_store = 0
    has_banner_force_128 = 0
    has_banner_default_8e = 0
    has_banner_bounds_check = 0
    has_palette_force_8 = 0
    has_diag_find = 0
    has_diag_store = 0
    has_diag_default_n = 0
    has_pc1_call = 0
    has_pc1_flag_store = 0
    has_pc1_y_guard = 0
    has_lrbn_find = 0
    has_lrbn_selector_store = 0
    has_lrbn_selector_default_n = 0
    has_banner_transition = 0
    has_lrbn_flag_store = 0
    lrbn_flag_store_count = 0
    has_lrbn_force_y = 0
    has_lrbn_reset = 0
    has_msn_find = 0
    has_msn_flag_store = 0
    has_msn_default_n = 0
    has_ctasks1_store = 0
    has_ctasks1_fallback = 0
    has_refresh_update = 0
    has_mulu = 0
    has_mulu_60 = 0
    has_store_minutes = 0
    has_store_seconds = 0
    has_rts = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

function is_call(line) {
    return (line ~ /^(JSR|BSR(\.[A-Z]+)?|BSR\.W) /)
}

{
    l = t($0)
    if (l == "") next

    if (l ~ /^DISKIO_PARSECONFIGBUFFER:/ || l ~ /^DISKIO_PARSECONFIGBUFF/) has_entry = 1

    if (is_call(l) &&
        (index(l, "GROUP_AG_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 ||
         index(l, "PARSE_TWO_DIGITS") > 0 ||
         index(l, "PARSE_THREE_DIGITS") > 0)) {
        has_parse = 1
        parse_count++
    }
    if (parse_count >= 8) has_parse = 1

    if (is_call(l) && index(l, "HAS_GUARDED_CONFIG_BYTE") > 0) guard_check_count++
    if (l ~ /^CMP\.L D0,D1$/ || l ~ /^CMP\.L D0,D1/) guard_cmp_count++
    if (guard_check_count >= 20 || guard_cmp_count >= 20) has_guard_checks = 1

    if (is_call(l) && index(l, "BRUSH_SELECTBRUSHBYLABEL") > 0) has_brush_select = 1
    if (index(l, "CTASKS_STR_L") > 0 && l ~ /^MOVE\.B /) has_line_mode_store = 1
    if (index(l, "CTASKS_STR_L") > 0 &&
        ((index(l, "#76") > 0 || index(l, "#$4C") > 0 || index(l, "#'L'") > 0) ||
         (index(l, "#83") > 0 || index(l, "#$53") > 0 || index(l, "#'S'") > 0) ||
         (index(l, "#86") > 0 || index(l, "#$56") > 0 || index(l, "#'V'") > 0))) {
        has_line_mode_lsv = 1
    }
    if (index(l, "CONFIG_SERIALIZEDFLAGSLOT08") > 0 &&
        (index(l, "#78") > 0 || index(l, "#$4E") > 0 || index(l, "#'N'") > 0)) has_slot08_default_n = 1
    if (index(l, "CONFIG_SERIALIZEDFLAGSLOT08") > 0 && l ~ /^MOVE\.B D0,/ &&
        ((index(prev, "#78") > 0 || index(prev, "#$4E") > 0 || index(prev, "#'N'") > 0) ||
         (index(prev2, "#78") > 0 || index(prev2, "#$4E") > 0 || index(prev2, "#'N'") > 0))) has_slot08_default_n = 1
    if (index(l, "CONFIG_SERIALIZEDFLAGSLOT08") > 0 && l ~ /^MOVE\.B /) has_slot08_store = 1
    if (index(l, "CTASKS_STR_A") > 0 &&
        (index(l, "#65") > 0 || index(l, "#$41") > 0 || index(l, "#'A'") > 0)) has_slot_a_default = 1
    if (index(l, "CONFIG_SERIALIZEDNUMERICSLOT10") > 0 &&
        ((index(l, "#9") > 0 || index(l, "#$9") > 0) ||
         (index(l, "#0") > 0 || index(l, "#$0") > 0))) has_slot10_digit_clamp = 1
    if (index(l, "CONFIG_SERIALIZEDNUMERICSLOT10") > 0 &&
        (index(prev, "NORMALIZE_DIGIT_0_TO_9_OR_ZERO") > 0 ||
         index(prev2, "NORMALIZE_DIGIT_0_TO_9_OR_ZERO") > 0)) has_slot10_digit_clamp = 1
    if (index(l, "CONFIG_SERIALIZEDNUMERICSLOT10") > 0 &&
        ((index(prev, "#9") > 0 || index(prev, "#$9") > 0 || index(prev, "#0") > 0 || index(prev, "#$0") > 0) ||
         (index(prev2, "#9") > 0 || index(prev2, "#$9") > 0 || index(prev2, "#0") > 0 || index(prev2, "#$0") > 0) ||
         (index(prev3, "#9") > 0 || index(prev3, "#$9") > 0 || index(prev3, "#0") > 0 || index(prev3, "#$0") > 0))) has_slot10_digit_clamp = 1
    if (index(l, "CONFIG_NICHEMODECYCLEBUDGET_CUST") > 0 &&
        ((index(l, "#9") > 0 || index(l, "#$9") > 0) ||
         (index(l, "#0") > 0 || index(l, "#$0") > 0))) has_custom_budget_digit_clamp = 1
    if (index(l, "CONFIG_NICHEMODECYCLEBUDGET_CUST") > 0 &&
        (index(prev, "NORMALIZE_DIGIT_0_TO_9_OR_ZERO") > 0 ||
         index(prev2, "NORMALIZE_DIGIT_0_TO_9_OR_ZERO") > 0)) has_custom_budget_digit_clamp = 1
    if (index(l, "CONFIG_NICHEMODECYCLEBUDGET_CUST") > 0 &&
        ((index(prev, "#9") > 0 || index(prev, "#$9") > 0 || index(prev, "#0") > 0 || index(prev, "#$0") > 0) ||
         (index(prev2, "#9") > 0 || index(prev2, "#$9") > 0 || index(prev2, "#0") > 0 || index(prev2, "#$0") > 0) ||
         (index(prev3, "#9") > 0 || index(prev3, "#$9") > 0 || index(prev3, "#0") > 0 || index(prev3, "#$0") > 0))) has_custom_budget_digit_clamp = 1
    if (index(l, "CONFIG_TIMEWINDOWMINUTES") > 0 && l ~ /^MOVE\.L /) has_time_window_store = 1
    if (index(l, "CONFIG_MODECYCLEGATEDURATION") > 0 && l ~ /^MOVE\.L /) has_gate_duration_store = 1
    if (index(l, "CONFIG_MODECYCLEGATEDURATION") > 0 &&
        ((index(l, "#1") > 0 || index(l, "#$1") > 0) ||
         (index(l, "#9") > 0 || index(l, "#$9") > 0))) has_gate_duration_clamp = 1
    if (index(l, "CONFIG_MODECYCLEGATEDURATION") > 0 &&
        ((index(prev, "#1") > 0 || index(prev, "#$1") > 0 || index(prev, "#9") > 0 || index(prev, "#$9") > 0) ||
         (index(prev2, "#1") > 0 || index(prev2, "#$1") > 0 || index(prev2, "#9") > 0 || index(prev2, "#$9") > 0) ||
         (index(prev3, "#1") > 0 || index(prev3, "#$1") > 0 || index(prev3, "#9") > 0 || index(prev3, "#$9") > 0) ||
         (index(prev4, "#1") > 0 || index(prev4, "#$1") > 0 || index(prev4, "#9") > 0 || index(prev4, "#$9") > 0) ||
         (index(prev5, "#1") > 0 || index(prev5, "#$1") > 0 || index(prev5, "#9") > 0 || index(prev5, "#$9") > 0))) has_gate_duration_clamp = 1
    if (index(l, "CONFIG_NEWGRIDSELECTIONCODE16") > 0 && l ~ /^MOVE\.B /) has_selection16_store = 1
    if (index(l, "GLOBAL_REF_STR_USE_24_HR_CLOCK") > 0 && l ~ /^MOVE\.B /) has_clock_mode_store = 1
    if (index(l, "GLOBAL_JMPTBL_HALF_HOURS_12_HR_FMT") > 0 ||
        index(l, "GLOBAL_JMPTBL_HALF_HOURS_12_HR_F") > 0) has_clock_format_12hr = 1
    if (index(l, "GLOBAL_JMPTBL_HALF_HOURS_24_HR_FMT") > 0 ||
        index(l, "GLOBAL_JMPTBL_HALF_HOURS_24_HR_F") > 0) has_clock_format_24hr = 1
    if (index(l, "GLOBAL_REF_STR_CLOCK_FORMAT") > 0 && l ~ /^MOVE\.L /) has_clock_format_store = 1
    if ((index(l, "CONFIG_PARSEINILOGOSCANENABLEDFLAG") > 0 ||
         index(l, "CONFIG_PARSEINILOGOSCANENABLEDFL") > 0) &&
        l ~ /^MOVE\.B /) has_logo_scan_store = 1

    if ((index(l, "CONFIG_NEWGRIDSELECTIONCODE34PRI") > 0 ||
         index(l, "CONFIG_NEWGRIDSELECTIONCODE35ENA") > 0 ||
         index(l, "CONFIG_NEWGRIDSELECTIONCODE32ENA") > 0 ||
         index(l, "CONFIG_MODECYCLEENABLEDFLAG") > 0 ||
         index(l, "CONFIG_NEWGRIDPLACEHOLDERBEVELFL") > 0 ||
         index(l, "CONFIG_NEWGRIDSELECTIONCODE16ENA") > 0 ||
         index(l, "CONFIG_PARSEINILOGOSCANENABLEDFL") > 0) &&
        l ~ /^MOVE\.B /) {
        yes_no_y_count++
    }
    if ((index(l, "CONFIG_SERIALIZEDFLAGSLOT15") > 0 ||
         index(l, "CONFIG_NEWGRIDSELECTIONCODE34ALT") > 0 ||
         index(l, "CONFIG_RUNTIMEMODE12BANNERJUMPEN") > 0 ||
         index(l, "GLOBAL_REF_STR_USE_24_HR_CLOCK") > 0 ||
         index(l, "CONFIG_ENSUREPC1GFXASSIGNEDFLAG") > 0) &&
        l ~ /^MOVE\.B /) {
        yes_no_n_count++
    }
    if (yes_no_y_count >= 7) has_yes_no_y_family = 1
    if (yes_no_n_count >= 5) has_yes_no_n_family = 1

    if ((index(l, "CONFIG_BANNERCOPPERHEADBYTE") > 0 &&
         (index(l, "#128") > 0 || index(l, "#$80") > 0)) ||
        (index(l, "CONFIG_BANNERCOPPERHEADBYTE") > 0 &&
         (index(prev, "#128") > 0 || index(prev, "#$80") > 0 ||
          index(prev2, "#128") > 0 || index(prev2, "#$80") > 0))) {
        has_banner_force_128 = 1
    }
    if (index(l, "CONFIG_BANNERCOPPERHEADBYTE") > 0 &&
        (index(l, "#$8E") > 0 || index(l, "#142") > 0)) has_banner_default_8e = 1
    if (((index(l, "CONFIG_BANNERCOPPERHEADBYTE") > 0 &&
          (index(l, "#220") > 0 || index(l, "#128") > 0 ||
           index(l, "#$DC") > 0 || index(l, "#$80") > 0)) ||
         ((index(prev, "CONFIG_BANNERCOPPERHEADBYTE") > 0 ||
           index(prev2, "CONFIG_BANNERCOPPERHEADBYTE") > 0) &&
          (index(l, "#220") > 0 || index(l, "#128") > 0 ||
           index(l, "#$DC") > 0 || index(l, "#$80") > 0))) &&
        (l ~ /^CMPI?\.W / || l ~ /^CMP\.W /)) has_banner_bounds_check = 1
    if (((index(l, "GLOBAL_REF_BYTE_NUMBER_OF_COLOR_PALETTES") > 0 ||
          index(l, "GLOBAL_REF_BYTE_NUMBER_OF_COLOR_") > 0) &&
         (index(l, "#8") > 0 || index(l, "#$8") > 0)) ||
        ((index(l, "GLOBAL_REF_BYTE_NUMBER_OF_COLOR_PALETTES") > 0 ||
          index(l, "GLOBAL_REF_BYTE_NUMBER_OF_COLOR_") > 0) &&
         (index(prev, "#8") > 0 || index(prev, "#$8") > 0 ||
          index(prev2, "#8") > 0 || index(prev2, "#$8") > 0 ||
          index(prev3, "#8") > 0 || index(prev3, "#$8") > 0)) ||
        ((index(l, "#8") > 0 || index(l, "#$8") > 0) &&
         (index(prev, "GLOBAL_REF_BYTE_NUMBER_OF_COLOR_PALETTES") > 0 ||
          index(prev, "GLOBAL_REF_BYTE_NUMBER_OF_COLOR_") > 0 ||
          index(prev2, "GLOBAL_REF_BYTE_NUMBER_OF_COLOR_PALETTES") > 0 ||
          index(prev2, "GLOBAL_REF_BYTE_NUMBER_OF_COLOR_") > 0 ||
         index(prev3, "GLOBAL_REF_BYTE_NUMBER_OF_COLOR_PALETTES") > 0 ||
          index(prev3, "GLOBAL_REF_BYTE_NUMBER_OF_COLOR_") > 0))) {
        has_palette_force_8 = 1
    }

    if (index(l, "CONFIG_SERIALIZEDNUMERICSLOT19") > 0 && l ~ /^MOVE\.B /) has_slot19_store = 1
    if (index(l, "CONFIG_SERIALIZEDNUMERICSLOT20") > 0 && l ~ /^MOVE\.B /) has_slot20_store = 1
    if (index(l, "CONFIG_SERIALIZEDNUMERICSLOT25") > 0 && l ~ /^MOVE\.B /) has_slot25_store = 1
    if (index(l, "CONFIG_SERIALIZEDNUMERICSLOT26") > 0 && l ~ /^MOVE\.B /) has_slot26_store = 1
    if ((index(l, "CONFIG_NEWGRIDWINDOWSPANHALFHOURSALT") > 0 ||
         index(l, "CONFIG_NEWGRIDWINDOWSPANHALFHOUR") > 0) &&
        l ~ /^MOVE\.B /) has_alt_span_store = 1

    if (is_call(l) && index(l, "GROUP_AI_JMPTBL_STR_FINDCHARPTR") > 0) {
        if (index(prev, "DISKIO_TAG_NRLS") > 0 || index(prev2, "DISKIO_TAG_NRLS") > 0) has_diag_find = 1
        if (index(prev, "DISKIO_TAG_LRBN") > 0 || index(prev2, "DISKIO_TAG_LRBN") > 0) has_lrbn_find = 1
        if (index(prev, "DISKIO_TAG_MSN") > 0 || index(prev2, "DISKIO_TAG_MSN") > 0) has_msn_find = 1
    }
    if (index(l, "ED_DIAGTEXTMODECHAR") > 0 && l ~ /^MOVE\.B /) has_diag_store = 1
    if (index(l, "ED_DIAGTEXTMODECHAR") > 0 &&
        (index(l, "#78") > 0 || index(l, "#$4E") > 0 || index(l, "#'N'") > 0)) has_diag_default_n = 1
    if (index(l, "ED_DIAGTEXTMODECHAR") > 0 && l ~ /^MOVE\.B D0,/ &&
        ((index(prev, "#78") > 0 || index(prev, "#$4E") > 0 || index(prev, "#'N'") > 0) ||
         (index(prev2, "#78") > 0 || index(prev2, "#$4E") > 0 || index(prev2, "#'N'") > 0))) has_diag_default_n = 1

    if (is_call(l) &&
        (index(l, "DISKIO_ENSUREPC1MOUNTEDANDGFXASSIGNED") > 0 ||
         index(l, "DISKIO_ENSUREPC1MOUNTEDANDGFXASS") > 0)) {
        has_pc1_call = 1
    }
    if (index(l, "CONFIG_ENSUREPC1GFXASSIGNEDFLAG") > 0 && l ~ /^MOVE\.B /) has_pc1_flag_store = 1
    if ((index(l, "CONFIG_ENSUREPC1GFXASSIGNEDFLAG") > 0 &&
         (index(l, "#89") > 0 || index(l, "#$59") > 0 || index(l, "#'Y'") > 0)) ||
        ((l ~ /^CMP\.B / || l ~ /^CMPI?\.B /) &&
         ((index(prev, "#89") > 0 || index(prev, "#$59") > 0 || index(prev, "#'Y'") > 0) ||
          (index(prev2, "#89") > 0 || index(prev2, "#$59") > 0 || index(prev2, "#'Y'") > 0)) &&
         (index(prev, "CONFIG_ENSUREPC1GFXASSIGNEDFLAG") > 0 ||
          index(prev2, "CONFIG_ENSUREPC1GFXASSIGNEDFLAG") > 0 ||
          index(prev3, "CONFIG_ENSUREPC1GFXASSIGNEDFLAG") > 0))) {
        has_pc1_y_guard = 1
    }

    if (is_call(l) &&
        (index(l, "GROUP_AG_JMPTBL_SCRIPT_BEGINBANNERCHARTRANSITION") > 0 ||
         index(l, "GROUP_AG_JMPTBL_SCRIPT_BEGINBANN") > 0)) {
        has_banner_transition = 1
    }
    if (index(l, "CONFIG_MSNRUNTIMEMODESELECTORCHAR_LRBN") > 0 ||
        index(l, "CONFIG_MSNRUNTIMEMODESELECTORCHA") > 0) {
        if (l ~ /^MOVE\.B /) has_lrbn_selector_store = 1
        if ((index(l, "#78") > 0 || index(l, "#$4E") > 0 || index(l, "#'N'") > 0) ||
            ((index(prev, "#78") > 0 || index(prev, "#$4E") > 0 || index(prev, "#'N'") > 0) &&
             l ~ /^MOVE\.B /)) {
            has_lrbn_selector_default_n = 1
        }
    }
    if (index(l, "CONFIG_LRBN_FLAGCHAR") > 0 && l ~ /^MOVE\.B /) {
        has_lrbn_flag_store = 1
        lrbn_flag_store_count++
    }
    if ((index(l, "CONFIG_LRBN_FLAGCHAR") > 0 &&
         (index(l, "#89") > 0 || index(l, "#$59") > 0 || index(l, "#'Y'") > 0)) ||
        (index(l, "CONFIG_LRBN_FLAGCHAR") > 0 && l ~ /^MOVE\.B / &&
         ((index(prev, "#89") > 0 || index(prev, "#$59") > 0 || index(prev, "#'Y'") > 0) ||
          (index(prev2, "#89") > 0 || index(prev2, "#$59") > 0 || index(prev2, "#'Y'") > 0) ||
          (index(prev3, "#89") > 0 || index(prev3, "#$59") > 0 || index(prev3, "#'Y'") > 0) ||
          (index(prev4, "#89") > 0 || index(prev4, "#$59") > 0 || index(prev4, "#'Y'") > 0)))) {
        has_lrbn_force_y = 1
    }
    if (lrbn_flag_store_count >= 3) has_lrbn_force_y = 1
    if (index(l, "CONFIG_LRBN_FLAGCHAR") > 0 &&
        (index(l, "#'N'") > 0 || index(l, "#78") > 0 || index(l, "#$4E") > 0)) {
        has_lrbn_reset = 1
    }
    if (index(l, "CONFIG_MSN_FLAGCHAR") > 0 && l ~ /^MOVE\.B /) has_msn_flag_store = 1
    if (index(l, "CONFIG_MSN_FLAGCHAR") > 0 &&
        (index(l, "#78") > 0 || index(l, "#$4E") > 0 || index(l, "#'N'") > 0)) {
        has_msn_default_n = 1
    }
    if (index(l, "CTASKS_STR_1") > 0 && l ~ /^MOVE\.B /) has_ctasks1_store = 1
    if (index(l, "CTASKS_STR_1") > 0 &&
        ((index(l, "#49") > 0 || index(l, "#$31") > 0 || index(l, "#'1'") > 0) ||
         (index(l, "#50") > 0 || index(l, "#$32") > 0 || index(l, "#'2'") > 0))) has_ctasks1_fallback = 1
    if (index(l, "CTASKS_STR_1") > 0 && l ~ /^MOVE\.B D0,/ &&
        ((index(prev, "#49") > 0 || index(prev, "#$31") > 0 || index(prev, "#'1'") > 0 ||
          index(prev, "#50") > 0 || index(prev, "#$32") > 0 || index(prev, "#'2'") > 0) ||
         (index(prev2, "#49") > 0 || index(prev2, "#$31") > 0 || index(prev2, "#'1'") > 0 ||
          index(prev2, "#50") > 0 || index(prev2, "#$32") > 0 || index(prev2, "#'2'") > 0) ||
         (index(prev3, "#49") > 0 || index(prev3, "#$31") > 0 || index(prev3, "#'1'") > 0 ||
          index(prev3, "#50") > 0 || index(prev3, "#$32") > 0 || index(prev3, "#'2'") > 0))) has_ctasks1_fallback = 1

    if (is_call(l) &&
        (index(l, "ESQFUNC_UPDATEREFRESHMODESTATE") > 0 ||
         index(l, "GROUP_AG_JMPTBL_ESQFUNC_UPDATERE") > 0)) {
        has_refresh_update = 1
    }

    if (is_call(l) && index(l, "MATH_MULU32") > 0) has_mulu = 1
    if (index(l, "#60") > 0 || index(l, "#$3C") > 0 || index(l, "($3C)") > 0) {
        has_mulu_60 = 1
    }
    if (index(l, "CONFIG_REFRESHINTERVALMINUTES") > 0 && l ~ /^MOVE\.B /) has_store_minutes = 1
    if (index(l, "CONFIG_REFRESHINTERVALSECONDS") > 0 && l ~ /^MOVE\.L /) has_store_seconds = 1
    if (l ~ /^RTS$/) has_rts = 1

    prev5 = prev4
    prev4 = prev3
    prev3 = prev2
    prev2 = prev
    prev = l
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PARSE=" has_parse
    print "HAS_GUARD_CHECKS=" has_guard_checks
    print "HAS_SLOT08_DEFAULT_N=" has_slot08_default_n
    print "HAS_SLOT08_STORE=" has_slot08_store
    print "HAS_SLOT_A_DEFAULT=" has_slot_a_default
    print "HAS_SLOT10_DIGIT_CLAMP=" has_slot10_digit_clamp
    print "HAS_CUSTOM_BUDGET_DIGIT_CLAMP=" has_custom_budget_digit_clamp
    print "HAS_YES_NO_Y_FAMILY=" has_yes_no_y_family
    print "HAS_YES_NO_N_FAMILY=" has_yes_no_n_family
    print "HAS_BRUSH_SELECT=" has_brush_select
    print "HAS_LINE_MODE_STORE=" has_line_mode_store
    print "HAS_LINE_MODE_LSV=" has_line_mode_lsv
    print "HAS_SLOT19_STORE=" has_slot19_store
    print "HAS_SLOT20_STORE=" has_slot20_store
    print "HAS_SLOT25_STORE=" has_slot25_store
    print "HAS_SLOT26_STORE=" has_slot26_store
    print "HAS_ALT_SPAN_STORE=" has_alt_span_store
    print "HAS_TIME_WINDOW_STORE=" has_time_window_store
    print "HAS_GATE_DURATION_STORE=" has_gate_duration_store
    print "HAS_GATE_DURATION_CLAMP=" has_gate_duration_clamp
    print "HAS_SELECTION16_STORE=" has_selection16_store
    print "HAS_CLOCK_MODE_STORE=" has_clock_mode_store
    print "HAS_CLOCK_FORMAT_12HR=" has_clock_format_12hr
    print "HAS_CLOCK_FORMAT_24HR=" has_clock_format_24hr
    print "HAS_CLOCK_FORMAT_STORE=" has_clock_format_store
    print "HAS_LOGO_SCAN_STORE=" has_logo_scan_store
    print "HAS_BANNER_FORCE_128=" has_banner_force_128
    print "HAS_BANNER_DEFAULT_8E=" has_banner_default_8e
    print "HAS_BANNER_BOUNDS_CHECK=" has_banner_bounds_check
    print "HAS_PALETTE_FORCE_8=" has_palette_force_8
    print "HAS_DIAG_FIND=" has_diag_find
    print "HAS_DIAG_STORE=" has_diag_store
    print "HAS_DIAG_DEFAULT_N=" has_diag_default_n
    print "HAS_PC1_CALL=" has_pc1_call
    print "HAS_PC1_FLAG_STORE=" has_pc1_flag_store
    print "HAS_PC1_Y_GUARD=" has_pc1_y_guard
    print "HAS_LRBN_FIND=" has_lrbn_find
    print "HAS_LRBN_SELECTOR_STORE=" has_lrbn_selector_store
    print "HAS_LRBN_SELECTOR_DEFAULT_N=" has_lrbn_selector_default_n
    print "HAS_BANNER_TRANSITION=" has_banner_transition
    print "HAS_LRBN_FLAG_STORE=" has_lrbn_flag_store
    print "HAS_LRBN_FORCE_Y=" has_lrbn_force_y
    print "HAS_LRBN_RESET=" has_lrbn_reset
    print "HAS_MSN_FIND=" has_msn_find
    print "HAS_MSN_FLAG_STORE=" has_msn_flag_store
    print "HAS_MSN_DEFAULT_N=" has_msn_default_n
    print "HAS_CTASKS1_STORE=" has_ctasks1_store
    print "HAS_CTASKS1_FALLBACK=" has_ctasks1_fallback
    print "HAS_REFRESH_UPDATE=" has_refresh_update
    print "HAS_MULU=" has_mulu
    print "HAS_MULU_60=" has_mulu_60
    print "HAS_STORE_MINUTES=" has_store_minutes
    print "HAS_STORE_SECONDS=" has_store_seconds
    print "HAS_RTS=" has_rts
}
