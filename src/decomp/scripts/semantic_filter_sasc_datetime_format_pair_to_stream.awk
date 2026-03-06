BEGIN {
    sprintf_calls = 0
    append_calls = 0
    div_calls = 0
    write_calls = 0
    has_no_in_time = 0
    has_no_out_time = 0
    has_no_dst_data = 0
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

    if (u ~ /(JSR|BSR).*WDISP_SPRINTF/) sprintf_calls++
    if (u ~ /(JSR|BSR).*(STRING_APPENDATNULL|APPENDATNULL|APPENDATN)/) append_calls++
    if (u ~ /(JSR|BSR).*MATH_DIVS32/) div_calls++
    if (u ~ /(JSR|BSR).*DISKIO_WRITEBUFFEREDBYTES/) write_calls++
    if (u ~ /DST_STR_NO_IN_TIME/) has_no_in_time = 1
    if (u ~ /DST_STR_NO_OUT_TIME/) has_no_out_time = 1
    if (u ~ /DST_STR_NO_DST_DATA/) has_no_dst_data = 1
    if (u ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_SPRINTF_CALLS=" (sprintf_calls > 0 ? 1 : 0)
    print "HAS_APPEND_CALLS=" (append_calls > 0 ? 1 : 0)
    print "HAS_DIV_CALLS=" (div_calls > 0 ? 1 : 0)
    print "HAS_WRITE_CALLS=" (write_calls > 0 ? 1 : 0)
    print "HAS_NO_IN_TIME_PATH=" has_no_in_time
    print "HAS_NO_OUT_TIME_PATH=" has_no_out_time
    print "HAS_NO_DST_DATA_PATH=" has_no_dst_data
    print "HAS_RTS=" has_rts
}
