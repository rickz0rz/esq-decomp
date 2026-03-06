BEGIN {
    has_open = 0
    has_write = 0
    has_format = 0
    has_close = 0
    has_return_one = 0
    has_rts = 0
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

    if (u ~ /(JSR|BSR).*DISKIO_OPENFILEWITHBUFFER/) has_open = 1
    if (u ~ /(JSR|BSR).*DISKIO_WRITEBUFFEREDBYTES/) has_write = 1
    if (u ~ /(JSR|BSR).*DATETIME_FORMATPAIRTOSTR/) has_format = 1
    if (u ~ /(JSR|BSR).*DISKIO_CLOSEBUFFEREDFILEANDFLUSH/) has_close = 1
    if (u ~ /MOVEQ(\.L)? #(\$)?1,D0/) has_return_one = 1
    if (u ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_OPEN=" has_open
    print "HAS_WRITE=" has_write
    print "HAS_FORMAT=" has_format
    print "HAS_CLOSE=" has_close
    print "HAS_RETURN_ONE=" has_return_one
    print "HAS_RTS=" has_rts
}
