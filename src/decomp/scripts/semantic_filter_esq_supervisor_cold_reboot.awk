BEGIN {
    has_reset = 0
    has_indirect_jump = 0
    has_tryrom = 0
    has_rom_probe = 0
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

    if (uline ~ /^RESET$/) has_reset = 1
    if (uline ~ /^JMP \(/ || uline ~ /^JMP\(/) has_indirect_jump = 1
    if (uline ~ /ESQ_TRYROMWRITETEST/) has_tryrom = 1
    if (uline ~ /#\$?FBFFFC/ || uline ~ /#0X00FBFFFC/ || uline ~ /#16515068/) has_rom_probe = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_RESET=" has_reset
    print "HAS_INDIRECT_JUMP=" has_indirect_jump
    print "HAS_TRYROM_CALL=" has_tryrom
    print "HAS_ROM_PROBE_CONST=" has_rom_probe
    print "HAS_RTS=" has_rts
}
