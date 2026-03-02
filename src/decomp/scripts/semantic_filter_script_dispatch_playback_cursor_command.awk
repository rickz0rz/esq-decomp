BEGIN {
    has_clear_search = 0
    has_reset_sel = 0
    has_set_copper = 0
    has_set_rast = 0
    has_update_shadow = 0
    has_custom_copper = 0
    has_render_aligned = 0
    has_weather = 0
    has_textdisp_cmd = 0
    has_assert_ctrl = 0
    has_read_latch = 0
    has_read_flags = 0
    has_pending_target = 0
    has_pending_speed = 0
    has_runtime_mode = 0
    has_fallback_counter = 0
    has_cursor_ptr_write = 0
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

    if (n ~ /SCRIPTCLEARSEARCHTEXTSANDCHANNELS/) has_clear_search = 1
    if (n ~ /TEXTDISPRESETSELECTIONANDREFRESH/) has_reset_sel = 1
    if (n ~ /WDISPJMPTBLESQSETCOPPEREFFECTONENABLEHIGHLIGHT/) has_set_copper = 1
    if (n ~ /TEXTDISPSETRASTFORMODE/) has_set_rast = 1
    if (n ~ /SCRIPTUPDATESERIALSHADOWFROMCTRLBYTE/) has_update_shadow = 1
    if (n ~ /SCRIPT3JMPTBLESQSETCOPPEREFFECTCUSTOM/) has_custom_copper = 1
    if (n ~ /SCRIPT3JMPTBLCLEANUPRENDERALIGNEDSTATUSSCREEN/) has_render_aligned = 1
    if (n ~ /WDISPHANDLEWEATHERSTATUSCOMMAND/) has_weather = 1
    if (n ~ /TEXTDISPHANDLESCRIPTCOMMAND/) has_textdisp_cmd = 1
    if (n ~ /SCRIPTASSERTCTRLLINENOW/) has_assert_ctrl = 1
    if (n ~ /SCRIPTREADMODEACTIVELATCH/) has_read_latch = 1
    if (n ~ /ESQPARS2READMODEFLAGS/) has_read_flags = 1
    if (n ~ /SCRIPTPENDINGBANNERTARGETCHAR/) has_pending_target = 1
    if (n ~ /SCRIPTPENDINGBANNERSPEEDMS/) has_pending_speed = 1
    if (n ~ /SCRIPTRUNTIMEMODE/) has_runtime_mode = 1
    if (n ~ /SCRIPTPLAYBACKFALLBACKCOUNTER/) has_fallback_counter = 1
    if (u ~ /\(A3\)/ || u ~ /\(A[0-7]\)/) has_cursor_ptr_write = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_CLEAR_SEARCH=" has_clear_search
    print "HAS_RESET_SEL=" has_reset_sel
    print "HAS_SET_COPPER=" has_set_copper
    print "HAS_SET_RAST=" has_set_rast
    print "HAS_UPDATE_SHADOW=" has_update_shadow
    print "HAS_CUSTOM_COPPER=" has_custom_copper
    print "HAS_RENDER_ALIGNED=" has_render_aligned
    print "HAS_WEATHER=" has_weather
    print "HAS_TEXTDISP_CMD=" has_textdisp_cmd
    print "HAS_ASSERT_CTRL=" has_assert_ctrl
    print "HAS_READ_LATCH=" has_read_latch
    print "HAS_READ_FLAGS=" has_read_flags
    print "HAS_PENDING_TARGET=" has_pending_target
    print "HAS_PENDING_SPEED=" has_pending_speed
    print "HAS_RUNTIME_MODE=" has_runtime_mode
    print "HAS_FALLBACK_COUNTER=" has_fallback_counter
    print "HAS_CURSOR_PTR_WRITE=" has_cursor_ptr_write
    print "HAS_TERMINAL=" has_terminal
}
