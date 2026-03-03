BEGIN {
    has_entry = 0
    has_hotkey_cmp = 0
    has_force_refresh = 0
    has_free_list = 0
    has_parse_ini = 0
    has_populate = 0
    has_select_dt = 0
    has_find_pred = 0
    has_find_type3 = 0
    has_store_selected = 0
    has_store_fallback = 0
    has_reset_ctrl = 0
    has_rts = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQIFF_HANDLEBRUSHINIRELOADHOTKEY:/) has_entry = 1
    if (uline ~ /^CMP\.B D0,D7$/) has_hotkey_cmp = 1
    if (uline ~ /ESQIFF_JMPTBL_DISKIO_FORCEUIREFRESHIFIDLE/) has_force_refresh = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_FREEBRUSHLIST/) has_free_list = 1
    if (uline ~ /GROUP_AK_JMPTBL_PARSEINI_PARSEINIBUFFERANDDISPATCH/) has_parse_ini = 1
    if (uline ~ /GROUP_AU_JMPTBL_BRUSH_POPULATEBRUSHLIST/) has_populate = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHBYLABEL/) has_select_dt = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_FINDBRUSHBYPREDICATE/) has_find_pred = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_FINDTYPE3BRUSH/) has_find_type3 = 1
    if (uline ~ /^MOVE\.L D0,BRUSH_SELECTEDNODE$/) has_store_selected = 1
    if (uline ~ /^MOVE\.L D0,ESQFUNC_FALLBACKTYPE3BRUSHNODE$/) has_store_fallback = 1
    if (uline ~ /ESQIFF_JMPTBL_DISKIO_RESETCTRLINPUTSTATEIFIDLE/) has_reset_ctrl = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_HOTKEY_CMP=" has_hotkey_cmp
    print "HAS_FORCE_REFRESH=" has_force_refresh
    print "HAS_FREE_LIST=" has_free_list
    print "HAS_PARSE_INI=" has_parse_ini
    print "HAS_POPULATE=" has_populate
    print "HAS_SELECT_DT=" has_select_dt
    print "HAS_FIND_PRED=" has_find_pred
    print "HAS_FIND_TYPE3=" has_find_type3
    print "HAS_STORE_SELECTED=" has_store_selected
    print "HAS_STORE_FALLBACK=" has_store_fallback
    print "HAS_RESET_CTRL=" has_reset_ctrl
    print "HAS_RTS=" has_rts
}
