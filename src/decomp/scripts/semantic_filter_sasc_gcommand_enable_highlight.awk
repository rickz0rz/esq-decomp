BEGIN {
    has_entry = 0
    has_set_highlight = 0
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

    if (uline ~ /^GCOMMAND_ENABLEHIGHLIGHT:/) has_entry = 1
    if (index(uline, "GCOMMAND_HIGHLIGHTFLAG") > 0 && (uline ~ /^MOVE\.[BWL] #(\$)?1,/ || uline ~ /^MOVEQ(\.L)? #(\$)?1,D[0-7]$/ || uline ~ /^ST(\.[BWL])? / || uline ~ /^ADDQ\.[BWL] #(\$)?1,/)) has_set_highlight = 1
    if ((uline ~ /^BSR(\.[A-Z]+)? / || uline ~ /^JSR /) && index(uline, "GCOMMAND_APPLYHIGHLIGHTFLAG") > 0) has_apply_call = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SET_HIGHLIGHT=" has_set_highlight
    print "HAS_APPLY_CALL=" has_apply_call
    print "HAS_RTS=" has_rts
}
