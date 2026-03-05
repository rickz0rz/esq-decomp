BEGIN {
    has_entry = 0
    has_null_guard = 0
    has_btst0 = 0
    has_btst3_flags40 = 0
    has_jmptbl_call = 0
    has_btst3_flags27 = 0
    has_result_1 = 0
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

    if (u ~ /^TEXTDISP_SHOULDOPENEDITORFORENTRY:/ || u ~ /^TEXTDISP_SHOULDOPENEDITORFORENT[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /BEQ/ || u ~ /MOVE\.L A[0-7],D0/ || u ~ /TST\.L/) has_null_guard = 1
    if (index(u, "BTST #0,40(") > 0 || index(u, "BTST #$0,40(") > 0 || index(u, "BTST #$0,$28(") > 0) has_btst0 = 1
    if (index(u, "BTST #3,40(") > 0 || index(u, "BTST #$3,40(") > 0 || index(u, "BTST #$3,$28(") > 0) has_btst3_flags40 = 1
    if (index(u, "TEXTDISP_JMPTBL_NEWGRID_SHOULDOPENEDITOR") > 0 || index(u, "TEXTDISP_JMPTBL_NEWGRID_SHOULDOPENE") > 0 || index(u, "TEXTDISP_JMPTBL_NEWGRID_SHOULDOP") > 0) has_jmptbl_call = 1
    if (index(u, "BTST #3,27(") > 0 || index(u, "BTST #$3,27(") > 0 || index(u, "BTST #$3,$1B(") > 0) has_btst3_flags27 = 1
    if (u ~ /MOVEQ #1,/ || index(u, "MOVEQ.L #$1,") > 0) has_result_1 = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_BTST0=" has_btst0
    print "HAS_BTST3_FLAGS40=" has_btst3_flags40
    print "HAS_JMPTBL_CALL=" has_jmptbl_call
    print "HAS_BTST3_FLAGS27=" has_btst3_flags27
    print "HAS_RESULT_1=" has_result_1
    print "HAS_RETURN=" has_return
}
