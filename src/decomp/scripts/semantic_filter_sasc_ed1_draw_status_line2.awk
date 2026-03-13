BEGIN {
    has_setrast = 0
    has_printf = 0
    has_draw = 0
    has_fmt_a = 0
    has_fmt_b = 0
    has_fmt_c = 0
    has_y120 = 0
    has_y150 = 0
    has_y180 = 0
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

    if (l ~ /(JSR|BSR).*_LVOSETRAST/) has_setrast = 1
    if (l ~ /(JSR|BSR).*(GROUP_AM_JMPTBL_WDISP_SPRINTF|WDISP_SPRINTF)/) has_printf = 1
    if (l ~ /(JSR|BSR).*(ESQFUNC_JMPTBL_TLIBA3_DRAWCENTER|TLIBA3_DRAWCENTER)/) has_draw = 1

    if (l ~ /ED2_FMT_MR_PCT_D_SBS_PCT_D_SPORT/) has_fmt_a = 1
    if (l ~ /ED2_FMT_CYCLE_PCT_C_CYCLEFREQ_PC/ || l ~ /ED2_FMT_CYCLE_PCT_C_CYCLEFREQ_PCT_D_AFTRORDR/) has_fmt_b = 1
    if (l ~ /GLOBAL_STR_CLOCKCMD_EQUALS_PCT_C/) has_fmt_c = 1

    if (l ~ /^PEA 120\.W$/ || l ~ /^PEA \(\$78\)\.W$/ || l ~ /^MOVE\.L #\$?78,-\(A7\)$/ || l ~ /^MOVE\.W #\$?78,-\(A7\)$/) has_y120 = 1
    if (l ~ /^PEA 150\.W$/ || l ~ /^PEA \(\$96\)\.W$/ || l ~ /^MOVE\.L #\$?96,-\(A7\)$/ || l ~ /^MOVE\.W #\$?96,-\(A7\)$/) has_y150 = 1
    if (l ~ /^PEA 180\.W$/ || l ~ /^PEA \(\$B4\)\.W$/ || l ~ /^MOVE\.L #\$?B4,-\(A7\)$/ || l ~ /^MOVE\.W #\$?B4,-\(A7\)$/) has_y180 = 1

    if (l == "RTS") has_rts = 1
}

END {
    print "HAS_SETRAST=" has_setrast
    print "HAS_PRINTF=" has_printf
    print "HAS_DRAW=" has_draw
    print "HAS_FMT_A=" has_fmt_a
    print "HAS_FMT_B=" has_fmt_b
    print "HAS_FMT_C=" has_fmt_c
    print "HAS_Y120=" has_y120
    print "HAS_Y150=" has_y150
    print "HAS_Y180=" has_y180
    print "HAS_RTS=" has_rts
}
