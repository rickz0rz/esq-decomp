BEGIN {
    has_begin_banner = 0
    has_set_copper = 0
    has_set_rast = 0
    has_update_shadow = 0
    has_clear_search = 0
    has_deassert = 0
    has_runtime_mode = 0
    has_dispatch_latch = 0
    has_match_index = 0
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

    if (n ~ /SCRIPTBEGINBANNERCHARTRANSITION/) has_begin_banner = 1
    if (n ~ /WDISPJMPTBLESQSETCOPPEREFFECTONENABLEHIGHLIGHT/) has_set_copper = 1
    if (n ~ /TEXTDISPSETRASTFORMODE/) has_set_rast = 1
    if (n ~ /SCRIPTUPDATESERIALSHADOWFROMCTRLBYTE/) has_update_shadow = 1
    if (n ~ /SCRIPTCLEARSEARCHTEXTSANDCHANNELS/) has_clear_search = 1
    if (n ~ /SCRIPTDEASSERTCTRLLINENOW/) has_deassert = 1
    if (n ~ /SCRIPTRUNTIMEMODE/) has_runtime_mode = 1
    if (n ~ /SCRIPTRUNTIMEMODEDISPATCHLATCH/) has_dispatch_latch = 1
    if (n ~ /TEXTDISPCURRENTMATCHINDEX/) has_match_index = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_BEGIN_BANNER=" has_begin_banner
    print "HAS_SET_COPPER=" has_set_copper
    print "HAS_SET_RAST=" has_set_rast
    print "HAS_UPDATE_SHADOW=" has_update_shadow
    print "HAS_CLEAR_SEARCH=" has_clear_search
    print "HAS_DEASSERT=" has_deassert
    print "HAS_RUNTIME_MODE=" has_runtime_mode
    print "HAS_DISPATCH_LATCH=" has_dispatch_latch
    print "HAS_MATCH_INDEX=" has_match_index
    print "HAS_TERMINAL=" has_terminal
}
