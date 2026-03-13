BEGIN {
    has_entry = 0
    has_loop_count = 0
    has_table = 0
    has_replace = 0
    has_free = 0
    has_clear_slot = 0
    has_clear_count = 0
    has_clear_mask = 0
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

    if (u ~ /^TEXTDISP_CLEARSOURCECONFIG:/ || u ~ /^TEXTDISP_CLEARSOURCECONFI[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TEXTDISP_SOURCECONFIGENTRYCOUNT") > 0) has_loop_count = 1
    if (index(u, "TEXTDISP_SOURCECONFIGENTRYTABLE") > 0) has_table = 1
    if (index(u, "ESQPROTO_JMPTBL_ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPROTO_JMPTBL_ESQPARS_REPLACEO") > 0 || index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPARS_REPLACEO") > 0) has_replace = 1
    if (index(u, "MEMORY_DEALLOCATEMEMORY") > 0) has_free = 1
    if ((index(u, "CLR.L (A0)") > 0) || (index(u, "CLR.L $0(") > 0)) has_clear_slot = 1
    if (index(u, "CLR.L TEXTDISP_SOURCECONFIGENTRYCOUNT") > 0) has_clear_count = 1
    if (index(u, "CLR.B TEXTDISP_SOURCECONFIGFLAGMASK") > 0) has_clear_mask = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_COUNT=" has_loop_count
    print "HAS_TABLE=" has_table
    print "HAS_REPLACE=" has_replace
    print "HAS_FREE=" has_free
    print "HAS_CLEAR_SLOT=" has_clear_slot
    print "HAS_CLEAR_COUNT=" has_clear_count
    print "HAS_CLEAR_MASK=" has_clear_mask
    print "HAS_RETURN=" has_return
}
