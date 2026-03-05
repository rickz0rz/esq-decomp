BEGIN {
    has_entry = 0
    has_open = 0
    has_open_guard = 0
    has_write_decimal = 0
    has_head_ptr = 0
    has_tail_ptr = 0
    write_bytes_calls = 0
    has_close = 0
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

    if (line ~ /DISKIO_OPENFILEWITHBUFFER/) has_open = 1
    if (line ~ /^TST\.[BWL] / || line ~ /^CMP\.[BWL] #\$?0,/ || line ~ /^BNE(\.[A-Z]+)? / || line ~ /^BEQ(\.[A-Z]+)? /) has_open_guard = 1
    if (line ~ /DISKIO_WRITEDECIMALFIELD/) has_write_decimal = 1
    if (line ~ /ESQIFF_PRIMARYLINEHEADPTR/) has_head_ptr = 1
    if (line ~ /ESQIFF_PRIMARYLINETAILPTR/) has_tail_ptr = 1
    if (line ~ /DISKIO_WRITEBUFFEREDBYTES/) write_bytes_calls++
    if (line ~ /DISKIO_CLOSEBUFFEREDFILEANDFLUSH/) has_close = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_OPEN=" has_open
    print "HAS_OPEN_GUARD=" has_open_guard
    print "HAS_WRITE_DECIMAL=" has_write_decimal
    print "HAS_HEAD_PTR=" has_head_ptr
    print "HAS_TAIL_PTR=" has_tail_ptr
    print "WRITE_BYTES_CALL_COUNT_GE_2=" (write_bytes_calls >= 2)
    print "HAS_CLOSE=" has_close
}
