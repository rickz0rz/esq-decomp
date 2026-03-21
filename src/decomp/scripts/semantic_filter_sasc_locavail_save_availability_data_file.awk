function norm(s, t) {
    t = toupper(s)
    sub(/;.*/, "", t)
    gsub(/^[ \t]+|[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return t
}

{
    line = norm($0)
    if (line == "") next

    if (line ~ /^LOCAVAIL_SAVEAVAILABILITYDATAFILE:/ || line ~ /^LOCAVAIL_SAVEAVAILABILITYDATAFIL[A-Z0-9_]*:/) has_entry = 1
    if (line ~ /GROUP_AY_JMPTBL_DISKIO_OPENFILEW/ || line ~ /OPENFILEWITHBUFFER/) has_open_file = 1
    if (line ~ /LOCAVAIL_PATH_DF0_COLON_LOCAVAIL/ && line ~ /MODE_NEWFILE/) has_open_args = 1
    if (line ~ /LOCAVAIL_STR_LA_VER_1_COLON_CURD/ || line ~ /LOCAVAIL_STR_LA_VER_1_COLON_CURDAY/) has_curday_header = 1
    if (line ~ /LOCAVAIL_STR_LA_VER_1_COLON_NXTD/ || line ~ /LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY/) has_nextday_header = 1
    if (line ~ /GROUP_AY_JMPTBL_DISKIO_WRITEDECI/ || line ~ /WRITEDECIMALFIELD/) has_write_decimal = 1
    if (line ~ /GROUP_AY_JMPTBL_DISKIO_WRITEBUFF/ || line ~ /WRITEBUFFEREDBYTES/) has_write_bytes = 1
    if (line ~ /GROUP_AY_JMPTBL_DISKIO_CLOSEBUFF/ || line ~ /CLOSEBUFFEREDFILEANDFLUSH/) has_close_file = 1
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_OPEN_FILE=" has_open_file
    print "HAS_OPEN_ARGS=" has_open_args
    print "HAS_CURDAY_HEADER=" has_curday_header
    print "HAS_NEXTDAY_HEADER=" has_nextday_header
    print "HAS_WRITE_DECIMAL=" has_write_decimal
    print "HAS_WRITE_BYTES=" has_write_bytes
    print "HAS_CLOSE_FILE=" has_close_file
    print "HAS_RETURN=" has_return
}
