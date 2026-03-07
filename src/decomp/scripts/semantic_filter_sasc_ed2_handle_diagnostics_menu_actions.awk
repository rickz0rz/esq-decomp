BEGIN {
    has_entry=0
    has_state_ring_key=0
    has_dispatch_chain=0
    has_toggle_mem_mask=0
    has_clear_counters=0
    has_diag_mode_update=0
    has_scroll_speed_path=0
    has_serial_shadow_path=0
    has_copper_effect_path=0
    has_ciab_path=0
    has_ctrl_line_path=0
    has_default_help=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ED2_HANDLEDIAGNOSTICSMENUACTIONS:/ || u ~ /^ED2_HANDLEDIAGNOSTICSMENUACTION[A-Z0-9_]*:/) has_entry=1
    if (n ~ /STATERINGINDEX/ && n ~ /STATERINGTABLE/ || n ~ /LASTKEYCODE/) has_state_ring_key=1
    if (n ~ /SUBQW/ && n ~ /BEQW/ || n ~ /SUBQL/ && n ~ /BEQW/ || n ~ /SUBQL/ || n ~ /BEQW___ED2HANDLEDIAGNOSTICSMENUACTIONS/ || n ~ /CASE/) has_dispatch_chain=1
    if (n ~ /DIAGAVAILMEMMASK/ || n ~ /DIAGAVAILMEMPRESETBITS/) has_toggle_mem_mask=1
    if (n ~ /DATACERRS/ || n ~ /LINEERRORCOUNT/ || n ~ /CTRLCMDCOUNT/) has_clear_counters=1
    if (n ~ /FINDNEXTCHARINTABLE/ || n ~ /DRAWDIAGNOSTICMODETEXT/) has_diag_mode_update=1
    if (n ~ /DIAGSCROLLSPEEDCHAR/ || n ~ /TEXTLIMIT/ || n ~ /BLOCKOFFSET/ || n ~ /MATHMULU32/) has_scroll_speed_path=1
    if (n ~ /UPDATESERIALSHADOWFROMCTRLBYTE/ || n ~ /UPDATESER/) has_serial_shadow_path=1
    if (n ~ /SETCOPPEREFFECTALLON/ || n ~ /SETCOPPEREFFECTOFFDISABLEHIGHLIGHT/ || n ~ /SETCOPPEREFFECTONENABLEHIGHLIGHT/ || n ~ /SETCOPPEREFFECTDEFAULT/ || n ~ /SETCOPPEREFF/) has_copper_effect_path=1
    if (n ~ /READCIABBIT5MASK/ || n ~ /STRCLOSED/ || n ~ /STROPEN/) has_ciab_path=1
    if (n ~ /ASSERTCTRLLINENOW/ || n ~ /DEASSERTCTRLLINENOW/ || n ~ /ASSERTCTR/ || n ~ /DEASSERTC/) has_ctrl_line_path=1
    if (n ~ /DRAWESCMENUBOTTOMHELP/ || n ~ /DIAGNOSTICSSCREENACTIVE/) has_default_help=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_STATE_RING_KEY=" has_state_ring_key
    print "HAS_DISPATCH_CHAIN=" has_dispatch_chain
    print "HAS_TOGGLE_MEM_MASK=" has_toggle_mem_mask
    print "HAS_CLEAR_COUNTERS=" has_clear_counters
    print "HAS_DIAG_MODE_UPDATE=" has_diag_mode_update
    print "HAS_SCROLL_SPEED_PATH=" has_scroll_speed_path
    print "HAS_SERIAL_SHADOW_PATH=" has_serial_shadow_path
    print "HAS_COPPER_EFFECT_PATH=" has_copper_effect_path
    print "HAS_CIAB_PATH=" has_ciab_path
    print "HAS_CTRL_LINE_PATH=" has_ctrl_line_path
    print "HAS_DEFAULT_HELP=" has_default_help
    print "HAS_RTS=" has_rts
}
