BEGIN {
    has_entry = 0
    has_active_ref = 0
    has_getmsg = 0
    has_load_preset = 0
    has_map_keycode = 0
    has_refresh = 0
    has_consume = 0
    has_live_copy = 0
    has_context_copy = 0
    has_tick_preset = 0
    has_reset_preset = 0
    has_reply = 0
    has_clear_active = 0
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

    if (u ~ /^GCOMMAND_SERVICEHIGHLIGHTMESSAGE[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "GCOMMAND_ACTIVEHIGHLIGHTMSGPTR") > 0 || index(u, "GCOMMAND_ACTIVEHIGHLIGHTMSGPT") > 0) has_active_ref = 1
    if (index(u, "_LVOGETMSG") > 0) has_getmsg = 1
    if (index(u, "GCOMMAND_LOADPRESETWORKENTRIES") > 0) has_load_preset = 1
    if (index(u, "GCOMMAND_MAPKEYCODETOPRESET") > 0) has_map_keycode = 1
    if (index(u, "GCOMMAND_REFRESHBANNERTABLES") > 0) has_refresh = 1
    if (index(u, "GCOMMAND_CONSUMEBANNERQUEUEENTRY") > 0) has_consume = 1
    if (index(u, "ESQSHARED4_COPYLIVEPLANESTOSNAPSHOT") > 0 || index(u, "ESQSHARED4_COPYLIVEPLANESTOSNAPS") > 0) has_live_copy = 1
    if (index(u, "ESQSHARED4_COPYPLANESFROMCONTEXTTOSNAPSHOT") > 0 || index(u, "ESQSHARED4_COPYPLANESFROMCONTEXT") > 0) has_context_copy = 1
    if (index(u, "GCOMMAND_TICKPRESETWORKENTRIES") > 0) has_tick_preset = 1
    if (index(u, "GCOMMAND_RESETPRESETWORKTABLES") > 0) has_reset_preset = 1
    if (index(u, "_LVOREPLYMSG") > 0) has_reply = 1
    if ((index(u, "GCOMMAND_ACTIVEHIGHLIGHTMSGPTR") > 0 || index(u, "GCOMMAND_ACTIVEHIGHLIGHTMSGPT") > 0) && (u ~ /^CLR\.L / || u ~ /^MOVE\.L D[0-7],/)) has_clear_active = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ACTIVE_REF=" has_active_ref
    print "HAS_GETMSG=" has_getmsg
    print "HAS_LOAD_PRESET=" has_load_preset
    print "HAS_MAP_KEYCODE=" has_map_keycode
    print "HAS_REFRESH=" has_refresh
    print "HAS_CONSUME=" has_consume
    print "HAS_LIVE_COPY=" has_live_copy
    print "HAS_CONTEXT_COPY=" has_context_copy
    print "HAS_TICK_PRESET=" has_tick_preset
    print "HAS_RESET_PRESET=" has_reset_preset
    print "HAS_REPLY=" has_reply
    print "HAS_CLEAR_ACTIVE=" has_clear_active
    print "HAS_RETURN=" has_return
}
