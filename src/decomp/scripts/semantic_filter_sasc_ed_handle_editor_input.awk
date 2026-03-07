BEGIN {
    h_entry=0
    h_cursor_draw=0
    h_mode_reinit=0
    h_char_adjust=0
    h_toggle_text_cursor=0
    h_delete_shift=0
    h_insert_shift=0
    h_nav_ring=0
    h_nav_mode=0
    h_spacing=0
    h_clear=0
    h_fill=0
    h_alt_ad=0
    h_finalize_sync=0
    h_color_indicator=0
    h_rts=0
}

function norm(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l=norm($0)
    if (l=="") next

    if (l ~ /^ED_HANDLEEDITORINPUT:/ || l ~ /^ED_HANDLEEDITORINPUT[A-Z0-9_]*:/) h_entry=1
    if (l ~ /(JSR|BSR).*ED_DRAWCURSORCHAR/) h_cursor_draw=1
    if (l ~ /ED_TEXTMODEREINITPENDINGFLAG/ || l ~ /BOOLISTEXTORCURSOR/) h_mode_reinit=1
    if (l ~ /EXTRACTHIGHNIBBLE/ || l ~ /EXTRACTLOWNIBBLE/ || l ~ /EXTRACTH/ || l ~ /EXTRACTL/ || l ~ /PACKNIBBLESTOBYTE/ || l ~ /MERGEHIGHLOWNIBBLES/ || l ~ /PACKNIBBLESTO/ || l ~ /MERGEHIGHLOWN/) h_char_adjust=1
    if (l ~ /SETAPEN1BPEN6DRMD1DRAWTEXTORCURSOR/ || l ~ /BOOLISTEXTORCURSOR/) h_toggle_text_cursor=1
    if (l ~ /MEM_MOVE/ && l ~ /SCRATCHSHIFTBASE/) h_delete_shift=1
    if (l ~ /MEM_MOVE/ && l ~ /LIVESHIFTBASE/) h_insert_shift=1
    if (l ~ /ED_STATERINGINDEX/ || l ~ /ED_STATERINGTABLE/ || l ~ /ED_LASTMENUINPUTCHAR/) h_nav_ring=1
    if (l ~ /DISPLIB_DISPLAYTEXTATPOSITION/ || l ~ /ED2_STR_PAGE/ || l ~ /ED2_STR_LINE/) h_nav_mode=1
    if (l ~ /TRANSFORMLINESPACING_MODE1/ || l ~ /TRANSFORMLINESPACING_MODE2/ || l ~ /TRANSFORMLINESPACING_MODE3/) h_spacing=1
    if (l ~ /EDITBUFFERSCRATCH/ && l ~ /#\$20/ || l ~ /ED_REDRAWALLROWS/) h_clear=1
    if (l ~ /ED_CURRENTCHAR/ && l ~ /ED_REDRAWROW/ || l ~ /ED_REDRAWALLROWS/) h_fill=1
    if (l ~ /ED_NEXTADNUMBER/ || l ~ /ED_PREVADNUMBER/) h_alt_ad=1
    if (l ~ /SYNC_CURRENT_CHAR/ || l ~ /ED_CURRENTCHAR/ && l ~ /EDITCURSOROFFSET/) h_finalize_sync=1
    if (l ~ /ED_DRAWCURRENTCOLORINDICATOR/ || l ~ /ED_REDRAWCURSORCHAR/) h_color_indicator=1
    if (l == "RTS") h_rts=1
}

END {
    print "HAS_ENTRY=" h_entry
    print "HAS_CURSOR_DRAW=" h_cursor_draw
    print "HAS_MODE_REINIT=" h_mode_reinit
    print "HAS_CHAR_ADJUST=" h_char_adjust
    print "HAS_TOGGLE_TEXT_CURSOR=" h_toggle_text_cursor
    print "HAS_DELETE_SHIFT=" h_delete_shift
    print "HAS_INSERT_SHIFT=" h_insert_shift
    print "HAS_NAV_RING=" h_nav_ring
    print "HAS_NAV_MODE=" h_nav_mode
    print "HAS_SPACING_TRANSFORMS=" h_spacing
    print "HAS_CLEAR_PATH=" h_clear
    print "HAS_FILL_PATH=" h_fill
    print "HAS_ALT_AD_NAV=" h_alt_ad
    print "HAS_FINALIZE_SYNC=" h_finalize_sync
    print "HAS_COLOR_INDICATOR=" h_color_indicator
    print "HAS_RTS=" h_rts
}
