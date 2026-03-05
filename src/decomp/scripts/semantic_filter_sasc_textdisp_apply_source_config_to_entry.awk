BEGIN {
    has_entry = 0
    has_null_guard = 0
    has_flagmask = 0
    has_table = 0
    has_count = 0
    has_strlen = 0
    has_compare = 0
    has_or_flags = 0
    has_return = 0
    saw_strlen_tst = 0
    saw_strlen_add = 0
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

    if (u ~ /^TEXTDISP_APPLYSOURCECONFIGTOENTRY:/ || u ~ /^TEXTDISP_APPLYSOURCECONFIGTOENTR[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /MOVE\.L A[0-7],D0/ || u ~ /BEQ/ || u ~ /TST\.L/) has_null_guard = 1
    if (index(u, "TEXTDISP_SOURCECONFIGFLAGMASK") > 0) has_flagmask = 1
    if (index(u, "TEXTDISP_SOURCECONFIGENTRYTABLE") > 0) has_table = 1
    if (index(u, "TEXTDISP_SOURCECONFIGENTRYCOUNT") > 0) has_count = 1
    if (u ~ /TST\.B .*\(A[0-7]\)\+/ || u ~ /SUBA\.L/) has_strlen = 1
    if (index(u, "TST.B (A0)") > 0) saw_strlen_tst = 1
    if (index(u, "ADD.L D6,A0") > 0) saw_strlen_add = 1
    if (index(u, "STRING_COMPARENOCASEN") > 0 || index(u, "STRING_COMPARENOCASEN") > 0) has_compare = 1
    if ((index(u, "OR.B") > 0) && (index(u, "40(A3)") > 0 || index(u, "$28(") > 0)) has_or_flags = 1
    if (u == "RTS") has_return = 1
}

END {
    if (saw_strlen_tst && saw_strlen_add) has_strlen = 1
    print "HAS_ENTRY=" has_entry
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_FLAGMASK=" has_flagmask
    print "HAS_TABLE=" has_table
    print "HAS_COUNT=" has_count
    print "HAS_STRLEN=" has_strlen
    print "HAS_COMPARE=" has_compare
    print "HAS_OR_FLAGS=" has_or_flags
    print "HAS_RETURN=" has_return
}
