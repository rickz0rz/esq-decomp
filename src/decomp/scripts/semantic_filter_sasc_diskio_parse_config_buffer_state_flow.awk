BEGIN {
    step_count = 0
    prev = ""
    prev2 = ""
    parse_hits = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    if (!seen[tag]) {
        seen[tag] = 1
        steps[++step_count] = tag
    }
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^DISKIO_PARSECONFIGBUFF[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (u ~ /PARSE_TWO_DIGITS/ || u ~ /PARSE_THREE_DIGITS/ ||
        u ~ /PARSE_READSIGNEDLONGSKIPCLASS3_ALT/) {
        parse_hits++
    }
    if (parse_hits >= 8) {
        mark("PARSE_FAMILY")
    }

    if (u ~ /CTASKS_STR_L/ && (u ~ /#76/ || u ~ /#\$4C/ || u ~ /#83/ ||
        u ~ /#\$53/ || u ~ /#86/ || u ~ /#\$56/ || u ~ /#'L'/ || u ~ /#'S'/ ||
        u ~ /#'V'/)) {
        mark("LINE_MODE_VALIDATE")
    }

    if (u ~ /CONFIG_TIMEWINDOWMINUTES/ && u ~ /^MOVE\.L /) {
        mark("TIME_WINDOW_STORE")
    }

    if (u ~ /CONFIG_MODECYCLEGATEDURATION/ &&
        ((u ~ /#1/ || u ~ /#\$1/) || (u ~ /#9/ || u ~ /#\$9/))) {
        mark("GATE_DURATION_CLAMP")
    }

    if (u ~ /BRUSH_SELECTBRUSHBYLABEL/) {
        mark("BRUSH_LABEL")
    }

    if (u ~ /GLOBAL_REF_STR_USE_24_HR_CLOCK/ && (u ~ /^MOVE\.B / || u ~ /^CLR\.B /)) {
        mark("CLOCK_MODE_STORE")
    }

    if (u ~ /GLOBAL_JMPTBL_HALF_HOURS_24_HR_F/ || u ~ /GLOBAL_JMPTBL_HALF_HOURS_12_HR_F/) {
        mark("CLOCK_FORMAT_SWITCH")
    }

    if (u ~ /CONFIG_BANNERCOPPERHEADBYTE/ &&
        (u ~ /#\$80/ || u ~ /#128/ || u ~ /#\$8E/ || u ~ /#142/ || u ~ /#\$DC/ || u ~ /#220/)) {
        mark("BANNER_COPPER_PARSE")
    }

    if ((u ~ /GLOBAL_REF_BYTE_NUMBER_OF_COLOR_/ &&
         (u ~ /#\$8/ || u ~ /#8/)) ||
        ((prev ~ /GLOBAL_REF_BYTE_NUMBER_OF_COLOR_/ || prev2 ~ /GLOBAL_REF_BYTE_NUMBER_OF_COLOR_/) &&
         (u ~ /#\$8/ || u ~ /#8/))) {
        mark("PALETTE_FORCE_8")
    }

    if (u ~ /ED_DIAGTEXTMODECHAR/ && (u ~ /^MOVE\.B / || u ~ /^CLR\.B /)) {
        mark("DIAG_STORE")
    }

    if (u ~ /STR_FINDCHARPTR/ && (prev ~ /DISKIO_TAG_NRLS/ || prev2 ~ /DISKIO_TAG_NRLS/)) {
        mark("DIAG_LOOKUP")
    }

    if (u ~ /CONFIG_ENSUREPC1GFXASSIGNEDFLAG/ &&
        (u ~ /^MOVE\.B / || u ~ /^CLR\.B /)) {
        mark("PC1_FLAG_STORE")
    }

    if (u ~ /DISKIO_ENSUREPC1MOUNTEDANDGFXASS/ ||
        u ~ /DISKIO_ENSUREPC1MOUNTEDANDGFXASSIGNED/) {
        mark("PC1_CALL")
    }

    if ((u ~ /CONFIG_MSNRUNTIMEMODESELECTORCHAR_LRBN/ ||
         u ~ /CONFIG_MSNRUNTIMEMODESELECTORCHA/) &&
        (u ~ /^MOVE\.B / || u ~ /^CLR\.B /)) {
        mark("LRBN_SELECTOR_STORE")
    }

    if (u ~ /STR_FINDCHARPTR/ && (prev ~ /DISKIO_TAG_LRBN/ || prev2 ~ /DISKIO_TAG_LRBN/)) {
        mark("LRBN_LOOKUP")
    }

    if (u ~ /CONFIG_LRBN_FLAGCHAR/ && (u ~ /^MOVE\.B / || u ~ /^CLR\.B /)) {
        mark("LRBN_FLAG_STORE")
    }

    if (u ~ /SCRIPT_BEGINBANNERCHARTRANSITION/ ||
        u ~ /GROUP_AG_JMPTBL_SCRIPT_BEGINBANN/) {
        mark("BANNER_TRANSITION")
    }

    if (seen["BANNER_TRANSITION"] &&
        u ~ /CONFIG_LRBN_FLAGCHAR/ &&
        (u ~ /#78/ || u ~ /#\$4E/ || u ~ /#'N'/)) {
        mark("LRBN_FLAG_RESET_N")
    }

    if (u ~ /CONFIG_MSN_FLAGCHAR/ && (u ~ /^MOVE\.B / || u ~ /^CLR\.B /)) {
        mark("MSN_FLAG_STORE")
    }

    if (u ~ /STR_FINDCHARPTR/ && (prev ~ /DISKIO_TAG_MSN/ || prev2 ~ /DISKIO_TAG_MSN/)) {
        mark("MSN_LOOKUP")
    }

    if (u ~ /CONFIG_MSN_FLAGCHAR/ && (u ~ /#78/ || u ~ /#\$4E/ || u ~ /#'N'/)) {
        mark("MSN_DEFAULT_N")
    }

    if (u ~ /CTASKS_STR_1/ && (u ~ /^MOVE\.B / || u ~ /^CLR\.B /)) {
        mark("TASKMODE_STORE")
    }

    if (u ~ /CTASKS_STR_1/ && (u ~ /#49/ || u ~ /#\$31/ || u ~ /#50/ || u ~ /#\$32/ || u ~ /#'1'/ || u ~ /#'2'/)) {
        mark("TASKMODE_VALIDATE")
    }

    if (u ~ /ESQFUNC_UPDATEREFRESHMODESTATE/ ||
        u ~ /GROUP_AG_JMPTBL_ESQFUNC_UPDATERE/) {
        mark("REFRESH_UPDATE")
    }

    if (u ~ /MATH_MULU32/ || u ~ /GROUP_AG_JMPTBL_MATH_MULU32/) {
        mark("REFRESH_MULU")
    }

    if (u ~ /CONFIG_REFRESHINTERVALSECONDS/ && u ~ /^MOVE\.L /) {
        mark("REFRESH_SECONDS_STORE")
    }

    if (u == "RTS") {
        mark("RTS")
    }

    prev2 = prev
    prev = u
}

END {
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }
}
