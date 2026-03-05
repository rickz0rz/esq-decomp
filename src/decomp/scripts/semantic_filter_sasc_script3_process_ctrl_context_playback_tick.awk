BEGIN {
    has_entry = 0
    has_update_filter = 0
    has_load_snapshot = 0
    has_update_runtime = 0
    has_apply_pending = 0
    has_dispatch_cursor = 0
    has_save_snapshot = 0
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

    if (u ~ /^SCRIPT_PROCESSCTRLCONTEXTPLAYBACKTICK:/ || u ~ /^SCRIPT_PROCESSCTRLCONTEXTPLAYBAC[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "SCRIPT3_JMPTBL_LOCAVAIL_UPDATEFILTERSTATEMACHINE") > 0 || index(u, "SCRIPT3_JMPTBL_LOCAVAIL_UPDATEFILTERSTATE") > 0 || index(u, "SCRIPT3_JMPTBL_LOCAVAIL_UPDATEFI") > 0) has_update_filter = 1
    if (index(u, "SCRIPT_LOADCTRLCONTEXTSNAPSHOT") > 0 || index(u, "SCRIPT_LOADCTRLCONTEXTSNAPS") > 0) has_load_snapshot = 1
    if (index(u, "SCRIPT_UPDATERUNTIMEMODEFORPLAYBACKCURSOR") > 0 || index(u, "SCRIPT_UPDATERUNTIMEMODEFORPLAYBA") > 0 || index(u, "SCRIPT_UPDATERUNTIMEMODEFORPLAYB") > 0) has_update_runtime = 1
    if (index(u, "SCRIPT_APPLYPENDINGBANNERTARGET") > 0 || index(u, "SCRIPT_APPLYPENDINGBANNERTAR") > 0) has_apply_pending = 1
    if (index(u, "SCRIPT_DISPATCHPLAYBACKCURSORCOMMAND") > 0 || index(u, "SCRIPT_DISPATCHPLAYBACKCURSORCOM") > 0) has_dispatch_cursor = 1
    if (index(u, "SCRIPT_SAVECTRLCONTEXTSNAPSHOT") > 0 || index(u, "SCRIPT_SAVECTRLCONTEXTSNAPS") > 0) has_save_snapshot = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_UPDATE_FILTER=" has_update_filter
    print "HAS_LOAD_SNAPSHOT=" has_load_snapshot
    print "HAS_UPDATE_RUNTIME=" has_update_runtime
    print "HAS_APPLY_PENDING=" has_apply_pending
    print "HAS_DISPATCH_CURSOR=" has_dispatch_cursor
    print "HAS_SAVE_SNAPSHOT=" has_save_snapshot
    print "HAS_RETURN=" has_return
}
