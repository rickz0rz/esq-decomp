BEGIN {
    step_count = 0
    pending_fallback = 0
    pending_overlay = 0
    saw_gads_head = 0
    saw_logo_head = 0
    saw_match_index_window = 0
    saw_comma_flag = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    if (!(tag in seen)) {
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
    uline = toupper(line)

    if (uline ~ /^ESQIFF_PLAYNEXTEXTERNALASSETFRAM/) {
        mark("ENTRY")
    }

    if (uline ~ /ESQIFF_RUNCOPPERDROPTRANSITION/) {
        mark("RUN_DROP")
    }

    if (uline ~ /ESQIFF_GADSBRUSHLISTHEAD/) {
        saw_gads_head = 1
    }

    if (uline ~ /ESQIFF_LOGOBRUSHLISTHEAD/) {
        saw_logo_head = 1
    }

    if (uline ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/ || uline ~ /ESQIFF_EXTERNALASSETSTATETABLE/) {
        saw_match_index_window = 1
    }

    if (uline ~ /ESQIFF_EXTERNALASSETPATHCOMMAFLA/) {
        saw_comma_flag = 1
        pending_overlay = 1
    }

    if (uline ~ /ESQIFF_RESTOREBASEPALETTETRIPLES/) {
        if (!seen["FALLBACK_RESTORE_BASE_PALETTE"]) {
            mark("FALLBACK_RESTORE_BASE_PALETTE")
            pending_fallback = 1
        } else if (pending_overlay) {
            mark("OVERLAY_RESTORE_BASE_PALETTE")
        }
    }

    if (uline ~ /ESQ_SETCOPPEREFFECT_OFFDISABLEHI/ ||
        uline ~ /GROUP_AM_JMPTBL_ESQ_SETCOPPEREFFECT_OFFDISABLEHIGHLIGHT/) {
        if (pending_fallback) {
            mark("FALLBACK_DISABLE_HIGHLIGHT")
        } else {
            mark("PREPARE_DISABLE_HIGHLIGHT")
        }
    }

    if (uline ~ /TEXTDISP_SETRASTFORMODE/ || uline ~ /ESQFUNC_JMPTBL_TEXTDISP_SETRASTFORMODE/) {
        if (pending_fallback) {
            mark("FALLBACK_SET_RAST_MODE_2")
            pending_fallback = 0
        }
    }

    if (uline ~ /TLIBA3_BUILDDISPLAYCONTEXTFORVIE/ ||
        uline ~ /ESQIFF_JMPTBL_TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE/) {
        mark("BUILD_DISPLAY_CONTEXT")
    }

    if (uline ~ /_LVOSETRAST/) {
        mark("CLEAR_DISPLAY_RAST")
    }

    if (uline ~ /ESQDISP_PROCESSGRIDMESSAGESIFIDL/) {
        mark("PROCESS_GRID_MESSAGES")
    }

    if (uline ~ /ESQIFF_JMPTBL_ESQ_NOOP/ || uline ~ /ESQ_NOOP/) {
        mark("NO_OP_SYNC")
    }

    if (uline ~ /SCRIPT_ASSERTCTRLLINEIFENABLED/ ||
        uline ~ /ESQIFF_JMPTBL_SCRIPT_ASSERTCTRLLINEIFENABLED/) {
        mark("ASSERT_CTRL_LINE_IF_DEFERRED")
    }

    if (uline ~ /ESQIFF_SHOWEXTERNALASSETWITHCOPP/ ||
        uline ~ /ESQIFF_SHOWEXTERNALASSETWITHCOPPERFX/) {
        mark("SHOW_EXTERNAL_ASSET")
    }

    if (uline ~ /_LVOSETDRMD/) {
        if (!seen["SET_DRAWMODE_ZERO"]) {
            mark("SET_DRAWMODE_ZERO")
        } else {
            mark("RESTORE_DRAWMODE_ONE")
        }
    }

    if (uline ~ /ESQIFF_SETAPENTOBRIGHTESTPALETTE/ || uline ~ /ESQIFF_SETAPENTOBRIGHTESTPALETTEINDEX/) {
        mark("SET_BRIGHTEST_APEN")
    }

    if (uline ~ /TEXTDISP_CURRENTMATCHINDEX/ && uline ~ /ESQIFF_EXTERNALASSETSTATETABLE/) {
        mark("STORE_MATCH_INDEX")
    }

    if (uline ~ /TEXTDISP_DRAWCHANNELBANNER/ ||
        uline ~ /ESQIFF_JMPTBL_TEXTDISP_DRAWCHANNELBANNER/) {
        mark("DRAW_CHANNEL_BANNER")
    }

    if (uline ~ /_LVOSETAPEN/) {
        mark("SET_APEN_ONE")
    }

    if (uline ~ /_LVOFORBID/) {
        mark("FORBID_EXEC")
    }

    if (uline ~ /ESQIFF_GADSBRUSHLISTCOUNT/) {
        mark("DECREMENT_GADS_COUNT")
    }

    if (uline ~ /ESQIFF_LOGOBRUSHLISTCOUNT/) {
        mark("DECREMENT_LOGO_COUNT")
    }

    if (uline ~ /BRUSH_POPBRUSHHEAD/ || uline ~ /ESQIFF_JMPTBL_BRUSH_POPBRUSHHEAD/) {
        mark("POP_BRUSH_HEAD")
    }

    if (uline ~ /_LVOPERMIT/) {
        mark("PERMIT_EXEC")
    }

    if (uline ~ /WDISP_ACCUMULATORCAPTUREACTIVE/ && uline ~ /^MOVE\.W /) {
        if (!seen["SAVE_ACCUMULATOR_FLAG"]) {
            mark("SAVE_ACCUMULATOR_FLAG")
        } else {
            mark("RESTORE_ACCUMULATOR_FLAG")
        }
    }

    if (uline ~ /^CLR\.W WDISP_ACCUMULATORCAPTUREACTIVE/ ||
        uline ~ /^CLR\.W WDISP_ACCUMULATORCAPTUREACTIVE\(A4\)/) {
        mark("CLEAR_ACCUMULATOR_FLAG")
    }

    if (uline ~ /ESQIFF_RUNCOPPERRISETRANSITION/) {
        mark("RUN_RISE")
    }

    if (uline ~ /ESQIFF_SERVICEEXTERNALASSETSOURC/ ||
        uline ~ /ESQIFF_SERVICEEXTERNALASSETSOURCESTATE/) {
        mark("SERVICE_SOURCE_STATE")
    }

    if (uline ~ /ESQIFF_PLAYNEXTEXTERNALASSETFRAME_RETURN/ || uline == "RTS") {
        mark("RETURN")
    }
}

END {
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }

    if (saw_gads_head) {
        print "FLAG:CHECK_GADS_HEAD"
    }
    if (saw_logo_head) {
        print "FLAG:CHECK_LOGO_HEAD"
    }
    if (saw_match_index_window) {
        print "FLAG:CHECK_MATCH_INDEX_WINDOW"
    }
    if (saw_comma_flag) {
        print "FLAG:CHECK_COMMA_FLAG"
    }
}
