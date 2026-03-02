BEGIN {
    has_clear_view = 0
    has_build_view = 0
    has_set_effect = 0
    has_drop = 0
    has_restore = 0
    has_div = 0
    has_begin = 0
    has_textlen = 0
    has_setdrmd = 0
    has_setapen = 0
    has_move = 0
    has_text = 0
    has_copy = 0
    has_draw_inset = 0
    has_rise = 0
    has_wdisp_base = 0
    has_accum_active = 0
    has_accum_flush = 0
    has_gate = 0
    has_nib_primary = 0
    has_nib_secondary = 0
    has_terminal = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /TLIBA3CLEARVIEWMODERASTPORT/) has_clear_view = 1
    if (n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIEWMODE/) has_build_view = 1
    if (n ~ /WDISPJMPTBLESQSETCOPPEREFFECTONENABLEHIGHLIGHT/) has_set_effect = 1
    if (n ~ /WDISPJMPTBLESQIFFRUNCOPPERDROPTRANSITION/) has_drop = 1
    if (n ~ /WDISPJMPTBLESQIFFRESTOREBASEPALETTETRIPLES/) has_restore = 1
    if (n ~ /MATHDIVS32/) has_div = 1
    if (n ~ /SCRIPTBEGINBANNERCHARTRANSITION/) has_begin = 1
    if (n ~ /LVOTEXTLENGTH/) has_textlen = 1
    if (n ~ /LVOSETDRMD/) has_setdrmd = 1
    if (n ~ /LVOSETAPEN/) has_setapen = 1
    if (n ~ /LVOMOVE/) has_move = 1
    if (n ~ /LVOTEXT/) has_text = 1
    if (n ~ /STRINGCOPYPADNUL/) has_copy = 1
    if (n ~ /SCRIPTDRAWINSETTEXTWITHFRAME/) has_draw_inset = 1
    if (n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPERRISETRANSITION/) has_rise = 1
    if (n ~ /WDISPDISPLAYCONTEXTBASE/) has_wdisp_base = 1
    if (n ~ /WDISPACCUMULATORCAPTUREACTIVE/) has_accum_active = 1
    if (n ~ /WDISPACCUMULATORFLUSHPENDING/) has_accum_flush = 1
    if (n ~ /CLOCKALIGNEDINSETRENDERGATEFLAG/) has_gate = 1
    if (n ~ /CLEANUPALIGNEDINSETNIBBLEPRIMARY/) has_nib_primary = 1
    if (n ~ /CLEANUPALIGNEDINSETNIBBLESECONDARY/) has_nib_secondary = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_CLEAR_VIEW=" has_clear_view
    print "HAS_BUILD_VIEW=" has_build_view
    print "HAS_SET_EFFECT=" has_set_effect
    print "HAS_DROP=" has_drop
    print "HAS_RESTORE=" has_restore
    print "HAS_DIV=" has_div
    print "HAS_BEGIN=" has_begin
    print "HAS_TEXTLEN=" has_textlen
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_SETAPEN=" has_setapen
    print "HAS_MOVE=" has_move
    print "HAS_TEXT=" has_text
    print "HAS_COPY=" has_copy
    print "HAS_DRAW_INSET=" has_draw_inset
    print "HAS_RISE=" has_rise
    print "HAS_WDISP_BASE=" has_wdisp_base
    print "HAS_ACCUM_ACTIVE=" has_accum_active
    print "HAS_ACCUM_FLUSH=" has_accum_flush
    print "HAS_GATE=" has_gate
    print "HAS_NIB_PRIMARY=" has_nib_primary
    print "HAS_NIB_SECONDARY=" has_nib_secondary
    print "HAS_TERMINAL=" has_terminal
}
