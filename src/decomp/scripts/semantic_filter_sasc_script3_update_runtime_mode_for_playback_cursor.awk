BEGIN {
    has_entry = 0
    has_begin_transition = 0
    has_enable_highlight = 0
    has_set_rast = 0
    has_update_shadow = 0
    has_clear_search = 0
    has_deassert = 0
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
    u = toupper(line)

    if (u ~ /^SCRIPT_UPDATERUNTIMEMODEFORPLAYBACKCURSOR:/ || u ~ /^SCRIPT_UPDATERUNTIMEMODEFORPLAYBAC[A-Z0-9_]*:/ || u ~ /^SCRIPT_UPDATERUNTIMEMODEFORPLAYB[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "SCRIPT_BEGINBANNERCHARTRANSITION") > 0 || index(u, "SCRIPT_BEGINBANNERCHARTR") > 0) has_begin_transition = 1
    if (index(u, "WDISP_JMPTBL_ESQ_SETCOPPEREFFECT_ONENABLEHIGHLIGHT") > 0 || index(u, "WDISP_JMPTBL_ESQ_SETCOPPEREFF") > 0 || index(u, "WDISP_JMPTBL_ESQ_SETCOPPEREFFECT") > 0 || index(u, "ESQ_SETCOPPEREFFECT_ONENABLEHIGHLIGHT") > 0 || index(u, "ESQ_SETCOPPEREFFECT_ONENABLEHIGHL") > 0 || index(u, "ESQ_SETCOPPEREFFECT_ONENABLE") > 0) has_enable_highlight = 1
    if (index(u, "TEXTDISP_SETRASTFORMODE") > 0 || index(u, "TEXTDISP_SETRASTFORMOD") > 0) has_set_rast = 1
    if (index(u, "SCRIPT_UPDATESERIALSHADOWFROMCTRLBYTE") > 0 || index(u, "SCRIPT_UPDATESERIALSHADOWFR") > 0 || index(u, "SCRIPT_UPDATESERIALSHADOWFROMCTR") > 0) has_update_shadow = 1
    if (index(u, "SCRIPT_CLEARSEARCHTEXTSANDCHANNELS") > 0 || index(u, "SCRIPT_CLEARSEARCHTEXTSANDCHAN") > 0 || index(u, "SCRIPT_CLEARSEARCHTEXTSANDCHANNE") > 0) has_clear_search = 1
    if (index(u, "SCRIPT_DEASSERTCTRLLINENOW") > 0 || index(u, "SCRIPT_DEASSERTCTRLLINENO") > 0) has_deassert = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_BEGIN_TRANSITION=" has_begin_transition
    print "HAS_ENABLE_HIGHLIGHT=" has_enable_highlight
    print "HAS_SET_RAST=" has_set_rast
    print "HAS_UPDATE_SHADOW=" has_update_shadow
    print "HAS_CLEAR_SEARCH=" has_clear_search
    print "HAS_DEASSERT=" has_deassert
    print "HAS_RETURN=" has_return
}
