BEGIN {
    has_entry=0
    has_setrast=0
    has_day_gate=0
    has_day_entry_call=0
    has_fallback_ptr=0
    has_text_length=0
    has_move=0
    has_text=0
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

    if (u ~ /^WDISP_DRAWWEATHERSTATUSSUMMARY:/ || u ~ /^WDISP_DRAWWEATHERSTATUSSUMMAR[A-Z0-9_]*:/) has_entry=1
    if (n ~ /LVOSETRAST/) has_setrast=1
    if (n ~ /TLIBA1DAYENTRYMODECOUNTER/ || n ~ /WDISPWEATHERSTATUSDIGITCHAR/) has_day_gate=1
    if (n ~ /WDISPDRAWWEATHERSTATUSDAYENTRY/) has_day_entry_call=1
    if (n ~ /PTYPEWEATHERFORECASTMSGPTR/ || n ~ /SCRIPTPTRNOFORECASTWEATHERDATA/) has_fallback_ptr=1
    if (n ~ /LVOTEXTLENGTH/) has_text_length=1
    if (n ~ /LVOMOVE/) has_move=1
    if (n ~ /LVOTEXT/) has_text=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SETRAST=" has_setrast
    print "HAS_DAY_GATE=" has_day_gate
    print "HAS_DAY_ENTRY_CALL=" has_day_entry_call
    print "HAS_FALLBACK_PTR=" has_fallback_ptr
    print "HAS_TEXT_LENGTH=" has_text_length
    print "HAS_MOVE=" has_move
    print "HAS_TEXT=" has_text
    print "HAS_RTS=" has_rts
}
