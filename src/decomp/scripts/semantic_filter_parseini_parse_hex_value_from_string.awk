BEGIN {
    has_input_ptr = 0
    has_charclass = 0
    has_shift4 = 0
    has_parse_hex_call = 0
    has_loop_term = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /A3/ || n ~ /P/) has_input_ptr = 1
    if (n ~ /WDISPCHARCLASSTABLE/) has_charclass = 1
    if (u ~ /#4/ || u ~ /<<4/ || u ~ /ASL.L #4/) has_shift4 = 1
    if (n ~ /SCRIPT3JMPTBLLADFUNCPARSEHEXDIGIT/) has_parse_hex_call = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_loop_term = 1
}

END {
    print "HAS_INPUT_PTR=" has_input_ptr
    print "HAS_CHARCLASS=" has_charclass
    print "HAS_SHIFT4=" has_shift4
    print "HAS_PARSE_HEX_CALL=" has_parse_hex_call
    print "HAS_LOOP_TERM=" has_loop_term
}
