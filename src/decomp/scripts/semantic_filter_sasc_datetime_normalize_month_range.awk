BEGIN {
    cmp11 = 0
    flag18 = 0
    div12 = 0
    swap = 0
    write8 = 0
    zero_check = 0
    write12 = 0
    has_rts_or_jmp = 0
}

function trim(s,    t) {
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

    if (u ~ /#11([^0-9]|$)|#\$B([^0-9A-F]|$)|11\.W$/) cmp11 = 1
    if (u ~ /18\([AA][0-7]\)|\$12\([AA][0-7]\)|[(]18,[AA][0-7][)]/) flag18 = 1
    if (u ~ /#12([^0-9]|$)|#\$C([^0-9A-F]|$)|DIVS|_CXD33/) div12 = 1
    if (u ~ /^SWAP [D][0-7]$/ || u ~ /_CXD33/) swap = 1
    if (u ~ /8\([AA][0-7]\)|\$8\([AA][0-7]\)/) write8 = 1
    if (u ~ /^TST\.W [D][0-7]$/ || u ~ /^BEQ\./ || u ~ /^BEQ / || u ~ /^BNE\./ || u ~ /^BNE /) zero_check = 1
    if (u ~ /^MOVE\.W #12,8\([AA][0-7]\)$/ || u ~ /^MOVE\.W #\$C,\$8\([AA][0-7]\)$/ || u ~ /^MOVEQ\.L #\$C,D[0-7]$/) write12 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    if (!write12 && div12 && zero_check && write8) write12 = 1
    print "HAS_GT11_TEST=" cmp11
    print "HAS_FLAG18_WRITE=" flag18
    print "HAS_DIV12=" div12
    print "HAS_SWAP_REMAINDER=" swap
    print "HAS_MONTH_WRITE=" write8
    print "HAS_ZERO_REMAINDER_CHECK=" zero_check
    print "HAS_WRITE12_ON_ZERO=" write12
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
