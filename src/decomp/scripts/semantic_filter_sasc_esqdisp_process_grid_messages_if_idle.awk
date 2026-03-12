BEGIN {
    has_entry = 0
    has_block_flag_test = 0
    has_ui_busy_test = 0
    has_suspend_flag_test = 0
    has_dispatch_call = 0
    has_return = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1
    if (l ~ /ESQDISP_GRIDMESSAGEPUMPBLOCKFLAG/) has_block_flag_test = 1
    if (l ~ /GLOBAL_UIBUSYFLAG/) has_ui_busy_test = 1
    if (l ~ /NEWGRID_MESSAGEPUMPSUSPENDFLAG/) has_suspend_flag_test = 1
    if (l ~ /ESQDISP_JMPTBL_NEWGRID_PROCESSGRIDMESSAGES/ || l ~ /ESQDISP_JMPTBL_NEWGRID_PROCESSGR/ || l ~ /NEWGRID_PROCESSGRIDMESSAGES/ || l ~ /NEWGRID_PROCESSGRIDMESSAGE/) has_dispatch_call = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_BLOCK_FLAG_TEST=" has_block_flag_test
    print "HAS_UI_BUSY_TEST=" has_ui_busy_test
    print "HAS_SUSPEND_FLAG_TEST=" has_suspend_flag_test
    print "HAS_DISPATCH_CALL=" has_dispatch_call
    print "HAS_RETURN=" has_return
}
