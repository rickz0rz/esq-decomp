BEGIN {
    has_entry = 0
    has_table = 0
    has_loop_bound = 0
    has_clear_count = 0
    has_clear_mask = 0
    has_parse_call = 0
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

    if (u ~ /^TEXTDISP_LOADSOURCECONFIG:/ || u ~ /^TEXTDISP_LOADSOURCECONFI[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TEXTDISP_SOURCECONFIGENTRYTABLE") > 0) has_table = 1
    if (index(u, "#$12E") > 0 || index(u, "#302") > 0) has_loop_bound = 1
    if (index(u, "TEXTDISP_SOURCECONFIGENTRYCOUNT") > 0) has_clear_count = 1
    if (index(u, "TEXTDISP_SOURCECONFIGFLAGMASK") > 0) has_clear_mask = 1
    if (index(u, "PARSEINI_PARSEINIBUFFERANDDISPATCH") > 0 || index(u, "PARSEINI_PARSEINIBUFFERANDD") > 0) has_parse_call = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TABLE=" has_table
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_CLEAR_COUNT=" has_clear_count
    print "HAS_CLEAR_MASK=" has_clear_mask
    print "HAS_PARSE_CALL=" has_parse_call
    print "HAS_RETURN=" has_return
}
