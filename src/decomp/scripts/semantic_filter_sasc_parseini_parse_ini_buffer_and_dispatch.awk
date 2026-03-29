BEGIN {
    has_entry = 0
    has_load = 0
    has_load_fail_return = 0
    has_consume = 0
    has_skip_ws = 0
    has_findchar = 0
    has_findany = 0
    has_compare = 0
    has_section_qtable = 0
    has_section_backdrop = 0
    has_section_gradient = 0
    has_section_textads = 0
    has_section_brush = 0
    has_section_banner = 0
    has_section_default_text = 0
    has_section_source_config = 0
    has_gradient_init = 0
    has_banner_refresh_reset = 0
    has_default_text_current = 0
    has_default_text_forecast = 0
    has_default_text_bottom = 0
    has_source_config_clear = 0
    has_qtable_delim = 0
    has_qtable_alloc = 0
    has_qtable_store = 0
    has_qtable_reset = 0
    has_backdrop_delim = 0
    has_backdrop_dispatch = 0
    has_gradient_dispatch = 0
    has_textads_brush_delim = 0
    has_textads_brush_dispatch = 0
    has_banner_delim = 0
    has_banner_dispatch = 0
    has_default_text_delim = 0
    has_default_text_dispatch = 0
    has_source_config_delim = 0
    has_source_config_dispatch = 0
    has_unknown_section_reset = 0
    has_dispatch_switch = 0
    has_qtable_quote_fail_return = 0
    has_qtable_alias_increment = 0
    has_cleanup = 0
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

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^PARSEINI_PARSEINIBUFFERANDDISPATCH:/ || u ~ /^PARSEINI_PARSEINIBUFFERANDDISPAT[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /PARSEINIJMPTBLDISKIOLOADFILETOWORKBUFFER/ || n ~ /DISKIOLOADFILETOWORKBUFFER/) has_load = 1
    if (n ~ /MOVEQFFD0/ || n ~ /MOVEQLFFD0/ || n ~ /MOVEQ1D0/ || n ~ /MOVEQLFFD0BRA/) has_load_fail_return = 1
    if (n ~ /PARSEINIJMPTBLDISKIOCONSUMELINEFROMWORKBUFFER/ || n ~ /DISKIOCONSUMELINEFROMWORKBUFFER/) has_consume = 1
    if (n ~ /PARSEINISKIPCLASS3CHARS/ || n ~ /WDISPCHARCLASSTABLE/) has_skip_ws = 1
    if (n ~ /PARSEINIJMPTBLSTRFINDCHARPTR/ || n ~ /STRFINDCHARPTR/) has_findchar = 1
    if (n ~ /PARSEINIJMPTBLSTRFINDANYCHARPTR/ || n ~ /STRFINDANYCHARPTR/) has_findany = 1
    if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASE/ || n ~ /STRINGCOMPARENOCASE/) has_compare = 1

    if (n ~ /PTYPESTRQTABLE/) has_section_qtable = 1
    if (n ~ /PTYPETAGBACKDROP/) has_section_backdrop = 1
    if (n ~ /PTYPETAGGRADIENT/) has_section_gradient = 1
    if (n ~ /PTYPETAGTEXTADS/) has_section_textads = 1
    if (n ~ /PTYPETAGBRUSH/) has_section_brush = 1
    if (n ~ /PTYPETAGBANNER/) has_section_banner = 1
    if (n ~ /PTYPESTRDEFAULTTEXT/) has_section_default_text = 1
    if (n ~ /PTYPESTRSOURCECONFIG/) has_section_source_config = 1

    if (n ~ /GCOMMANDINITPRESETTABLEFROMPALETTE/ || n ~ /GCOMMANDGRADIENTPRESETTABLE/) has_gradient_init = 1
    if (n ~ /PTYPEWEATHERBRUSHREFRESHPEND/) has_banner_refresh_reset = 1
    if (n ~ /GLOBALSTRPTRNOCURRENTWEATHERDATAAVIALABLE/ || n ~ /PTYPEWEATHERCURRENTMSGPTR/) has_default_text_current = 1
    if (n ~ /SCRIPTPTRNOFORECASTWEATHERDATA/ || n ~ /PTYPEWEATHERFORECASTMSGPTR/) has_default_text_forecast = 1
    if (n ~ /SCRIPTPTRWEATHERDATAAVAILABILITYDISCLAIMER/ || n ~ /PTYPEWEATHERBOTTOMLINEMSGPTR/) has_default_text_bottom = 1
    if (n ~ /TEXTDISPCLEARSOURCECONFIG/) has_source_config_clear = 1

    if (n ~ /PARSEINIDELIMSPACETABSECTION1/) has_qtable_delim = 1
    if (n ~ /TEXTDISPALIASPTRTABLE/ || n ~ /MEMORYALLOCATEMEMORY/) has_qtable_alloc = 1
    if (n ~ /ESQPARSREPLACEOWNEDSTRING/) has_qtable_store = 1
    if (n ~ /TEXTDISPALIASCOUNT/) has_qtable_reset = 1

    if (n ~ /PARSEINIDELIMSPACETABSECTION2/) has_backdrop_delim = 1
    if (n ~ /PARSEINIPROCESSWEATHERBLOCKS/) has_backdrop_dispatch = 1

    if (n ~ /PARSEINIPARSERANGEKEYVALUE/) has_gradient_dispatch = 1

    if (n ~ /PARSEINIDELIMSPACETABSECTION4/ || n ~ /PARSEINIDELIMSPACETABSECTION45/) has_textads_brush_delim = 1
    if (n ~ /PARSEINIPARSECOLORTABLE/) has_textads_brush_dispatch = 1

    if (n ~ /PARSEINIDELIMSPACETABSECTION6/) has_banner_delim = 1
    if (n ~ /PARSEINILOADWEATHERSTRINGS/) has_banner_dispatch = 1

    if (n ~ /PARSEINIDELIMSPACETABSECTION7/) has_default_text_delim = 1
    if (n ~ /PARSEINILOADWEATHERMESSAGESTRINGS/ || n ~ /PARSEINILOADWEATHERMESSAGESTRIN/) has_default_text_dispatch = 1

    if (n ~ /PARSEINIDELIMSPACETABSECTION8/) has_source_config_delim = 1
    if (n ~ /TEXTDISPADDSOURCECONFIGENTRY/) has_source_config_dispatch = 1
    if (n ~ /MOVEQ0D7/ || n ~ /MOVEQL0D0/ || n ~ /MOVEQ0D0MOVELD038A7/ || n ~ /MOVEQL0D0MOVELD038A7/) has_unknown_section_reset = 1
    if (n ~ /DISPATCHTABLE/ || n ~ /SWITCHPARSEINIPARSEINIBUFFERANDDISPAT/) has_dispatch_switch = 1

    if (n ~ /MEMORYDEALLOCATEMEMORY/ || n ~ /GLOBALSTRPARSEINIC2/) has_cleanup = 1
    if (n ~ /CLRWTEXTDISPALIASCOUNT/ || n ~ /PEA22W/) has_qtable_quote_fail_return = 1
    if (n ~ /ADDQL1D0MOVEWD0TEXTDISPALIASCOUNT/ || n ~ /MOVEWD0TEXTDISPALIASCOUNT/) has_qtable_alias_increment = 1
    if (n ~ /ADDQL1D0/ || n ~ /MOVEW403W/ || n ~ /PEA403W/) has_cleanup_size_plus_one = 1
    if (u ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD=" has_load
    print "HAS_LOAD_FAIL_RETURN=" has_load_fail_return
    print "HAS_CONSUME=" has_consume
    print "HAS_SKIP_WS=" has_skip_ws
    print "HAS_FINDCHAR=" has_findchar
    print "HAS_FINDANY=" has_findany
    print "HAS_COMPARE=" has_compare
    print "HAS_SECTION_QTABLE=" has_section_qtable
    print "HAS_SECTION_BACKDROP=" has_section_backdrop
    print "HAS_SECTION_GRADIENT=" has_section_gradient
    print "HAS_SECTION_TEXTADS=" has_section_textads
    print "HAS_SECTION_BRUSH=" has_section_brush
    print "HAS_SECTION_BANNER=" has_section_banner
    print "HAS_SECTION_DEFAULT_TEXT=" has_section_default_text
    print "HAS_SECTION_SOURCE_CONFIG=" has_section_source_config
    print "HAS_GRADIENT_INIT=" has_gradient_init
    print "HAS_BANNER_REFRESH_RESET=" has_banner_refresh_reset
    print "HAS_DEFAULT_TEXT_RESET=" (has_default_text_current && has_default_text_forecast && has_default_text_bottom ? 1 : 0)
    print "HAS_SOURCE_CONFIG_CLEAR=" has_source_config_clear
    print "HAS_QTABLE_PARSE=" (has_qtable_delim && has_qtable_alloc && has_qtable_store ? 1 : 0)
    print "HAS_QTABLE_RESET=" has_qtable_reset
    print "HAS_QTABLE_QUOTE_FAIL_RETURN=" has_qtable_quote_fail_return
    print "HAS_QTABLE_ALIAS_INCREMENT=" has_qtable_alias_increment
    print "HAS_BACKDROP_PARSE=" (has_backdrop_delim && has_backdrop_dispatch ? 1 : 0)
    print "HAS_GRADIENT_PARSE=" has_gradient_dispatch
    print "HAS_TEXTADS_BRUSH_PARSE=" (has_textads_brush_delim && has_textads_brush_dispatch ? 1 : 0)
    print "HAS_BANNER_PARSE=" (has_banner_delim && has_banner_dispatch ? 1 : 0)
    print "HAS_DEFAULT_TEXT_PARSE=" (has_default_text_delim && has_default_text_dispatch ? 1 : 0)
    print "HAS_SOURCE_CONFIG_PARSE=" (has_source_config_delim && has_source_config_dispatch ? 1 : 0)
    print "HAS_UNKNOWN_SECTION_RESET=" has_unknown_section_reset
    print "HAS_DISPATCH_SWITCH=" has_dispatch_switch
    print "HAS_CLEANUP=" has_cleanup
    print "HAS_CLEANUP_SIZE_PLUS_ONE=" has_cleanup_size_plus_one
    print "HAS_RETURN=" has_return
}
