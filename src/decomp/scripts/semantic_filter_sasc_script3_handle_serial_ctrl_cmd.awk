BEGIN {
    has_entry = 0
    has_parse_change = 0
    has_capture_byte = 0
    has_handle_brush = 0
    has_apply_pending = 0
    has_tick_context = 0
    has_status_refresh = 0
    has_set_copper = 0
    has_set_rast = 0
    has_reset_selection = 0
    has_ctrl_state = 0
    has_ctrl_index = 0
    has_ctrl_checksum = 0
    has_ctrl_buffer = 0
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

    if (u ~ /^SCRIPT_HANDLESERIALCTRLCMD:/ || u ~ /^SCRIPT_HANDLESERIALCTRLC[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /PARSEINICHECKCTRLHCHANGE/) has_parse_change = 1
    if (n ~ /SCRIPTESQCAPTURECTRLBIT4STREAMBUFFERBYTE/ || n ~ /SCRIPTESQCAPTURECTRLBIT4STREAMBUFF/ || n ~ /SCRIPTESQCAPTURECTRLBIT4STREAM/ || n ~ /ESQCAPTURECTRLBIT4STREAMBUFFERBYTE/ || n ~ /ESQCAPTURECTRLBIT4STREAMBUFF/ || n ~ /ESQCAPTURECTRLBIT4STREAM/) has_capture_byte = 1
    if (n ~ /SCRIPTHANDLEBRUSHCOMMAND/ || n ~ /SCRIPTHANDLEBRUSHCOMMAN/) has_handle_brush = 1
    if (n ~ /SCRIPTAPPLYPENDINGBANNERTARGET/ || n ~ /SCRIPTAPPLYPENDINGBANNERTAR/) has_apply_pending = 1
    if (n ~ /SCRIPTPROCESSCTRLCONTEXTPLAYBACKTICK/ || n ~ /SCRIPTPROCESSCTRLCONTEXTPLAYBAC/) has_tick_context = 1
    if (n ~ /SCRIPT3JMPTBLESQDISPUPDATESTATUSMASKANDREFRESH/ || n ~ /SCRIPT3JMPTBLESQDISPUPDATESTATUSMAS/ || n ~ /SCRIPT3JMPTBLESQDISPUPDATESTA/ || n ~ /ESQDISPUPDATESTATUSMASKANDREFRESH/ || n ~ /ESQDISPUPDATESTATUSMASKANDREFR/ || n ~ /ESQDISPUPDATESTATUSMASKANDREFRE/) has_status_refresh = 1
    if (n ~ /WDISPJMPTBLESQSETCOPPEREFFECTONENABLEHIGHLIGHT/ || n ~ /WDISPJMPTBLESQSETCOPPEREFF/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGHLIGHT/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGHL/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGH/) has_set_copper = 1
    if (n ~ /TEXTDISPSETRASTFORMODE/ || n ~ /TEXTDISPSETRASTFORMOD/) has_set_rast = 1
    if (n ~ /TEXTDISPRESETSELECTIONANDREFRESH/ || n ~ /TEXTDISPRESETSELECTIONANDREFR/) has_reset_selection = 1
    if (n ~ /SCRIPTCTRLSTATE/) has_ctrl_state = 1
    if (n ~ /SCRIPTCTRLREADINDEX/ || n ~ /SCRIPTCTRLREADINDE/) has_ctrl_index = 1
    if (n ~ /SCRIPTCTRLCHECKSUM/ || n ~ /SCRIPTCTRLCHECKSU/) has_ctrl_checksum = 1
    if (n ~ /SCRIPTCTRLCMDBUFFER/ || n ~ /SCRIPTCTRLCMDBUFFE/) has_ctrl_buffer = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PARSE_CHANGE=" has_parse_change
    print "HAS_CAPTURE_BYTE=" has_capture_byte
    print "HAS_HANDLE_BRUSH=" has_handle_brush
    print "HAS_APPLY_PENDING=" has_apply_pending
    print "HAS_TICK_CONTEXT=" has_tick_context
    print "HAS_STATUS_REFRESH=" has_status_refresh
    print "HAS_SET_COPPER=" has_set_copper
    print "HAS_SET_RAST=" has_set_rast
    print "HAS_RESET_SELECTION=" has_reset_selection
    print "HAS_CTRL_STATE=" has_ctrl_state
    print "HAS_CTRL_INDEX=" has_ctrl_index
    print "HAS_CTRL_CHECKSUM=" has_ctrl_checksum
    print "HAS_CTRL_BUFFER=" has_ctrl_buffer
    print "HAS_RETURN=" has_return
}
