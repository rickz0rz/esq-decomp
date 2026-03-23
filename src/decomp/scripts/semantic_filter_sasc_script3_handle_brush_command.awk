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
    has_mulu = 0
    has_consts_14_15 = 0
    has_brush_selection = 0
    has_brush_list_scan = 0
    has_brush_tag_defaults = 0
    has_wildcard_lookup = 0
    has_channel_range_flow = 0
    has_rtc_validation = 0
    has_banner_speed_flow = 0
    has_pending_cmd_fields = 0
    has_pending_textdisp_reset = 0
    has_highlight_custom = 0
    has_handshake_bit5 = 0
    has_runtime_branch = 0
    has_return = 0

    saw_channel_range_digit = 0
    saw_channel_range_match = 0
    saw_channel_range_update = 0
    saw_rtc_copy = 0
    saw_rtc_year = 0
    saw_rtc_bounds = 0
    saw_rtc_apply = 0
    saw_banner_speed_target = 0
    saw_banner_speed_default = 0
    saw_banner_speed_wildcard = 0
    saw_textdisp_cmd = 0
    saw_pending_minus2 = 0
    saw_runtime_filter = 0
    saw_runtime_diag = 0
    saw_runtime_symbol = 0
    saw_runtime_constant = 0
    saw_runtime_result = 0
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
    if (n ~ /MATHMULU32/) has_mulu = 1
    if (u ~ /#14([^0-9]|$)/ || u ~ /#15([^0-9]|$)/ || u ~ /#\$E/ || u ~ /#\$0E/ || u ~ /#\$F/ || u ~ /#\$0F/) has_consts_14_15 = 1
    if (n ~ /BRUSHSCRIPTPRIMARYSELECTION/ || n ~ /BRUSHSCRIPTSECONDARYSELECTION/ || n ~ /BRUSHSELECTEDNODE/) has_brush_selection = 1
    if (n ~ /ESQIFFBRUSHINILISTHEAD/) has_brush_list_scan = 1
    if (n ~ /SCRIPTBRUSHTAGDEFAULT00PRIMARY/ || n ~ /SCRIPTBRUSHTAGDEFAULT00SECONDARY/ ||
        n ~ /SCRIPTBRUSHTAGCLEAR11PRIMARY/ || n ~ /SCRIPTBRUSHTAGCLEAR11SECONDARY/) has_brush_tag_defaults = 1
    if (n ~ /TEXTDISPFINDENTRYINDEXBYWILDCARD/ || n ~ /TEXTDISPFINDENTRYINDEXBYWILDCAR/) has_wildcard_lookup = 1
    if (n ~ /SCRIPTCHANNELRANGEDIGITCHAR/ || n ~ /SCRIPTCHANNELRANGEARMEDFLAG/) saw_channel_range_digit = 1
    if (n ~ /CLEANUPALIGNEDSTATUSMATCHINDEX/ || n ~ /TEXTDISPCURRENTMATCHINDEX/) saw_channel_range_match = 1
    if (n ~ /TEXTDISPUPDATECHANNELRANGEFLAGS/) saw_channel_range_update = 1
    if (saw_channel_range_digit && saw_channel_range_match && saw_channel_range_update) has_channel_range_flow = 1
    if (n ~ /STRINGCOPYPADNUL/ || n ~ /PARSEREADSIGNEDLONGSKIPCLASS3ALT/ || n ~ /PARSEREADSIGNEDLONGSKIPCLASS3A/) saw_rtc_copy = 1
    if (u ~ /#1900([^0-9]|$)/ || u ~ /#\$76C/) saw_rtc_year = 1
    if (u ~ /#12([^0-9]|$)/ || u ~ /#60([^0-9]|$)/ || u ~ /#7([^0-9]|$)/ || u ~ /#\$C/ || u ~ /#\$3C/) saw_rtc_bounds = 1
    if (n ~ /APPLYRTCBYTESANDPERSIST/ || n ~ /ESQPARSAPPLYRTCBYTES/) saw_rtc_apply = 1
    if (saw_rtc_copy && saw_rtc_year && saw_rtc_bounds && saw_rtc_apply) has_rtc_validation = 1
    if (n ~ /SCRIPTPENDINGBANNERTARGETCHAR/ || n ~ /SCRIPTPENDINGBANNERSPEEDMS/ || n ~ /MATHMULU32/) saw_banner_speed_target = 1
    if (u ~ /#1000([^0-9]|$)/ || u ~ /#\$3E8/ || n ~ /TEXTDISPFINDENTRYINDEXBYWILDCARD/ ||
        n ~ /GLOBALWORDSELECTCODEISRAVESC/ || n ~ /GLOBALWORDSELECTCODEISRAVES/ || n ~ /CONFIGMSNFLAGCHAR/) saw_banner_speed_wildcard = 1
    if ((u ~ /#1000([^0-9]|$)/ || u ~ /#\$3E8/) && n ~ /SCRIPTPENDINGBANNERSPEEDMS/) saw_banner_speed_default = 1
    if (saw_banner_speed_target && saw_banner_speed_default && saw_banner_speed_wildcard) has_banner_speed_flow = 1
    if (n ~ /SCRIPTPENDINGTEXTDISPCMDARG/ || n ~ /SCRIPTPENDINGWEATHERCOMMANDCHAR/) has_pending_cmd_fields = 1
    if (n ~ /SCRIPTPENDINGTEXTDISPCMDCHAR/ || n ~ /SCRIPTPENDINGTEXTDISPCMDARG/) saw_textdisp_cmd = 1
    if (n ~ /SCRIPTPENDINGBANNERTARGETCHAR/) saw_pending_minus2 = 1
    if (u ~ /#-2([^0-9]|$)/ || u ~ /#\$FFFE/ || u ~ /#\$FFFFFFFE/) saw_pending_minus2 = 1
    if (saw_textdisp_cmd && saw_pending_minus2) has_pending_textdisp_reset = 1
    if (n ~ /HIGHLIGHTCUSTOMVALUE/) has_highlight_custom = 1
    if (n ~ /SCRIPTREADHANDSHAKEBIT5MASK/) has_handshake_bit5 = 1
    if (n ~ /LOCAVAILSETFILTERMODEANDRESETSTATE/ || n ~ /LOCAVAILFILTERMODEFLAG/ || n ~ /LOCAVAILFILTERSTEP/) saw_runtime_filter = 1
    if (n ~ /EDDIAGVINMODECHAR/ || n ~ /EDDIAGGRAPHMODECHAR/ || n ~ /SCRIPTREADHANDSHAKEBIT5MASK/) saw_runtime_diag = 1
    if (n ~ /SCRIPTRUNTIMEMODE/ || n ~ /SCRIPTPLAYBACKCURSOR/) saw_runtime_symbol = 1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#10([^0-9]|$)/ || u ~ /#\$A/ || u ~ /#\$4/) saw_runtime_constant = 1
    if (saw_runtime_symbol && saw_runtime_constant) saw_runtime_result = 1
    if (saw_runtime_filter && saw_runtime_diag && saw_runtime_result) has_runtime_branch = 1
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
    print "HAS_MULU32=" has_mulu
    print "HAS_CONSTS_14_15=" has_consts_14_15
    print "HAS_BRUSH_SELECTION=" has_brush_selection
    print "HAS_BRUSH_LIST_SCAN=" has_brush_list_scan
    print "HAS_BRUSH_TAG_DEFAULTS=" has_brush_tag_defaults
    print "HAS_WILDCARD_LOOKUP=" has_wildcard_lookup
    print "HAS_CHANNEL_RANGE_FLOW=" has_channel_range_flow
    print "HAS_RTC_VALIDATION=" has_rtc_validation
    print "HAS_BANNER_SPEED_FLOW=" has_banner_speed_flow
    print "HAS_PENDING_CMD_FIELDS=" has_pending_cmd_fields
    print "HAS_PENDING_TEXTDISP_RESET=" has_pending_textdisp_reset
    print "HAS_HIGHLIGHT_CUSTOM=" has_highlight_custom
    print "HAS_HANDSHAKE_BIT5=" has_handshake_bit5
    print "HAS_RUNTIME_BRANCH=" has_runtime_branch
    print "HAS_RETURN=" has_return
}
