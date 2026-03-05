BEGIN {
    has_entry = 0
    has_guard = 0
    has_open = 0
    has_header_write = 0
    has_entry_loop = 0
    has_equals = 0
    has_quote_open = 0
    has_quote_close = 0
    has_line_break = 0
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

    if (line ~ /TEXTDISP_ALIASCOUNT/ || line ~ /MOVEQ #-1,D0/ || line ~ /CMP.W D1,D0/) has_guard = 1
    if (line ~ /DISKIO_OPENFILEWITHBUFFER/) has_open = 1
    if (line ~ /DISKIO2_STR_QTABLE/ && line ~ /DISKIO_WRITEBUFFEREDBYTES/) has_header_write = 1
    if (line ~ /TEXTDISP_ALIASPTRTABLE/ || line ~ /WRITEQTABLE_ENTRY_LOOP/) has_entry_loop = 1
    if (line ~ /DISKIO2_STR_QTABLEEQUALS/) has_equals = 1
    if (line ~ /DISKIO2_STR_QTABLEVALUEQUOTEOPEN/) has_quote_open = 1
    if (line ~ /DISKIO2_STR_QTABLEVALUEQUOTECLOSE/ || line ~ /DISKIO2_STR_QTABLEVALUEQUOTECLOS/) has_quote_close = 1
    if (line ~ /DISKIO2_STR_QTABLELINEBREAKAFTERHEADER/ || line ~ /DISKIO2_STR_QTABLELINEBREAKAFTERENTRY/ || line ~ /DISKIO2_STR_QTABLELINEBREAKAFTER/) has_line_break = 1
    if (line ~ /DISKIO_CLOSEBUFFEREDFILEANDFLUSH/) has_close = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GUARD=" has_guard
    print "HAS_OPEN=" has_open
    print "HAS_HEADER_WRITE=" has_header_write
    print "HAS_ENTRY_LOOP=" has_entry_loop
    print "HAS_EQUALS=" has_equals
    print "HAS_QUOTE_OPEN=" has_quote_open
    print "HAS_QUOTE_CLOSE=" has_quote_close
    print "HAS_LINE_BREAK=" has_line_break
    print "HAS_CLOSE=" has_close
}
