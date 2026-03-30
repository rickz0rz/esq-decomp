BEGIN {
    build_ctx_count=0
    seq_count=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(key) {
    if (!(key in seen)) {
        seen[key]=1
        seq[++seq_count]=key
    }
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^WDISP_HANDLEWEATHERSTATUSCOMMAND:/ || u ~ /^WDISP_HANDLEWEATHERSTATUSCOMMAN[A-Z0-9_]*:/) mark("ENTRY")
    if (u ~ /#48/ || u ~ /#\$30/) mark("CHECK_CMD_48")
    if (u ~ /#51/ || u ~ /#\$33/) mark("CHECK_CMD_51")
    if (n ~ /TEXTDISPRESETSELECTIONANDREFRESH/ || n ~ /TEXTDISPRESETSELECTIONANDREFRES/) mark("RESET_FALLBACK")
    if (n ~ /TLIBA3CLEARVIEWMODERASTPORT/) mark("CLEAR_VIEW_MODE4")
    if (n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIEWMODE/ || n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIE/) {
        build_ctx_count++
        mark("BUILD_CONTEXT_" build_ctx_count)
    }
    if (n ~ /ESQSETCOPPEREFFECTONENABLEHIGHLIGHT/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGH/) mark("ENABLE_HIGHLIGHT")
    if (n ~ /ESQIFFRESTOREBASEPALETTETRIPLES/) mark("RESTORE_BASE_PALETTE")
    if (n ~ /ESQIFFRUNCOPPERDROPTRANSITION/ || n ~ /ESQIFFRUNCOPPERDROPTRANSIT/ || n ~ /RUNCOPPERDROPTRANSITION/ || n ~ /RUNCOPPERDRO/) mark("DROP_TRANSITION")
    if (n ~ /LVOSETDRMD/) mark("SET_DRMD")
    if (n ~ /LVOSETAPEN/) mark("SET_APEN")
    if (n ~ /LVOSETFONT/) mark("SET_FONT")
    if (n ~ /WDISPDRAWWEATHERSTATUSOVERLAY/) mark("DRAW_OVERLAY")
    if (n ~ /WDISPDRAWWEATHERSTATUSSUMMARY/) mark("DRAW_SUMMARY")

    if (n ~ /WDISPACCUMULATORROW0COPPERINDEXSTART/ || n ~ /WDISPACCUMULATORROWTABLE6A4/) mark("ROW0_START")
    if (n ~ /WDISPACCUMULATORROW0COPPERINDEXEND/ || n ~ /WDISPACCUMULATORROWTABLE7A4/) mark("ROW0_END")
    if (n ~ /WDISPACCUMULATORROW0VALUE/ || n ~ /WDISPACCUMULATORROWTABLE2A4/) mark("ROW0_VALUE")
    if (n ~ /ACCUMULATORROW0CAPTUREVALUE/) mark("ROW0_CAPTURE")

    if (n ~ /WDISPACCUMULATORROW1COPPERINDEXSTART/ || n ~ /WDISPACCUMULATORROWTABLEEA4/) mark("ROW1_START")
    if (n ~ /WDISPACCUMULATORROW1COPPERINDEXEND/ || n ~ /WDISPACCUMULATORROWTABLEFA4/) mark("ROW1_END")
    if (n ~ /WDISPACCUMULATORROW1VALUE/ || n ~ /WDISPACCUMULATORROWTABLEAA4/) mark("ROW1_VALUE")
    if (n ~ /ACCUMULATORROW1CAPTUREVALUE/) mark("ROW1_CAPTURE")

    if (n ~ /WDISPACCUMULATORROW2COPPERINDEXSTART/ || n ~ /WDISPACCUMULATORROWTABLE16A4/) mark("ROW2_START")
    if (n ~ /WDISPACCUMULATORROW2COPPERINDEXEND/ || n ~ /WDISPACCUMULATORROWTABLE17A4/) mark("ROW2_END")
    if (n ~ /WDISPACCUMULATORROW2VALUE/ || n ~ /WDISPACCUMULATORROWTABLE12A4/) mark("ROW2_VALUE")
    if (n ~ /ACCUMULATORROW2CAPTUREVALUE/) mark("ROW2_CAPTURE")

    if (n ~ /WDISPACCUMULATORROW3COPPERINDEXSTART/ || n ~ /WDISPACCUMULATORROWTABLE1EA4/) mark("ROW3_START")
    if (n ~ /WDISPACCUMULATORROW3COPPERINDEXEND/ || n ~ /WDISPACCUMULATORROWTABLE1FA4/) mark("ROW3_END")
    if (n ~ /WDISPACCUMULATORROW3VALUE/ || n ~ /WDISPACCUMULATORROWTABLE1AA4/) mark("ROW3_VALUE")
    if (n ~ /ACCUMULATORROW3CAPTUREVALUE/) mark("ROW3_CAPTURE")

    if (n ~ /WDISPACCUMULATORCAPTUREACTIVE/) mark("CAPTURE_ACTIVE")
    if (n ~ /ACCUMULATORROW0SUM/ || n ~ /ACCUMULATORROW1SUM/ || n ~ /ACCUMULATORROW2SUM/ || n ~ /ACCUMULATORROW3SUM/) mark("RESET_ROW_SUMS")
    if (n ~ /ACCUMULATORROW0SATURATEFLAG/ || n ~ /ACCUMULATORROW1SATURATEFLAG/ || n ~ /ACCUMULATORROW2SATURATEFLAG/ || n ~ /ACCUMULATORROW3SATURATEFLAG/) mark("RESET_ROW_FLAGS")
    if (n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPERRISETRANSITION/ || n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPERRISETRANSIT/ || n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPER/ || n ~ /ESQIFFRUNCOPPERRISETRANSITION/ || n ~ /ESQIFFRUNCOPPERRISETRANSIT/ || n ~ /ESQIFFRUNCOPPER/) mark("RISE_TRANSITION")
    if (u == "RTS") mark("RTS")
}

END {
    order_count=0
    order[++order_count]="ENTRY"
    order[++order_count]="CHECK_CMD_48"
    order[++order_count]="CHECK_CMD_51"
    order[++order_count]="CLEAR_VIEW_MODE4"
    order[++order_count]="BUILD_CONTEXT_1"
    order[++order_count]="ENABLE_HIGHLIGHT"
    order[++order_count]="RESTORE_BASE_PALETTE"
    order[++order_count]="DROP_TRANSITION"
    order[++order_count]="BUILD_CONTEXT_2"
    order[++order_count]="SET_DRMD"
    order[++order_count]="SET_APEN"
    order[++order_count]="SET_FONT"
    order[++order_count]="DRAW_OVERLAY"
    order[++order_count]="DRAW_SUMMARY"
    order[++order_count]="BUILD_CONTEXT_3"
    order[++order_count]="ROW0_START"
    order[++order_count]="ROW0_END"
    order[++order_count]="ROW0_VALUE"
    order[++order_count]="ROW0_CAPTURE"
    order[++order_count]="ROW1_START"
    order[++order_count]="ROW1_END"
    order[++order_count]="ROW1_VALUE"
    order[++order_count]="ROW1_CAPTURE"
    order[++order_count]="ROW2_START"
    order[++order_count]="ROW2_END"
    order[++order_count]="ROW2_VALUE"
    order[++order_count]="ROW2_CAPTURE"
    order[++order_count]="ROW3_START"
    order[++order_count]="ROW3_END"
    order[++order_count]="ROW3_VALUE"
    order[++order_count]="ROW3_CAPTURE"
    order[++order_count]="CAPTURE_ACTIVE"
    order[++order_count]="RESET_ROW_SUMS"
    order[++order_count]="RESET_ROW_FLAGS"
    order[++order_count]="RISE_TRANSITION"
    order[++order_count]="RESET_FALLBACK"
    order[++order_count]="RTS"

    for (i=1; i<=order_count; i++) {
        if (order[i] in seen) {
            print order[i]
        }
    }
}
