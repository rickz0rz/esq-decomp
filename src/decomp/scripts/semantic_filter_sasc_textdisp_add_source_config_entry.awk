BEGIN {
    has_entry = 0
    has_count = 0
    has_table = 0
    has_alloc = 0
    has_replace = 0
    has_compare = 0
    has_set_flag8 = 0
    has_or_mask = 0
    has_return = 0
    saw_or = 0
    saw_mask = 0
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

    if (u ~ /^TEXTDISP_ADDSOURCECONFIGENTRY:/ || u ~ /^TEXTDISP_ADDSOURCECONFIGENTR[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TEXTDISP_SOURCECONFIGENTRYCOUNT") > 0) has_count = 1
    if (index(u, "TEXTDISP_SOURCECONFIGENTRYTABLE") > 0) has_table = 1
    if (index(u, "MEMORY_ALLOCATEMEMORY") > 0) has_alloc = 1
    if (index(u, "ESQPROTO_JMPTBL_ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPROTO_JMPTBL_ESQPARS_REPLACEO") > 0) has_replace = 1
    if (index(u, "STRING_COMPARENOCAS") > 0) has_compare = 1
    if (u ~ /MOVEQ #8,/ || index(u, "MOVEQ.L #$8,") > 0 || index(u, "MOVE.B #$8,") > 0 || index(u, "MOVE.B #8,") > 0) has_set_flag8 = 1
    if (index(u, "OR.B") > 0) saw_or = 1
    if (index(u, "TEXTDISP_SOURCECONFIGFLAGMASK") > 0) saw_mask = 1
    if (u == "RTS") has_return = 1
}

END {
    if (saw_or && saw_mask) has_or_mask = 1
    print "HAS_ENTRY=" has_entry
    print "HAS_COUNT=" has_count
    print "HAS_TABLE=" has_table
    print "HAS_ALLOC=" has_alloc
    print "HAS_REPLACE=" has_replace
    print "HAS_COMPARE=" has_compare
    print "HAS_SET_FLAG8=" has_set_flag8
    print "HAS_OR_MASK=" has_or_mask
    print "HAS_RETURN=" has_return
}
