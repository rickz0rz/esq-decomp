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
    has_compare_n = 0
    has_apply_rtc = 0
    has_type20 = 0
    has_locavail = 0
    has_channel_update = 0
    has_readsigned = 0
    has_parsehex = 0
    has_consts_14_15 = 0
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
    if (n ~ /ESQPROTOJMPTBLESQPARSREPLACEOWNEDSTRING/ || n ~ /ESQPROTOJMPTBLESQPARSREPLACEOWN/ || n ~ /ESQPROTOJMPTBLESQPARSREPLACEO/ || n ~ /ESQPARSREPLACEOWNEDSTRING/ || n ~ /ESQPARSREPLACEOWN/ || n ~ /ESQPARSREPLACEO/) has_replace_owned = 1
    if (n ~ /SCRIPTRUNTIMEMODE/) has_runtime_mode = 1
    if (n ~ /SCRIPTPLAYBACKCURSOR/ || n ~ /SCRIPTPLAYBACKCURSO/) has_playback_cursor = 1
    if (n ~ /SCRIPTPRIMARYSEARCHFIRSTFLAG/ || n ~ /SCRIPTPRIMARYSEARCHFIRSTFL/) has_primary_first = 1
    if (n ~ /SCRIPTPENDINGBANNERTARGETCHAR/ || n ~ /SCRIPTPENDINGBANNERTARGETCHA/) has_pending_target = 1
    if (n ~ /SCRIPT3JMPTBLSTRINGCOMPAREN/ || n ~ /STRINGCOMPAREN/) has_compare_n = 1
    if (n ~ /APPLYRTCBYTESANDPERSIST/ || n ~ /ESQPARSAPPLYRTCBYTES/) has_apply_rtc = 1
    if (n ~ /PTYPEGETSUBTYPEIFTYPE20/ || n ~ /PTYPECONSUMEPRIMARYTYPEIFPRESENT/ || n ~ /SCRIPTTYPE20SUBTYPECACHE/) has_type20 = 1
    if (n ~ /LOCAVAILSETFILTERMODEANDRESETSTATE/ || n ~ /LOCAVAILCOMPUTEFILTEROFFSETFORENTRY/ || n ~ /LOCAVAIL/) has_locavail = 1
    if (n ~ /TEXTDISPUPDATECHANNELRANGEFLAGS/ || n ~ /CHANNELRANGEARMEDFLAG/ || n ~ /CHANNELRANGEDIGITCHAR/) has_channel_update = 1
    if (n ~ /PARSEREADSIGNEDLONGSKIPCLASS3ALT/ || n ~ /READSIGNEDLONGSKIPCLASS3ALT/ || n ~ /PARSEREADSIGNEDLONGSKIPCLASS3A/ || n ~ /READSIGNEDLONGSKIPCLASS3A/) has_readsigned = 1
    if (n ~ /LADFUNCPARSEHEXDIGIT/ || n ~ /PARSEHEXDIGIT/) has_parsehex = 1
    if (u ~ /#14([^0-9]|$)/ || u ~ /#15([^0-9]|$)/ || u ~ /#\$E/ || u ~ /#\$0E/ || u ~ /#\$F/ || u ~ /#\$0F/) has_consts_14_15 = 1
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
    print "HAS_COMPARE_N=" has_compare_n
    print "HAS_APPLY_RTC=" has_apply_rtc
    print "HAS_TYPE20=" has_type20
    print "HAS_LOCAVAIL=" has_locavail
    print "HAS_CHANNEL_UPDATE=" has_channel_update
    print "HAS_READSIGNED=" has_readsigned
    print "HAS_PARSE_HEX=" has_parsehex
    print "HAS_CONSTS_14_15=" has_consts_14_15
    print "HAS_RETURN=" has_return
}
