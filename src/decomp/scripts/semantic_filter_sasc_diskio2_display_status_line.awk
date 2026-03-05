BEGIN {
    has_entry = 0
    has_pen_setup = 0
    has_draw_mode = 0
    has_spaces_ref = 0
    display_calls = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = trim($0)
    if (line == "") next

    if (ENTRY_PREFIX != "" && index(line, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(line, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (line ~ /LVOSETAPEN/ || line ~ /SETAPEN/) has_pen_setup = 1
    if (line ~ /LVOSETDRMD/ || line ~ /SETDRMD/) has_draw_mode = 1
    if (line ~ /GLOBAL_STR_38_SPACES/) has_spaces_ref = 1
    if (line ~ /DISPLIB_DISPLAYTEXTATPOSITION/) display_calls++
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PEN_SETUP=" has_pen_setup
    print "HAS_DRAW_MODE=" has_draw_mode
    print "HAS_SPACES_REF=" has_spaces_ref
    print "DISPLAY_CALL_COUNT_GE_2=" (display_calls >= 2)
}
