BEGIN {
    has_update_filter = 0
    has_load_ctx = 0
    has_update_runtime = 0
    has_apply_pending = 0
    has_dispatch = 0
    has_save_ctx = 0
    has_runtime_deferred = 0
    has_runtime_mode = 0
    has_cursor = 0
    has_current_saved = 0
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

    if (n ~ /SCRIPT3JMPTBLLOCAVAILUPDATEFILTERSTATEMACHINE/) has_update_filter = 1
    if (n ~ /SCRIPTLOADCTRLCONTEXTSNAPSHOT/) has_load_ctx = 1
    if (n ~ /SCRIPTUPDATERUNTIMEMODEFORPLAYBACKCURSOR/) has_update_runtime = 1
    if (n ~ /SCRIPTAPPLYPENDINGBANNERTARGET/) has_apply_pending = 1
    if (n ~ /SCRIPTDISPATCHPLAYBACKCURSORCOMMAND/) has_dispatch = 1
    if (n ~ /SCRIPTSAVECTRLCONTEXTSNAPSHOT/) has_save_ctx = 1
    if (n ~ /SCRIPTRUNTIMEMODEDEFERREDFLAG/) has_runtime_deferred = 1
    if (n ~ /SCRIPTRUNTIMEMODE/) has_runtime_mode = 1
    if (n ~ /SCRIPTPLAYBACKCURSOR/) has_cursor = 1
    if (n ~ /TEXTDISPCURRENTMATCHINDEXSAVED/) has_current_saved = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_UPDATE_FILTER=" has_update_filter
    print "HAS_LOAD_CTX=" has_load_ctx
    print "HAS_UPDATE_RUNTIME=" has_update_runtime
    print "HAS_APPLY_PENDING=" has_apply_pending
    print "HAS_DISPATCH=" has_dispatch
    print "HAS_SAVE_CTX=" has_save_ctx
    print "HAS_RUNTIME_DEFERRED=" has_runtime_deferred
    print "HAS_RUNTIME_MODE=" has_runtime_mode
    print "HAS_CURSOR=" has_cursor
    print "HAS_CURRENT_SAVED=" has_current_saved
    print "HAS_TERMINAL=" has_terminal
}
