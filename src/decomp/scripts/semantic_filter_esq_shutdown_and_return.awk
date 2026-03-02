BEGIN {
    has_exit_hook = 0
    has_memlist_free = 0
    has_close_lib = 0
    has_main_exit_hook = 0
    has_saved_msg = 0
    has_wb_window = 0
    has_exec_private = 0
    has_forbid = 0
    has_reply_msg = 0
    has_terminal = 0
}

function trim(s,    t) {
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /GLOBALEXITHOOKPTR/) has_exit_hook = 1
    if (n ~ /GROUPMAINAJMPTBLMEMLISTFREEALL/) has_memlist_free = 1
    if (n ~ /LVOCLOSELIBRARY/) has_close_lib = 1
    if (n ~ /GROUPMAINAJMPTBLESQMAINEXITNOOPHOOK/) has_main_exit_hook = 1
    if (n ~ /GLOBALSAVEDMSG/) has_saved_msg = 1
    if (n ~ /GLOBALWBSTARTUPWINDOWPTR/) has_wb_window = 1
    if (n ~ /LVOEXECPRIVATE1/) has_exec_private = 1
    if (n ~ /LVOFORBID/) has_forbid = 1
    if (n ~ /LVOREPLYMSG/) has_reply_msg = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_EXIT_HOOK=" has_exit_hook
    print "HAS_MEMLIST_FREE=" has_memlist_free
    print "HAS_CLOSE_LIB=" has_close_lib
    print "HAS_MAIN_EXIT_HOOK=" has_main_exit_hook
    print "HAS_SAVED_MSG=" has_saved_msg
    print "HAS_WB_WINDOW=" has_wb_window
    print "HAS_EXEC_PRIVATE=" has_exec_private
    print "HAS_FORBID=" has_forbid
    print "HAS_REPLY_MSG=" has_reply_msg
    print "HAS_TERMINAL=" has_terminal
}
