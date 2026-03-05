BEGIN {
    has_entry = 0
    has_index_load = 0
    has_buffer_read = 0
    has_wrap_const = 0
    has_index_store = 0
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

    if (l ~ /CTRL_HPREVIOUSSAMPLE/) has_index_load = 1
    if (l ~ /CTRL_BUFFER/ || l ~ /MOVE\.B \(A0\),D0/ || l ~ /MOVE\.B \(0,A0/) has_buffer_read = 1
    if (l ~ /#\$?1F4/ || l ~ /#500/ || l ~ /#-12/) has_wrap_const = 1
    if (l ~ /MOVE\.W D1,CTRL_HPREVIOUSSAMPLE/ || l ~ /CTRL_HPREVIOUSSAMPLE/) has_index_store = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INDEX_LOAD=" has_index_load
    print "HAS_BUFFER_READ=" has_buffer_read
    print "HAS_WRAP_CONST=" has_wrap_const
    print "HAS_INDEX_STORE=" has_index_store
    print "HAS_RETURN=" has_return
}
