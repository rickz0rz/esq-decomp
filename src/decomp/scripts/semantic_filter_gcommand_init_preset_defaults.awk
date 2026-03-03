BEGIN {
    has_entry = 0
    has_pea = 0
    has_call = 0
    has_addq = 0
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

    if (uline ~ /^GCOMMAND_INITPRESETDEFAULTS:/) has_entry = 1
    if (uline ~ /^PEA GCOMMAND_DEFAULTPRESETTABLE$/) has_pea = 1
    if (uline ~ /^BSR\.[SW] GCOMMAND_INITPRESETTABLEFROMPALETTE$/ || uline ~ /^JSR GCOMMAND_INITPRESETTABLEFROMPALETTE$/) has_call = 1
    if (uline ~ /^ADDQ\.W #4,A7$/) has_addq = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PEA=" has_pea
    print "HAS_CALL=" has_call
    print "HAS_ADDQ=" has_addq
    print "HAS_RTS=" has_rts
}
