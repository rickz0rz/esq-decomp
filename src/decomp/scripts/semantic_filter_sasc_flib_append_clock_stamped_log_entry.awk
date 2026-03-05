BEGIN {
    has_entry = 0
    has_spinlock = 0
    has_size_guard = 0
    has_strlen_cap = 0
    has_div_calls = 0
    has_ampm_gate = 0
    has_sprintf = 0
    has_append_calls = 0
    has_alloc = 0
    has_replace_owned = 0
    has_free_tmp = 0
    has_spinlock_clear = 0
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

    if (u ~ /^FLIB_APPENDCLOCKSTAMPEDLOGENTRY:/ || u ~ /^FLIB_APPENDCLOCKSTAMPEDLOGENT[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "LOGAPPENDSPINLOCK") > 0) has_spinlock = 1
    if (index(u, "CMPI.W #$2710") > 0 || index(u, "CMPI.L #$2710") > 0 || index(u, "2710") > 0) has_size_guard = 1
    if (index(u, "CLR.B 99(") > 0 || index(u, "MOVEQ #100") > 0 || index(u, "MOVEQ.L #$64") > 0) has_strlen_cap = 1
    if (index(u, "MATH_DIVS32") > 0 || index(u, "DIVS32") > 0) has_div_calls = 1
    if (index(u, "CLOCK_CACHEAMPMFLAG") > 0 || index(u, "LOGTAGPM") > 0 || index(u, "LOGTAGAM") > 0) has_ampm_gate = 1
    if (index(u, "WDISP_SPRINTF") > 0 || index(u, "SPRINTF") > 0) has_sprintf = 1
    if (index(u, "APPENDATNULL") > 0 || index(u, "APPENDATN") > 0) has_append_calls = 1
    if (index(u, "ALLOCATEMEMORY") > 0 || index(u, "ALLOCATEMEM") > 0 || index(u, "ALLOCATEME") > 0) has_alloc = 1
    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "REPLACEOWNEDSTRING") > 0) has_replace_owned = 1
    if (index(u, "DEALLOCATEMEMORY") > 0 || index(u, "DEALLOCATEMEM") > 0 || index(u, "DEALLOCATE") > 0) has_free_tmp = 1
    if ((index(u, "LOGAPPENDSPINLOCK") > 0 && (u ~ /^CLR\.L / || u ~ /^MOVE\.L D[0-7],/ || u ~ /^MOVEQ\.L #\$0,D[0-7]$/))) has_spinlock_clear = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SPINLOCK=" has_spinlock
    print "HAS_SIZE_GUARD=" has_size_guard
    print "HAS_STRLEN_CAP=" has_strlen_cap
    print "HAS_DIV_CALLS=" has_div_calls
    print "HAS_AMPM_GATE=" has_ampm_gate
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_APPEND_CALLS=" has_append_calls
    print "HAS_ALLOC=" has_alloc
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_FREE_TMP=" has_free_tmp
    print "HAS_SPINLOCK_CLEAR=" has_spinlock_clear
    print "HAS_RETURN=" has_return
}
