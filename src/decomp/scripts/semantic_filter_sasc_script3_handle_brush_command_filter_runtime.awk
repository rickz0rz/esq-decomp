BEGIN {
    has_label = 0

    saw_filter_step = 0
    saw_filter_mode_flag = 0
    saw_current_match = 0
    saw_playback_cursor = 0
    saw_runtime_mode = 0
    saw_type20_consume = 0
    saw_select_cursor = 0

    saw_set_filter_mode = 0
    saw_compute_filter_offset = 0
    saw_primary_filter_state = 0

    saw_diag_graph = 0
    saw_diag_vin = 0
    saw_brush_count = 0
    saw_highlight_active = 0
    saw_channel_range_arm = 0
    saw_handshake_bit5 = 0
    saw_to_upper = 0

    saw_const1 = 0
    saw_const2 = 0
    saw_const4 = 0
    saw_const10 = 0
    saw_char8 = 0
    saw_char9 = 0
    saw_charY = 0
    saw_charL = 0
    saw_char0 = 0
    saw_char1 = 0
    saw_char2 = 0
    saw_char3 = 0
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
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^SCRIPT_HANDLEBRUSHCOMMAND[A-Z0-9_]*:/) {
        has_label = 1
    }

    if (n ~ /LOCAVAILFILTERSTEP/) saw_filter_step = 1
    if (n ~ /LOCAVAILFILTERMODEFLAG/) saw_filter_mode_flag = 1
    if (n ~ /TEXTDISPCURRENTMATCHINDEX/) saw_current_match = 1
    if (n ~ /SCRIPTPLAYBACKCURSOR/) saw_playback_cursor = 1
    if (n ~ /SCRIPTRUNTIMEMODE/) saw_runtime_mode = 1
    if (n ~ /PTYPECONSUMEPRIMARYTYPEIFPRESENT/ || n ~ /PTYPECONSUMEPRIMARYTYPEIFPRES/) saw_type20_consume = 1
    if (n ~ /SCRIPTSELECTPLAYBACKCURSORFROMSEARCHTEXT/ || n ~ /SCRIPTSELECTPLAYBACKCURSORFRO/) saw_select_cursor = 1

    if (n ~ /LOCAVAILSETFILTERMODEANDRESETSTATE/ || n ~ /LOCAVAILSETFILTERMODEANDRESETST/) saw_set_filter_mode = 1
    if (n ~ /LOCAVAILCOMPUTEFILTEROFFSETFORENTRY/ || n ~ /LOCAVAILCOMPUTEFILTEROFFSETFORE/) saw_compute_filter_offset = 1
    if (n ~ /LOCAVAILPRIMARYFILTERSTATE/) saw_primary_filter_state = 1

    if (n ~ /EDDIAGGRAPHMODECHAR/) saw_diag_graph = 1
    if (n ~ /EDDIAGVINMODECHAR/) saw_diag_vin = 1
    if (n ~ /ESQIFFGADSBRUSHLISTCOUNT/) saw_brush_count = 1
    if (n ~ /WDISPHIGHLIGHTACTIVE/) saw_highlight_active = 1
    if (n ~ /SCRIPTCHANNELRANGEARMEDFLAG/) saw_channel_range_arm = 1
    if (n ~ /SCRIPTREADHANDSHAKEBIT5MASK/) saw_handshake_bit5 = 1
    if (n ~ /SCRIPT3TOUPPER/) saw_to_upper = 1

    if (index(u, "#$1") || index(u, "#1") || index(u, " 1.W")) saw_const1 = 1
    if (index(u, "#$2") || index(u, "#2") || index(u, " 2.W")) saw_const2 = 1
    if (index(u, "#$4") || index(u, "#4")) saw_const4 = 1
    if (index(u, "#$A") || index(u, "#10")) saw_const10 = 1

    if (index(u, "#$38") || index(u, "#56")) saw_char8 = 1
    if (index(u, "#$39") || index(u, "#57")) saw_char9 = 1
    if (index(u, "#$59") || index(u, "#89") || index(u, "'Y'")) saw_charY = 1
    if (index(u, "#$4C") || index(u, "#76") || index(u, "'L'")) saw_charL = 1
    if (index(u, "#$30") || index(u, "#48") || index(u, "'0'")) saw_char0 = 1
    if (index(u, "#$31") || index(u, "#49") || index(u, "'1'")) saw_char1 = 1
    if (index(u, "#$32") || index(u, "#50") || index(u, "'2'")) saw_char2 = 1
    if (index(u, "#$33") || index(u, "#51") || index(u, "'3'")) saw_char3 = 1
}

END {
    has_filterstep_match_reset = (saw_filter_step && saw_current_match && saw_playback_cursor && saw_const2) ? 1 : 0
    has_highlight_gate_cursor4 = (saw_diag_graph && saw_brush_count && saw_highlight_active &&
        saw_channel_range_arm && saw_playback_cursor && saw_const4) ? 1 : 0
    has_type20_fallback = saw_type20_consume ? 1 : 0
    has_filter_mode_set_path = (saw_set_filter_mode && saw_compute_filter_offset &&
        saw_primary_filter_state && saw_char9) ? 1 : 0
    has_filter_mode_clear_path = (saw_set_filter_mode && saw_filter_mode_flag && saw_char8) ? 1 : 0
    has_runtime_mode3_path = (saw_diag_vin && saw_runtime_mode &&
        saw_charY && saw_charL) ? 1 : 0
    has_runtime_cursor10_path = (saw_diag_vin && saw_handshake_bit5 && saw_playback_cursor &&
        saw_charY && saw_charL && saw_char1 && saw_char3 && saw_const10) ? 1 : 0

    print "HAS_LABEL=" has_label
    print "HAS_FILTERSTEP_MATCH_RESET=" has_filterstep_match_reset
    print "HAS_HIGHLIGHT_GATE_CURSOR4=" has_highlight_gate_cursor4
    print "HAS_TYPE20_FALLBACK=" has_type20_fallback
    print "HAS_FILTER_MODE_SET_PATH=" has_filter_mode_set_path
    print "HAS_FILTER_MODE_CLEAR_PATH=" has_filter_mode_clear_path
    print "HAS_RUNTIME_MODE3_PATH=" has_runtime_mode3_path
    print "HAS_RUNTIME_CURSOR10_PATH=" has_runtime_cursor10_path
}
