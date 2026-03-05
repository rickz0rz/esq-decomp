BEGIN {
    has_entry = 0
    has_replace_owned = 0
    has_write_436 = 0
    has_write_437 = 0
    has_write_426 = 0
    has_loop_bound = 0
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

    if (u ~ /^SCRIPT_RESETCTRLCONTEXT:/) has_entry = 1
    if (index(u, "ESQPROTO_JMPTBL_ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPROTO_JMPTBL_ESQPARS_REPLACEOWNED") > 0 || index(u, "ESQPROTO_JMPTBL_ESQPARS_REPLACEO") > 0) has_replace_owned = 1
    if (index(u, "436(A3)") > 0 || index(u, "436(A5)") > 0 || index(u, "436(A0)") > 0 || index(u, "$1B4(A3)") > 0) has_write_436 = 1
    if (index(u, "#120,437") > 0 || index(u, "#$78,437") > 0 || index(u, "437(A3)") > 0 || index(u, "#$78,$1B5(A3)") > 0) has_write_437 = 1
    if (index(u, "#1,426") > 0 || index(u, "426(A3)") > 0 || index(u, "#$1,(A0)") > 0 || index(u, "$1AA(A3)") > 0) has_write_426 = 1
    if (index(u, "#4") > 0 || index(u, "#$4") > 0 || index(u, "$1AC") > 0 || index(u, "$1B0") > 0) has_loop_bound = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_WRITE_436=" has_write_436
    print "HAS_WRITE_437=" has_write_437
    print "HAS_WRITE_426=" has_write_426
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_RETURN=" has_return
}
