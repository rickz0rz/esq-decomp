BEGIN {
    div_call = 0
    c12 = 0
    flag18 = 0
    plus12 = 0
    write_month = 0
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

    if (u ~ /_CXD33|GROUP_AG_JMPTBL_MATH_DIVS32|DATETIME_MODBYDIVS32HELPER/) div_call = 1
    if (u ~ /#12([^0-9]|$)|#\$C([^0-9A-F]|$)|12\.W$|#\$C,/) c12 = 1
    if (u ~ /[(]18,[AA][0-7][)]|18\([AA][0-7]\)|\$12\([AA][0-7]\)/) flag18 = 1
    if (u ~ /^ADD\.L [D][0-7],[D][0-7]$/ || u ~ /^ADD\.L #12,[D][0-7]$/ || u ~ /^ADDQ\.L #12,[D][0-7]$/ || u ~ /^ADD\.L #\$C,[D][0-7]$/ || u ~ /^ADDQ\.L #\$C,[D][0-7]$/) plus12 = 1
    if (u ~ /^MOVE\.W [D][0-7],8\([AA][0-7]\)$/ || u ~ /^MOVE\.W [D][0-7],\$8\([AA][0-7]\)$/ || u ~ /^MOVE\.W [D][0-7],\(A0\)$/) write_month = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_DIV_CALL=" div_call
    print "HAS_CONST_12=" c12
    print "HAS_FLAG18_TEST=" flag18
    print "HAS_OPTIONAL_PLUS12=" plus12
    print "HAS_MONTH_WRITEBACK=" write_month
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
