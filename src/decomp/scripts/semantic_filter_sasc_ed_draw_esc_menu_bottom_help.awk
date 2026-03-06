BEGIN {
    has_mode1 = 0
    has_bg = 0
    has_help = 0
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

    if (l ~ /^MOVE\.B #\$?1,ED_MENUSTATEID(\(A[0-7]\))?$/) has_mode1 = 1
    if (l ~ /(JSR|BSR).*ED_DRAWBOTTOMHELPBARBACKGROUND/) has_bg = 1
    if (l ~ /(JSR|BSR).*ED_DRAWESCMENUHELPTEXT/) has_help = 1
    if (l == "RTS") has_rts = 1
}

END {
    print "HAS_MODE1=" has_mode1
    print "HAS_BG=" has_bg
    print "HAS_HELP=" has_help
    print "HAS_RTS=" has_rts
}
