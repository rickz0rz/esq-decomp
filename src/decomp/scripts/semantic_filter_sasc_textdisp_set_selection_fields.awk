BEGIN {
    has_entry = 0
    has_mode_store = 0
    has_count_call = 0
    has_display_store = 0
    has_entry_store = 0
    has_flags_clear = 0
    has_reset_call = 0
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

    if (u ~ /^TEXTDISP_SETSELECTIONFIELDS:/ || u ~ /^TEXTDISP_SETSELECTIONFIELD[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "$D2(A3)") > 0 || index(u, "210(A3)") > 0 || index(u, "$D2(A5)") > 0) has_mode_store = 1
    if (index(u, "TEXTDISP_GETGROUPENTRYCOUNT") > 0 || index(u, "TEXTDISP_GETGROUPENTRYCO") > 0) has_count_call = 1
    if (index(u, "$D6(A3)") > 0 || index(u, "214(A3)") > 0 || index(u, "$D6(A5)") > 0) has_display_store = 1
    if (index(u, "$DA(A3)") > 0 || index(u, "218(A3)") > 0 || index(u, "$DA(A5)") > 0) has_entry_store = 1
    if (index(u, "$DC(A3)") > 0 || index(u, "220(A3)") > 0 || index(u, "CLR.B") > 0) has_flags_clear = 1
    if (index(u, "TEXTDISP_RESETSELECTIONSTATE") > 0 || index(u, "TEXTDISP_RESETSELECTIONSTA") > 0) has_reset_call = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MODE_STORE=" has_mode_store
    print "HAS_COUNT_CALL=" has_count_call
    print "HAS_DISPLAY_STORE=" has_display_store
    print "HAS_ENTRY_STORE=" has_entry_store
    print "HAS_FLAGS_CLEAR=" has_flags_clear
    print "HAS_RESET_CALL=" has_reset_call
    print "HAS_RETURN=" has_return
}
