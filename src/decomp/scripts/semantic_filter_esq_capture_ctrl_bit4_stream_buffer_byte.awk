BEGIN {
    has_index_load = 0
    has_buffer_read = 0
    has_wrap_const = 0
    has_index_store = 0
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

    if (uline ~ /CTRL_HPREVIOUSSAMPLE/) has_index_load = 1
    if (uline ~ /CTRL_BUFFER/ || uline ~ /MOVE\.B \(A0\),D0/ || uline ~ /MOVE\.B \(0,A0/) has_buffer_read = 1
    if (uline ~ /#\$?1F4/ || uline ~ /#500/ || uline ~ /#-12/) has_wrap_const = 1
    if (uline ~ /MOVE\.W D1,CTRL_HPREVIOUSSAMPLE/ || uline ~ /CTRL_HPREVIOUSSAMPLE/) has_index_store = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_INDEX_LOAD=" has_index_load
    print "HAS_BUFFER_READ=" has_buffer_read
    print "HAS_WRAP_CONST=" has_wrap_const
    print "HAS_INDEX_STORE=" has_index_store
    print "HAS_RTS=" has_rts
}

