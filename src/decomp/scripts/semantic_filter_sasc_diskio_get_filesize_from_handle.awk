BEGIN {
    has_entry = 0
    has_seek_call = 0
    seek_calls = 0
    has_capture_size = 0
    has_return_size = 0
    has_rts = 0
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

    if (l ~ /^DISKIO_GETFILESIZEFROMHANDLE:/) has_entry = 1
    if (index(l, "_LVOSEEK") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) {
        has_seek_call = 1
        seek_calls++
    }
    if (l ~ /^MOVE\.L D0,D6$/ || l ~ /^MOVE\.L D0,-[0-9]+\(A5\)$/ || l ~ /^MOVE\.L D0,\(A[0-7]\)$/) has_capture_size = 1
    if (l ~ /^MOVE\.L D6,D0$/ || l ~ /^MOVE\.L -[0-9]+\(A5\),D0$/) has_return_size = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    if (has_seek_call == 1 && seek_calls >= 3) has_seek_call = 1

    print "HAS_ENTRY=" has_entry
    print "HAS_SEEK_CALL=" has_seek_call
    print "HAS_CAPTURE_SIZE=" has_capture_size
    print "HAS_RETURN_SIZE=" has_return_size
    print "HAS_RTS=" has_rts
}
