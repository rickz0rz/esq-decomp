BEGIN {
    has_entry = 0
    has_link = 0
    has_type_and_len = 0
    has_reply_port = 0
    has_payload_copy = 0
    has_validate = 0
    has_init_pattern = 0
    has_initrast = 0
    has_setfont = 0
    has_setdrmd = 0
    has_post_flags = 0
    has_putmsg = 0
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
    if (l ~ /LINK\.W A5,#-4/ || l ~ /^MOVEM\.L .*,-\(A7\)$/) has_link = 1
    if (l ~ /MOVE\.B #\$?5,(\$?8|8)\(A[35]\)/ || l ~ /MOVE\.W #\$?A0,\(A0\)/ || l ~ /MOVE\.W #\$?A0,(\$?12|18)\(A[35]\)/) has_type_and_len = 1
    if (l ~ /ESQ_HIGHLIGHTREPLYPORT/) has_reply_port = 1
    if (l ~ /(\$?14|\$?18|\$?1C|20|24|28)\(A[35]\)/) has_payload_copy = 1
    if (l ~ /VALIDATESELECTIONCODE/ || l ~ /VALIDATESE/) has_validate = 1
    if (l ~ /INITHIGHLIGHTMESSAGEPATTERN/ || l ~ /INITHIGHLIGHTMESSAGEPATT/) has_init_pattern = 1
    if (l ~ /LVOINITRASTPORT/) has_initrast = 1
    if (l ~ /LVOSETFONT/) has_setfont = 1
    if (l ~ /LVOSETDRMD/) has_setdrmd = 1
    if (l ~ /(\$?37|55)\(A0\)/ || l ~ /BSET #\$?0,(\$?35|53)\(A0\)/) has_post_flags = 1
    if (l ~ /LVOPUTMSG/) has_putmsg = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_TYPE_AND_LEN=" has_type_and_len
    print "HAS_REPLY_PORT=" has_reply_port
    print "HAS_PAYLOAD_COPY=" has_payload_copy
    print "HAS_VALIDATE=" has_validate
    print "HAS_INIT_PATTERN=" has_init_pattern
    print "HAS_INITRAST=" has_initrast
    print "HAS_SETFONT=" has_setfont
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_POST_FLAGS=" has_post_flags
    print "HAS_PUTMSG=" has_putmsg
    print "HAS_RETURN=" has_return
}
