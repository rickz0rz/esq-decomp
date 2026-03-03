BEGIN {
    has_entry = 0
    has_move = 0
    has_call = 0
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
    if (uline ~ /^MOVE\.W #1,GCOMMAND_HIGHLIGHTFLAG$/) has_move = 1
    if (uline ~ /^BSR\.[SW] GCOMMAND_APPLYHIGHLIGHTFLAG$/ || uline ~ /^JSR GCOMMAND_APPLYHIGHLIGHTFLAG$/) has_call = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MOVE=" has_move
    print "HAS_CALL=" has_call
    print "HAS_RTS=" has_rts
}
