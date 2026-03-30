BEGIN {
    has_entry = 0
    has_load_file = 0
    has_load_fail_return = 0
    has_line_loop = 0
    has_skip_ws_class = 0
    has_skip_ws_probe = 0
    has_header_find_close = 0
    has_header_close_const = 0

    header_stage = 0
    has_gradient_init = 0
    has_banner_refresh_reset = 0
    default_text_reset_count = 0
    has_source_config_clear = 0
    has_unknown_section_reset = 0

    has_dispatch_table = 0
    has_dispatch_jump = 0

    qtable_stage = 0
    has_qtable_split = 0
    has_qtable_delim = 0
    has_qtable_store = 0
    qtable_quote_checks = 0
    has_qtable_alloc_table = 0
    has_qtable_alloc_call = 0
    has_qtable_success = 0
    has_qtable_reset = 0

    has_backdrop_delim = 0
    has_backdrop_dispatch = 0

    has_gradient_table = 0
    has_gradient_dispatch = 0

    has_textads_brush_delim = 0
    has_textads_brush_dispatch = 0

    has_banner_delim = 0
    has_banner_dispatch = 0

    has_default_delim = 0
    has_default_dispatch = 0

    has_source_delim = 0
    has_source_dispatch = 0

    has_cleanup_free = 0
    has_cleanup_tag = 0
    has_cleanup_size_plus_one = 0
    has_return = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function advance_stage(stage, target) {
    if (stage == target - 1) {
        return target
    }
    return stage
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

    if (u ~ /^PARSEINI_PARSEINIBUFFERANDDISPATCH:/ || u ~ /^PARSEINI_PARSEINIBUFFERANDDISPAT[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /DISKIOLOADFILETOWORKBUFFER/) has_load_file = 1
    if (n ~ /MOVEQFFD0/ || n ~ /MOVEQLFFD0/ || n ~ /MOVEQ1D0/ || n ~ /MOVEQLFFD0/) has_load_fail_return = 1
    if (n ~ /DISKIOCONSUMELINEFROMWORKBUFFER/) has_line_loop = 1
    if (n ~ /WDISPCHARCLASSTABLE/) has_skip_ws_class = 1
    if (n ~ /BTST3/ || n ~ /BTST30/ || n ~ /AND8/) has_skip_ws_probe = 1
    if (n ~ /STRFINDCHARPTR/) has_header_find_close = 1
    if (n ~ /PEA93W/ || n ~ /PEA5DW/ || n ~ /PEA95DW/) has_header_close_const = 1

    if (n ~ /PTYPESTRQTABLE/) header_stage = advance_stage(header_stage, 1)
    if (n ~ /PTYPETAGBACKDROP/ && header_stage >= 1) header_stage = advance_stage(header_stage, 2)
    if (n ~ /PTYPETAGGRADIENT/ && header_stage >= 2) header_stage = advance_stage(header_stage, 3)
    if (n ~ /GCOMMANDINITPRESETTABLEFROMPALETTE/ || n ~ /GCOMMANDINITPRESETTABLEFROMPALE/) has_gradient_init = 1
    if (n ~ /PTYPETAGTEXTADS/ && header_stage >= 3) header_stage = advance_stage(header_stage, 4)
    if (n ~ /PTYPETAGBRUSH/ && header_stage >= 4) header_stage = advance_stage(header_stage, 5)
    if (n ~ /PTYPETAGBANNER/ && header_stage >= 5) header_stage = advance_stage(header_stage, 6)
    if (n ~ /PTYPEWEATHERBRUSHREFRESHPENDINGFLAG/ || n ~ /PTYPEWEATHERBRUSHREFRESHPENDIN/) has_banner_refresh_reset = 1
    if (n ~ /PTYPESTRDEFAULTTEXT/ && header_stage >= 6) header_stage = advance_stage(header_stage, 7)
    if (n ~ /ESQPARSREPLACEOWNEDSTRING/ && header_stage >= 7) default_text_reset_count++
    if (n ~ /PTYPESTRSOURCECONFIG/ && header_stage >= 7) header_stage = advance_stage(header_stage, 8)
    if (n ~ /TEXTDISPCLEARSOURCECONFIG/ && header_stage >= 8) has_source_config_clear = 1
    if (n ~ /MOVEQ0D7/ || n ~ /MOVEQ0D0/ || n ~ /MOVEQL0D0/) has_unknown_section_reset = 1

    if (n ~ /DISPATCHTABLE/ || n ~ /SWITCHPARSEINIPARSEINIBUFFERANDDISPAT/) has_dispatch_table = 1
    if ((u ~ /^JMP / || u ~ /^DC\.W / || n ~ /JMP/) && has_dispatch_table) has_dispatch_jump = 1

    if (n ~ /PEA61W/ || n ~ /PEA3DW/) has_qtable_split = 1
    if (n ~ /STRFINDCHARPTR/ && (n ~ /61/ || n ~ /3D/)) qtable_stage = advance_stage(qtable_stage, 1)
    if (qtable_stage >= 1 && n ~ /PARSEINIDELIMSPACETABSECTION1/) {
        has_qtable_delim = 1
        qtable_stage = advance_stage(qtable_stage, 2)
    }
    if (qtable_stage >= 2 && n ~ /TEXTDISPALIASPTRTABLE/) has_qtable_alloc_table = 1
    if (qtable_stage >= 2 && n ~ /MEMORYALLOCATEMEMORY/) has_qtable_alloc_call = 1
    if (qtable_stage >= 2 && has_qtable_alloc_table && has_qtable_alloc_call) qtable_stage = advance_stage(qtable_stage, 3)
    if (qtable_stage >= 3 && n ~ /ESQPARSREPLACEOWNEDSTRING/) {
        has_qtable_store = 1
        qtable_stage = advance_stage(qtable_stage, 4)
    }
    if (qtable_stage >= 4 && ((n ~ /PEA34W/) || (n ~ /PEA22W/) || (n ~ /3522W/) || (n ~ /34/ && n ~ /STRFINDCHARPTR/) || (n ~ /22/ && n ~ /STRFINDCHARPTR/))) qtable_quote_checks++
    if (qtable_stage >= 4 && n ~ /TEXTDISPALIASCOUNT/ && (n ~ /MOVEW/ || n ~ /ADDQ/)) has_qtable_success = 1
    if (n ~ /TEXTDISPALIASCOUNT/ && (n ~ /CLRW/ || n ~ /MOVEQ0D0/)) has_qtable_reset = 1

    if (n ~ /PARSEINIDELIMSPACETABSECTION2/) has_backdrop_delim = 1
    if (n ~ /PARSEINIPROCESSWEATHERBLOCKS/) has_backdrop_dispatch = 1

    if (n ~ /GCOMMANDGRADIENTPRESETTABLE/) has_gradient_table = 1
    if (n ~ /PARSEINIPARSERANGEKEYVALUE/) has_gradient_dispatch = 1

    if (n ~ /PARSEINIDELIMSPACETABSECTION45/ || n ~ /PARSEINIDELIMSPACETABSECTION4/) has_textads_brush_delim = 1
    if (n ~ /PARSEINIPARSECOLORTABLE/) has_textads_brush_dispatch = 1

    if (n ~ /PARSEINIDELIMSPACETABSECTION6/) has_banner_delim = 1
    if (n ~ /PARSEINILOADWEATHERSTRINGS/) has_banner_dispatch = 1

    if (n ~ /PARSEINIDELIMSPACETABSECTION7/) has_default_delim = 1
    if (n ~ /PARSEINILOADWEATHERMESSAGESTRINGS/ || n ~ /PARSEINILOADWEATHERMESSAGESTRIN/) has_default_dispatch = 1

    if (n ~ /PARSEINIDELIMSPACETABSECTION8/) has_source_delim = 1
    if (n ~ /TEXTDISPADDSOURCECONFIGENTRY/) has_source_dispatch = 1

    if (n ~ /MEMORYDEALLOCATEMEMORY/) has_cleanup_free = 1
    if (n ~ /GLOBALSTRPARSEINIC2/) has_cleanup_tag = 1
    if (n ~ /ADDQ1D0/ || n ~ /ADDQL1D0/) has_cleanup_size_plus_one = 1
    if (u ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD_AND_FAIL_PATH=" (has_load_file && has_load_fail_return ? 1 : 0)
    print "HAS_LINE_LOOP=" (has_line_loop && has_skip_ws_class && has_skip_ws_probe && has_header_find_close && has_header_close_const ? 1 : 0)
    print "HAS_HEADER_CHAIN=" (header_stage >= 8 ? 1 : 0)
    print "HAS_GRADIENT_INIT=" has_gradient_init
    print "HAS_BANNER_REFRESH_RESET=" has_banner_refresh_reset
    print "HAS_DEFAULT_TEXT_RESET_TRIPLE=" (default_text_reset_count >= 3 ? 1 : 0)
    print "HAS_SOURCE_CONFIG_CLEAR=" has_source_config_clear
    print "HAS_UNKNOWN_SECTION_RESET=" (header_stage >= 8 ? 1 : has_unknown_section_reset)
    print "HAS_DISPATCH_SWITCH=" has_dispatch_table
    print "HAS_QTABLE_FLOW=" (has_qtable_split && has_qtable_delim && has_qtable_alloc_table && has_qtable_alloc_call && has_qtable_store && qtable_quote_checks >= 2 && has_qtable_success ? 1 : 0)
    print "HAS_QTABLE_RESET=" has_qtable_reset
    print "HAS_BACKDROP_FLOW=" (has_backdrop_delim && has_backdrop_dispatch ? 1 : 0)
    print "HAS_GRADIENT_FLOW=" (has_gradient_table && has_gradient_dispatch ? 1 : 0)
    print "HAS_TEXTADS_BRUSH_FLOW=" (has_textads_brush_delim && has_textads_brush_dispatch ? 1 : 0)
    print "HAS_BANNER_FLOW=" (has_banner_delim && has_banner_dispatch ? 1 : 0)
    print "HAS_DEFAULT_TEXT_FLOW=" (has_default_delim && has_default_dispatch ? 1 : 0)
    print "HAS_SOURCE_CONFIG_FLOW=" (has_source_delim && has_source_dispatch ? 1 : 0)
    print "HAS_CLEANUP_FREE=" (has_cleanup_free && has_cleanup_tag ? 1 : 0)
    print "HAS_CLEANUP_SIZE_PLUS_ONE=" has_cleanup_size_plus_one
    print "HAS_RETURN=" has_return
}
