BEGIN {
    has_label = 0
    has_wildcard_call = 0
    has_replace_call = 0
    has_display_call = 0
    has_overlay_ptr = 0
    has_countdown = 0
    has_color = 0
    has_brush = 0
    has_diag = 0
    has_rts = 0
}

/^UNKNOWN_ParseRecordAndUpdateDisplay:$/ { has_label = 1 }
/UNKNOWN_JMPTBL_ESQ_WildcardMatch/ { has_wildcard_call = 1 }
/ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString/ { has_replace_call = 1 }
/UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition/ { has_display_call = 1 }
/WDISP_WeatherStatusOverlayTextPtr/ { has_overlay_ptr = 1 }
/WDISP_WeatherStatusCountdown/ { has_countdown = 1 }
/WDISP_WeatherStatusColorCode/ { has_color = 1 }
/WDISP_WeatherStatusBrushIndex/ { has_brush = 1 }
/ED_DiagnosticsScreenActive/ { has_diag = 1 }
/^RTS$/ { has_rts = 1 }

END {
    if (has_label) print "HAS_LABEL"
    if (has_wildcard_call) print "HAS_WILDCARD_CALL"
    if (has_replace_call) print "HAS_REPLACE_CALL"
    if (has_display_call) print "HAS_DISPLAY_CALL"
    if (has_overlay_ptr) print "HAS_OVERLAY_PTR"
    if (has_countdown) print "HAS_COUNTDOWN"
    if (has_color) print "HAS_COLOR"
    if (has_brush) print "HAS_BRUSH"
    if (has_diag) print "HAS_DIAG_TEST"
    if (has_rts) print "HAS_RTS"
}
