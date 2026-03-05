BEGIN {
    has_entry = 0
    has_clear_highlight = 0
    has_apply_call = 0
    has_rts = 0
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

    if (uline ~ /^GCOMMAND_DISABLEHIGHLIGHT:/) has_entry = 1
    if (index(uline, "GCOMMAND_HIGHLIGHTFLAG") > 0 && (uline ~ /^CLR\.[BWL] / || uline ~ /^MOVE\.[BWL] #(\$)?0,/ || uline ~ /^MOVEQ(\.L)? #(\$)?0,D[0-7]$/)) has_clear_highlight = 1
    if ((uline ~ /^BSR(\.[A-Z]+)? / || uline ~ /^JSR /) && index(uline, "GCOMMAND_APPLYHIGHLIGHTFLAG") > 0) has_apply_call = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CLEAR_HIGHLIGHT=" has_clear_highlight
    print "HAS_APPLY_CALL=" has_apply_call
    print "HAS_RTS=" has_rts
}
