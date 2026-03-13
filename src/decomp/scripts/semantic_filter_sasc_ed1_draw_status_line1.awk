BEGIN {
    has_printf = 0
    has_draw = 0
    has_y210 = 0
    has_state_idx = 0
    has_fmt = 0
    has_ctx = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = trim($0)
    if (l == "") next

    if (l ~ /(JSR|BSR).*(GROUP_AM_JMPTBL_WDISP_SPRINTF|WDISP_SPRINTF)/) has_printf = 1
    if (l ~ /(JSR|BSR).*(ESQFUNC_JMPTBL_TLIBA3_DRAWCENTER|TLIBA3_DRAWCENTER)/) has_draw = 1
    if (l ~ /^PEA 210\.W$/ || l ~ /^PEA \(\$D2\)\.W$/ || l ~ /^MOVE\.L #\$?D2,-\(A7\)$/ || l ~ /^MOVE\.W #\$?D2,-\(A7\)$/) has_y210 = 1
    if (l ~ /ESQPARS2_STATEINDEX/) has_state_idx = 1
    if (l ~ /ED2_FMT_SCRSPD_PCT_D/) has_fmt = 1
    if (l ~ /WDISP_DISPLAYCONTEXTBASE/) has_ctx = 1
    if (l == "RTS") has_rts = 1
}

END {
    print "HAS_PRINTF=" has_printf
    print "HAS_DRAW=" has_draw
    print "HAS_Y210=" has_y210
    print "HAS_STATE_IDX=" has_state_idx
    print "HAS_FMT=" has_fmt
    print "HAS_CTX=" has_ctx
    print "HAS_RTS=" has_rts
}
