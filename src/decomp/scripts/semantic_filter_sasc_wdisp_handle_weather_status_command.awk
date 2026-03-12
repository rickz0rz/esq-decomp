BEGIN {
    has_entry=0
    has_cmd_gate=0
    has_clear_view=0
    has_build_ctx=0
    has_drop=0
    has_overlay=0
    has_summary=0
    has_reset=0
    has_capture0=0
    has_capture1=0
    has_capture2=0
    has_capture3=0
    has_capture_enable=0
    has_zero_sums_a=0
    has_zero_sums_b=0
    has_rise=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^WDISP_HANDLEWEATHERSTATUSCOMMAND:/ || u ~ /^WDISP_HANDLEWEATHERSTATUSCOMMAN[A-Z0-9_]*:/) has_entry=1
    if (u ~ /#48/ || u ~ /#51/ || u ~ /#\$30/ || u ~ /#\$33/) has_cmd_gate=1
    if (n ~ /TLIBA3CLEARVIEWMODERASTPORT/) has_clear_view=1
    if (n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIEWMODE/ || n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIE/) has_build_ctx=1
    if (n ~ /RUNCOPPERDROPTRANSITION/ || n ~ /RUNCOPPERDRO/) has_drop=1
    if (n ~ /WDISPDRAWWEATHERSTATUSOVERLAY/) has_overlay=1
    if (n ~ /WDISPDRAWWEATHERSTATUSSUMMARY/) has_summary=1
    if (n ~ /TEXTDISPRESETSELECTIONANDREFRESH/ || n ~ /TEXTDISPRESETSELECTIONANDREFRES/) has_reset=1
    if (n ~ /ACCUMULATORROW0CAPTUREVALUE/) has_capture0=1
    if (n ~ /ACCUMULATORROW1CAPTUREVALUE/) has_capture1=1
    if (n ~ /ACCUMULATORROW2CAPTUREVALUE/) has_capture2=1
    if (n ~ /ACCUMULATORROW3CAPTUREVALUE/) has_capture3=1
    if (n ~ /WDISPACCUMULATORCAPTUREACTIVE/) has_capture_enable=1
    if (n ~ /ACCUMULATORROW0SUM/ || n ~ /ACCUMULATORROW1SUM/ || n ~ /ACCUMULATORROW2SUM/ || n ~ /ACCUMULATORROW3SUM/) has_zero_sums_a=1
    if (n ~ /ACCUMULATORROW0SATURATEFLAG/ || n ~ /ACCUMULATORROW1SATURATEFLAG/ || n ~ /ACCUMULATORROW2SATURATEFLAG/ || n ~ /ACCUMULATORROW3SATURATEFLAG/) has_zero_sums_b=1
    if (n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPERRISETRANSITION/ || n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPERRISETRANSIT/ || n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPER/ || n ~ /ESQIFFRUNCOPPERRISETRANSITION/ || n ~ /ESQIFFRUNCOPPERRISETRANSIT/ || n ~ /ESQIFFRUNCOPPER/) has_rise=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CMD_GATE=" has_cmd_gate
    print "HAS_CLEAR_VIEW=" has_clear_view
    print "HAS_BUILD_CONTEXT=" has_build_ctx
    print "HAS_DROP_TRANSITION=" has_drop
    print "HAS_OVERLAY_DRAW=" has_overlay
    print "HAS_SUMMARY_DRAW=" has_summary
    print "HAS_RESET_FALLBACK=" has_reset
    print "HAS_CAPTURE0=" has_capture0
    print "HAS_CAPTURE1=" has_capture1
    print "HAS_CAPTURE2=" has_capture2
    print "HAS_CAPTURE3=" has_capture3
    print "HAS_CAPTURE_ENABLE=" has_capture_enable
    print "HAS_ZERO_SUMS=" (has_zero_sums_a && has_zero_sums_b)
    print "HAS_RISE_TRANSITION=" has_rise
    print "HAS_RTS=" has_rts
}
