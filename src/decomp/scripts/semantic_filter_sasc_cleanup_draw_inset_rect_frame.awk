BEGIN {
    has_label = 0
    has_setapen = 0
    has_rectfill = 0
    has_move = 0
    has_draw = 0
    has_restore_pen_move = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_DRAWINSETRECTFRAME[A-Z0-9_]*:/) has_label = 1
    if (u ~ /_LVOSETAPEN/) has_setapen = 1
    if (u ~ /_LVORECTFILL/) has_rectfill = 1
    if (u ~ /_LVOMOVE/) has_move = 1
    if (u ~ /_LVODRAW/) has_draw = 1
    if (u ~ /MOVE.L D4,D0/ || u ~ /MOVE.L D[0-7],D0/ || u ~ /MOVE.B \$19\(A5\),D0/) has_restore_pen_move = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_MOVE=" has_move
    print "HAS_DRAW=" has_draw
    print "HAS_RESTORE_PEN_MOVE=" has_restore_pen_move
    print "HAS_RETURN=" has_return
}
