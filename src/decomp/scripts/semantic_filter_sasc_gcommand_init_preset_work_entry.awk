BEGIN {
    has_entry = 0
    has_index_guard = 0
    has_span_guard = 0
    has_default_table_ref = 0
    has_invalid_path = 0
    has_set_call = 0
    has_mode_set = 0
    has_return = 0
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
    u = toupper(line)

    if (u ~ /^GCOMMAND_INITPRESETWORKENTRY:/) has_entry = 1
    if (u ~ /^TST\.[LW] D[0-7]$/ || u ~ /^BMI\.[A-Z]+ / || u ~ /^MOVEQ(\.L)? #\$10,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #16,D[0-7]$/) has_index_guard = 1
    if (u ~ /^MOVEQ(\.L)? #\$4,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #4,D[0-7]$/ || u ~ /^BLE\.[A-Z]+ /) has_span_guard = 1
    if (index(u, "GCOMMAND_DEFAULTPRESETTABLE") > 0) has_default_table_ref = 1
    if (u ~ /^MOVEQ(\.L)? #\$6,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #6,D[0-7]$/ || u ~ /^PEA 1365\.W$/ || u ~ /^PEA \$555\.W$/) has_invalid_path = 1
    if (index(u, "GCOMMAND_SETPRESETENTRY") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_set_call = 1
    if (u ~ /^MOVEQ(\.L)? #\$2,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #2,D[0-7]$/) has_mode_set = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INDEX_GUARD=" has_index_guard
    print "HAS_SPAN_GUARD=" has_span_guard
    print "HAS_DEFAULT_TABLE_REF=" has_default_table_ref
    print "HAS_INVALID_PATH=" has_invalid_path
    print "HAS_SET_CALL=" has_set_call
    print "HAS_MODE_SET=" has_mode_set
    print "HAS_RETURN=" has_return
}
