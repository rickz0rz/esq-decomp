BEGIN {
    has_entry = 0
    has_load_ctx = 0
    has_save_ctx = 0
    has_select_cursor = 0
    has_split = 0
    has_handle_script_cmd = 0
    has_replace_owned = 0
    has_runtime_mode = 0
    has_playback_cursor = 0
    has_primary_first = 0
    has_pending_target = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^SCRIPT_HANDLEBRUSHCOMMAND:/ || u ~ /^SCRIPT_HANDLEBRUSHCOMMAN[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /SCRIPTLOADCTRLCONTEXTSNAPSHOT/ || n ~ /SCRIPTLOADCTRLCONTEXTSNAPS/) has_load_ctx = 1
    if (n ~ /SCRIPTSAVECTRLCONTEXTSNAPSHOT/ || n ~ /SCRIPTSAVECTRLCONTEXTSNAP/) has_save_ctx = 1
    if (n ~ /SCRIPTSELECTPLAYBACKCURSORFROMSEARCHTEXT/ || n ~ /SCRIPTSELECTPLAYBACKCURSORFR/) has_select_cursor = 1
    if (n ~ /SCRIPTSPLITANDNORMALIZESEARCHBUFFER/ || n ~ /SCRIPTSPLITANDNORMALIZESEARC/) has_split = 1
    if (n ~ /TEXTDISPHANDLESCRIPTCOMMAND/ || n ~ /TEXTDISPHANDLESCRIPTCOM/) has_handle_script_cmd = 1
    if (n ~ /ESQPROTOJMPTBLESQPARSREPLACEOWNEDSTRING/ || n ~ /ESQPROTOJMPTBLESQPARSREPLACEOWN/ || n ~ /ESQPROTOJMPTBLESQPARSREPLACEO/) has_replace_owned = 1
    if (n ~ /SCRIPTRUNTIMEMODE/) has_runtime_mode = 1
    if (n ~ /SCRIPTPLAYBACKCURSOR/ || n ~ /SCRIPTPLAYBACKCURSO/) has_playback_cursor = 1
    if (n ~ /SCRIPTPRIMARYSEARCHFIRSTFLAG/ || n ~ /SCRIPTPRIMARYSEARCHFIRSTFL/) has_primary_first = 1
    if (n ~ /SCRIPTPENDINGBANNERTARGETCHAR/ || n ~ /SCRIPTPENDINGBANNERTARGETCHA/) has_pending_target = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD_CTX=" has_load_ctx
    print "HAS_SAVE_CTX=" has_save_ctx
    print "HAS_SELECT_CURSOR=" has_select_cursor
    print "HAS_SPLIT=" has_split
    print "HAS_HANDLE_SCRIPT_CMD=" has_handle_script_cmd
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_RUNTIME_MODE=" has_runtime_mode
    print "HAS_PLAYBACK_CURSOR=" has_playback_cursor
    print "HAS_PRIMARY_FIRST=" has_primary_first
    print "HAS_PENDING_TARGET=" has_pending_target
    print "HAS_RETURN=" has_return
}
