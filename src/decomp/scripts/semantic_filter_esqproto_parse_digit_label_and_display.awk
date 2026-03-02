BEGIN {
    has_label = 0
    has_digit_global = 0
    has_label_global = 0
    has_text_ptr_global = 0
    has_replace_call = 0
    has_diag_test = 0
    has_display_call = 0
    has_rts = 0
}

/^ESQPROTO_ParseDigitLabelAndDisplay:$/ {
    has_label = 1
}

/WDISP_WeatherStatusDigitChar/ {
    has_digit_global = 1
}

/WDISP_WeatherStatusLabelBuffer/ {
    has_label_global = 1
}

/WDISP_WeatherStatusTextPtr/ {
    has_text_ptr_global = 1
}

/ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString/ {
    has_replace_call = 1
}

/ED_DiagnosticsScreenActive/ {
    has_diag_test = 1
}

/UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition/ {
    has_display_call = 1
}

/^RTS$/ {
    has_rts = 1
}

END {
    if (has_label) print "HAS_LABEL"
    if (has_digit_global) print "HAS_DIGIT_GLOBAL"
    if (has_label_global) print "HAS_LABEL_BUFFER"
    if (has_text_ptr_global) print "HAS_TEXT_PTR"
    if (has_replace_call) print "HAS_REPLACE_CALL"
    if (has_diag_test) print "HAS_DIAG_TEST"
    if (has_display_call) print "HAS_DISPLAY_CALL"
    if (has_rts) print "HAS_RTS"
}
