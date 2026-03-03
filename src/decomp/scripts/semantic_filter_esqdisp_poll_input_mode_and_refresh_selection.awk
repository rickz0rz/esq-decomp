BEGIN {
    has_entry = 0
    has_refresh_tick = 0
    has_debounce = 0
    has_latch = 0
    has_setrast = 0
    has_reset = 0
    has_return = 0
}

function trim(s, t) {
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
    uline = toupper(line)

    if (uline ~ /^ESQDISP_POLLINPUTMODEANDREFRESHSELECTION:/) has_entry = 1
    if (uline ~ /GLOBAL_REFRESHTICKCOUNTER/) has_refresh_tick = 1
    if (uline ~ /ESQDISP_INPUTMODEDEBOUNCECOUNT/) has_debounce = 1
    if (uline ~ /ESQDISP_LATCHEDINPUTMODEBIT/) has_latch = 1
    if (uline ~ /ESQFUNC_JMPTBL_TEXTDISP_SETRASTFORMODE/) has_setrast = 1
    if (uline ~ /ESQFUNC_JMPTBL_TEXTDISP_RESETSELECTIONANDREFRESH/) has_reset = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_REFRESH_TICK=" has_refresh_tick
    print "HAS_DEBOUNCE=" has_debounce
    print "HAS_LATCH=" has_latch
    print "HAS_SETRAST=" has_setrast
    print "HAS_RESET=" has_reset
    print "HAS_RETURN=" has_return
}
