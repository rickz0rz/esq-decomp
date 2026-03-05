BEGIN {
    has_entry = 0
    has_str_find = 0
    has_read_bit3 = 0
    has_deassert = 0
    has_reset_selection = 0
    has_runtime_mode = 0
    has_stage = 0
    has_retry = 0
    has_ui_busy = 0
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

    if (u ~ /^SCRIPT_UPDATECTRLSTATEMACHINE:/ || u ~ /^SCRIPT_UPDATECTRLSTATEMACH[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /STRFINDCHARPTR/) has_str_find = 1
    if (n ~ /SCRIPTREADHANDSHAKEBIT3FLAG/ || n ~ /SCRIPTREADHANDSHAKEBIT3FLA/) has_read_bit3 = 1
    if (n ~ /SCRIPTDEASSERTCTRLLINENOW/ || n ~ /SCRIPTDEASSERTCTRLLINENO/) has_deassert = 1
    if (n ~ /TEXTDISPRESETSELECTIONANDREFRESH/ || n ~ /TEXTDISPRESETSELECTIONANDREFR/) has_reset_selection = 1
    if (n ~ /SCRIPTRUNTIMEMODE/) has_runtime_mode = 1
    if (n ~ /SCRIPTCTRLHANDSHAKESTAGE/) has_stage = 1
    if (n ~ /SCRIPTCTRLHANDSHAKERETRYCOUNT/ || n ~ /SCRIPTCTRLHANDSHAKERETRYCOU/) has_retry = 1
    if (n ~ /GLOBALUIBUSYFLAG/) has_ui_busy = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_STR_FIND=" has_str_find
    print "HAS_READ_BIT3=" has_read_bit3
    print "HAS_DEASSERT=" has_deassert
    print "HAS_RESET_SELECTION=" has_reset_selection
    print "HAS_RUNTIME_MODE=" has_runtime_mode
    print "HAS_STAGE=" has_stage
    print "HAS_RETRY=" has_retry
    print "HAS_UI_BUSY=" has_ui_busy
    print "HAS_RETURN=" has_return
}
