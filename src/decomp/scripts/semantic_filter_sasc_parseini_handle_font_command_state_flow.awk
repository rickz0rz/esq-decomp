BEGIN {
    step_count = 0
    wait_call_count = 0
    fonttest_count = 0
    setfont_count = 0
    highlight_loop_mulu_count = 0
    highlight_loop_setfont_count = 0
    esc_enter_count = 0
    parse_context = ""
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    steps[++step_count] = tag
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)
    key = uline
    gsub(/[^A-Z0-9]/, "", key)

    if (uline ~ /^PARSEINI_HANDLEFONTCOMMAND:/ || uline ~ /^PARSEINI_HANDLEFONTCOMMAN[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (key ~ /PARSEINIJMPTBLWDISPSPRINTF/) {
        mark("FORMAT_EXECUTE_COMMAND")
    }

    if (key ~ /LVOEXECUTE/) {
        mark("EXECUTE_COMMAND")
    }

    if (key ~ /CONFIGPARSEINILOGOSCANENABLEDFL/ || (uline ~ /#\$59/ || uline ~ /#89/)) {
        mark("LOGO_SCAN_GATE")
    }

    if (key ~ /PARSEINISCANLOGODIRECTORY/) {
        mark("LOGO_SCAN_CALL")
    }

    if (key ~ /PARSEINIJMPTBLED1WAITFORFLAGANDCLEARBIT0/ || key ~ /PARSEINIJMPTBLED1WAITFORFLAGANDCLEARBIT1/ || key ~ /PARSEINIJMPTBLED1WAITFORFLAGA/) {
        wait_call_count++
        mark("WAIT_CALL_" wait_call_count)
    }

    if (key ~ /ESQFUNCREBUILDPWBRUSHLISTFROMTA/) {
        mark("REBUILD_PW_BRUSH_LIST")
    }

    if (key ~ /PARSEINITESTMEMORYANDOPENTOPAZFONT/ || key ~ /PARSEINITESTMEMORYANDOPENTOPAZF/) {
        fonttest_count++
        mark("FONTTEST_" fonttest_count)
    }

    if (key ~ /GLOBALUIBUSYFLAG/) {
        mark("H26F_UI_BUSY_GATE")
    }

    if (key ~ /SCRIPT3JMPTBLMATHMULU32/) {
        highlight_loop_mulu_count++
        if (highlight_loop_mulu_count == 1) {
            mark("HIGHLIGHT_LOOP_MULU")
        }
    }

    if (key ~ /LVOSETFONT/) {
        setfont_count++
        if (setfont_count == 1) {
            mark("SETFONT_H26F")
        } else if (setfont_count == 2) {
            mark("SETFONT_PREVUEC_CONTEXT")
        } else if (setfont_count == 3) {
            mark("SETFONT_PREVUEC_RASTPORT1")
        } else if (setfont_count == 4) {
            mark("SETFONT_PREVUEC_RASTPORT2")
        } else if (setfont_count == 5) {
            mark("SETFONT_PREVUEC_NEWGRID_MAIN")
        } else if (setfont_count == 6) {
            mark("SETFONT_PREVUEC_NEWGRID_HEADER")
        } else {
            highlight_loop_setfont_count++
            if (highlight_loop_setfont_count == 1) {
                mark("SETFONT_PREVUEC_HIGHLIGHT_LOOP")
            }
        }
    }

    if (key ~ /TLIBA3SETFONTFORALLVIEWMODES/) {
        mark("SETFONT_ALL_VIEW_MODES")
    }

    if (key ~ /PARSEINIJMPTBLDISKIO2PARSEINI/) {
        mark("PARSE_INI_FROM_DISK")
    }

    if (key ~ /ESQIFFHANDLEBRUSHINIRELOADHOTKE/ || key ~ /PARSEINIJMPTBLESQIFFHANDLEBRUSHINIRELOADHOTKE/) {
        mark("BRUSH_RELOAD_HOTKEY")
    }

    if (key ~ /GLOBALSTRDF0GRADIENTINI3/) {
        parse_context = "GRADIENT"
    } else if (key ~ /GLOBALSTRDF0BANNERINI2/) {
        parse_context = "BANNER_CHECK"
        mark("BANNER_PATH_CHECK")
    } else if (key ~ /GLOBALSTRDF0BANNERINI3/) {
        parse_context = "BANNER_PARSE"
    } else if (key ~ /GLOBALSTRDF0DEFAULTINI2/) {
        parse_context = "DEFAULT"
    } else if (key ~ /GLOBALSTRDF0SOURCECFGINI1/) {
        parse_context = "SOURCECFG"
    }

    if (key ~ /SCRIPTCHECKPATHEXISTS/) {
        mark("CHECK_BANNER_PATH_EXISTS")
    }

    if (key ~ /CTASKSIFFTASKDONEFLAG/) {
        mark("WAIT_BANNER_TASK_READY")
    }

    if (key ~ /BRUSHFREEBRUSHLIST/ || key ~ /PARSEINIJMPTBLBRUSHFREEBRUSHLIST/) {
        mark("FREE_WEATHER_STATUS_BRUSH_LIST")
    }

    if (key ~ /BRUSHFREEBRUSHRESOURCES/ || key ~ /PARSEINIJMPTBLBRUSHFREEBRUSHRESOURCES/) {
        mark("FREE_BANNER_BRUSH_RESOURCES")
    }

    if (key ~ /PARSEINIPARSEINIBUFFERANDDISPAT/) {
        if (parse_context == "GRADIENT") {
            mark("PARSE_GRADIENT_INI")
        } else if (parse_context == "BANNER_PARSE") {
            mark("PARSE_BANNER_INI")
        } else if (parse_context == "DEFAULT") {
            mark("PARSE_DEFAULT_INI")
        } else if (parse_context == "SOURCECFG") {
            mark("PARSE_SOURCECFG_INI")
        } else {
            mark("PARSE_INI_DISPATCH")
        }
        parse_context = ""
    }

    if (key ~ /ESQIFFQUEUEIFFBRUSHLOAD/ || key ~ /PARSEINIJMPTBLESQIFFQUEUEIFFBRUSHLOAD/) {
        mark("QUEUE_BANNER_BRUSH_LOAD")
    }

    if (key ~ /TEXTDISPAPPLYSOURCECONFIGALLENT/) {
        mark("APPLY_SOURCE_CONFIG")
    }

    if (key ~ /PARSEINIJMPTBLED1ENTERESCMENU/) {
        esc_enter_count++
        mark("ENTER_ESC_MENU_" esc_enter_count)
    }

    if (key ~ /PARSEINIJMPTBLED1EXITESCMENU/) {
        mark("EXIT_ESC_MENU")
    }

    if (key ~ /PARSEINIJMPTBLED1DRAWDIAGNOST/) {
        mark("DRAW_DIAGNOSTICS_SCREEN")
    }

    if (key ~ /ESQFUNCDRAWESCMENUVERSION/ || key ~ /PARSEINIJMPTBLESQFUNCDRAWESCMENUVERSION/) {
        mark("DRAW_ESC_MENU_VERSION")
    }

    if (uline == "RTS") {
        mark("RTS")
    }
}

END {
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }
    print "WAIT_CALL_COUNT=" wait_call_count
    print "FONTTEST_COUNT=" fonttest_count
    print "SETFONT_COUNT=" setfont_count
    print "HIGHLIGHT_LOOP_MULU_COUNT=" highlight_loop_mulu_count
    print "HIGHLIGHT_LOOP_SETFONT_COUNT=" highlight_loop_setfont_count
    print "ESC_ENTER_COUNT=" esc_enter_count
}
