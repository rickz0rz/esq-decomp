BEGIN {
    has_entry = 0
    has_load = 0
    has_consume = 0
    has_skip_ws = 0
    has_findchar = 0
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
    has_qtable_alloc = 0
    has_qtable_reset = 0
    has_brush_reload = 0
    has_weather = 0
    has_source_config = 0
    has_cleanup = 0
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
    if (n ~ /PARSEINIJMPTBLDISKIOCONSUMELINEFROMWORKBUFFER/ || n ~ /DISKIOCONSUMELINEFROMWORKBUFFER/) has_consume = 1
    if (n ~ /PARSEINISKIPCLASS3CHARS/ || n ~ /WDISPCHARCLASSTABLE/) has_skip_ws = 1
    if (n ~ /PARSEINIJMPTBLSTRFINDCHARPTR/ || n ~ /STRFINDCHARPTR/) has_findchar = 1
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

    if (n ~ /TEXTDISPALIASPTRTABLE/ || n ~ /MEMORYALLOCATEMEMORY/) has_qtable_alloc = 1
    if (n ~ /TEXTDISPALIASCOUNT/) has_qtable_reset = 1

    if (n ~ /PARSEINITAGFILENAME/ || n ~ /PARSEINITAGBRUSH/ ||
        n ~ /GCOMMANDFINDPATHSEPARATOR/ || n ~ /HANDLEOPENWITHMODE/ ||
        n ~ /ESQIFFQUEUEIFFBRUSHLOAD/ || n ~ /ESQIFFHANDLEBRUSHINIRELOADHOTKEY/) has_brush_reload = 1

    if (n ~ /PARSEINIPROCESSWEATHERBLOCKS/ || n ~ /PARSEINIPARSECOLORTABLE/ ||
        n ~ /PARSEINILOADWEATHERSTRINGS/ || n ~ /PARSEINILOADWEATHERMESSAGESTRINGS/) has_weather = 1

    if (n ~ /TEXTDISPCLEARSOURCECONFIG/ || n ~ /TEXTDISPADDSOURCECONFIGENTRY/) has_source_config = 1
    if (n ~ /MEMORYDEALLOCATEMEMORY/ || n ~ /GLOBALSTRPARSEINIC2/) has_cleanup = 1
    if (u ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD=" has_load
    print "HAS_CONSUME=" has_consume
    print "HAS_SKIP_WS=" has_skip_ws
    print "HAS_FINDCHAR=" has_findchar
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
    print "HAS_QTABLE_ALLOC=" has_qtable_alloc
    print "HAS_QTABLE_RESET=" has_qtable_reset
    print "HAS_BRUSH_RELOAD=" has_brush_reload
    print "HAS_WEATHER=" has_weather
    print "HAS_SOURCE_CONFIG=" has_source_config
    print "HAS_CLEANUP=" has_cleanup
    print "HAS_RETURN=" has_return
}
