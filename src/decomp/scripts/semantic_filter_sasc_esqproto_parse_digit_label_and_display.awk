BEGIN {
    has_digit_global = 0
    has_label_buffer = 0
    has_text_ptr = 0
    has_replace_call = 0
    has_diag_test = 0
    has_display_call = 0
    has_rts_or_jmp = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /WDISP_WEATHERSTATUSDIGITCHAR/) has_digit_global = 1
    if (u ~ /WDISP_WEATHERSTATUSLABELBUFFER/) has_label_buffer = 1
    if (u ~ /WDISP_WEATHERSTATUSTEXTPTR/) has_text_ptr = 1
    if (u ~ /ESQPROTO_JMPTBL_ESQPARS_REPLACEO/ || u ~ /ESQPROTO_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/) has_replace_call = 1
    if (u ~ /ED_DIAGNOSTICSSCREENACTIVE/) has_diag_test = 1
    if (u ~ /UNKNOWN_JMPTBL_DISPLIB_DISPLAYT/ || u ~ /UNKNOWN_JMPTBL_DISPLIB_DISPLAYTEXTATPOSITION/) has_display_call = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_DIGIT_GLOBAL=" has_digit_global
    print "HAS_LABEL_BUFFER=" has_label_buffer
    print "HAS_TEXT_PTR=" has_text_ptr
    print "HAS_REPLACE_CALL=" has_replace_call
    print "HAS_DIAG_TEST=" has_diag_test
    print "HAS_DISPLAY_CALL=" has_display_call
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
