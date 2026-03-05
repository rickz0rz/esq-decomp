BEGIN {
    has_entry = 0
    has_link = 0
    has_save = 0
    has_lock_test = 0
    has_format = 0
    has_layout = 0
    has_status = 0
    has_restore = 0
    has_return = 0
    saw_d0_to_d7 = 0
    saw_d7_to_d0 = 0
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

    if (l ~ /LINK\.W A5,#-8/ || l ~ /MOVE\.L A7,D0/) has_link = 1
    if (l ~ /^MOVEM\.L .*,-\(A7\)$/) has_save = 1
    if (l ~ /DISPTEXT_LINETABLELOCKFLAG/ && (l ~ /TST\./ || l ~ /CMP\./)) has_lock_test = 1
    if (l ~ /GROUP_AI_JMPTBL_FORMAT_FORMATTOBUFFER2/ || l ~ /GROUP_AI_JMPTBL_FORMAT_FORMATTOBU/ || l ~ /GROUP_AI_JMPTBL_FORMAT_FORMATTOB/) has_format = 1
    if (l ~ /DISPTEXT_LAYOUTANDAPPENDTOBUFFER/) has_layout = 1
    if (l ~ /MOVE\.L D0,D7/) saw_d0_to_d7 = 1
    if (l ~ /MOVE\.L D7,D0/) saw_d7_to_d0 = 1
    if (l ~ /^MOVEM\.L \(A7\)\+,D7\/A3$/ || l ~ /^MOVEM\.L \(A7\)\+,[A-Z0-9\/\-]+$/) has_restore = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    if (saw_d0_to_d7 && saw_d7_to_d0) has_status = 1

    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_LOCK_TEST=" has_lock_test
    print "HAS_FORMAT=" has_format
    print "HAS_LAYOUT=" has_layout
    print "HAS_STATUS=" has_status
    print "HAS_RESTORE=" has_restore
    print "HAS_RETURN=" has_return
}
