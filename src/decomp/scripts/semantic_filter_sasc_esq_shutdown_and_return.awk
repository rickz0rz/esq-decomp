BEGIN {
    has_entry = 0
    has_exit_hook_call = 0
    has_memlist_free = 0
    has_close_library = 0
    has_main_exit_hook = 0
    has_saved_msg_gate = 0
    has_execprivate1 = 0
    has_forbid = 0
    has_replymsg = 0
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

    if (u ~ /^ESQ_SHUTDOWNANDRETURN:/ || u ~ /^ESQ_SHUTDOWNANDRET[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "GLOBAL_EXITHOOKPTR") > 0 || u ~ /^JSR \(A[0-7]\)$/) has_exit_hook_call = 1
    if (index(u, "MEMLIST_FREEALL") > 0 || index(u, "FREEALL") > 0 || index(u, "MEMLIST_FREE") > 0) has_memlist_free = 1
    if (index(u, "CLOSELIBRARY") > 0) has_close_library = 1
    if (index(u, "MAINEXITNOOPHOOK") > 0 || index(u, "MAINEXITNOOP") > 0 || index(u, "GROUP_MAIN_A_JMPTBL_ESQ_MAINEXIT") > 0) has_main_exit_hook = 1
    if (index(u, "GLOBAL_SAVEDMSG") > 0) has_saved_msg_gate = 1
    if (index(u, "EXECPRIVATE1") > 0) has_execprivate1 = 1
    if (index(u, "FORBID") > 0) has_forbid = 1
    if (index(u, "REPLYMSG") > 0) has_replymsg = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_EXIT_HOOK_CALL=" has_exit_hook_call
    print "HAS_MEMLIST_FREE=" has_memlist_free
    print "HAS_CLOSE_LIBRARY=" has_close_library
    print "HAS_MAIN_EXIT_HOOK=" has_main_exit_hook
    print "HAS_SAVED_MSG_GATE=" has_saved_msg_gate
    print "HAS_EXECPRIVATE1=" has_execprivate1
    print "HAS_FORBID=" has_forbid
    print "HAS_REPLYMSG=" has_replymsg
    print "HAS_RETURN=" has_return
}
