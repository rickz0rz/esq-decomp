BEGIN {
    has_loadbuf = 0
    has_consume = 0
    has_findchar = 0
    has_cmp = 0
    has_init_preset = 0
    has_replace_owned = 0
    has_clear_source_cfg = 0
    has_proc_weather = 0
    has_parse_range = 0
    has_parse_color = 0
    has_load_weather = 0
    has_load_weather_msg = 0
    has_tag_qtable = 0
    has_tag_backdrop = 0
    has_tag_gradient = 0
    has_tag_textads = 0
    has_tag_brush = 0
    has_tag_banner = 0
    has_tag_default_text = 0
    has_tag_source_cfg = 0
    has_table_gradient = 0
    has_alias_count = 0
    has_weather_pending = 0
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

    if (n ~ /PARSEINIJMPTBLDISKIOLOADFILETOWORKBUFFER/) has_loadbuf = 1
    if (n ~ /PARSEINIJMPTBLDISKIOCONSUMELINEFROMWORKBUFFER/) has_consume = 1
    if (n ~ /PARSEINIJMPTBLSTRFINDCHARPTR/) has_findchar = 1
    if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASE/) has_cmp = 1
    if (n ~ /PARSEINIJMPTBLGCOMMANDINITPRESETTABLEFROMPALETTE/) has_init_preset = 1
    if (n ~ /PARSEINIJMPTBLESQPARSREPLACEOWNEDSTRING/) has_replace_owned = 1
    if (n ~ /TEXTDISPCLEARSOURCECONFIG/) has_clear_source_cfg = 1
    if (n ~ /PARSEINIPROCESSWEATHERBLOCKS/) has_proc_weather = 1
    if (n ~ /PARSEINIPARSERANGEKEYVALUE/) has_parse_range = 1
    if (n ~ /PARSEINIPARSECOLORTABLE/) has_parse_color = 1
    if (n ~ /PARSEINILOADWEATHERSTRINGS/) has_load_weather = 1
    if (n ~ /PARSEINILOADWEATHERMESSAGESTRINGS/) has_load_weather_msg = 1
    if (n ~ /PTYPESTRQTABLE/) has_tag_qtable = 1
    if (n ~ /PTYPETAGBACKDROP/) has_tag_backdrop = 1
    if (n ~ /PTYPETAGGRADIENT/) has_tag_gradient = 1
    if (n ~ /PTYPETAGTEXTADS/) has_tag_textads = 1
    if (n ~ /PTYPETAGBRUSH/) has_tag_brush = 1
    if (n ~ /PTYPETAGBANNER/) has_tag_banner = 1
    if (n ~ /PTYPESTRDEFAULTTEXT/) has_tag_default_text = 1
    if (n ~ /PTYPESTRSOURCECONFIG/) has_tag_source_cfg = 1
    if (n ~ /GCOMMANDGRADIENTPRESETTABLE/) has_table_gradient = 1
    if (n ~ /TEXTDISPALIASCOUNT/) has_alias_count = 1
    if (n ~ /PTYPEWEATHERBRUSHREFRESHPENDINGFLAG/) has_weather_pending = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_LOADBUF=" has_loadbuf
    print "HAS_CONSUME=" has_consume
    print "HAS_FINDCHAR=" has_findchar
    print "HAS_CMP=" has_cmp
    print "HAS_INIT_PRESET=" has_init_preset
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_CLEAR_SOURCE_CFG=" has_clear_source_cfg
    print "HAS_PROC_WEATHER=" has_proc_weather
    print "HAS_PARSE_RANGE=" has_parse_range
    print "HAS_PARSE_COLOR=" has_parse_color
    print "HAS_LOAD_WEATHER=" has_load_weather
    print "HAS_LOAD_WEATHER_MSG=" has_load_weather_msg
    print "HAS_TAG_QTABLE=" has_tag_qtable
    print "HAS_TAG_BACKDROP=" has_tag_backdrop
    print "HAS_TAG_GRADIENT=" has_tag_gradient
    print "HAS_TAG_TEXTADS=" has_tag_textads
    print "HAS_TAG_BRUSH=" has_tag_brush
    print "HAS_TAG_BANNER=" has_tag_banner
    print "HAS_TAG_DEFAULT_TEXT=" has_tag_default_text
    print "HAS_TAG_SOURCE_CFG=" has_tag_source_cfg
    print "HAS_TABLE_GRADIENT=" has_table_gradient
    print "HAS_ALIAS_COUNT=" has_alias_count
    print "HAS_WEATHER_PENDING=" has_weather_pending
    print "HAS_TERMINAL=" has_terminal
}
