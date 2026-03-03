BEGIN {
    has_label = 0
    has_link = 0
    has_div_call = 0
    has_sprintf_call = 0
    has_open_call = 0
    has_write_call = 0
    has_wildcard_call = 0
    has_close_call = 0
    has_return = 0
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

    if (uline ~ /^COI_WRITEOIDATAFILE:/) has_label = 1
    if (index(uline, "LINK.W A5,#-152") > 0) has_link = 1
    if (index(uline, "GROUP_AG_JMPTBL_MATH_DIVS32") > 0) has_div_call = 1
    if (index(uline, "GROUP_AE_JMPTBL_WDISP_SPRINTF") > 0) has_sprintf_call = 1
    if (index(uline, "DISKIO_OPENFILEWITHBUFFER") > 0) has_open_call = 1
    if (index(uline, "DISKIO_WRITEBUFFEREDBYTES") > 0) has_write_call = 1
    if (index(uline, "ESQ_WILDCARDMATCH") > 0) has_wildcard_call = 1
    if (index(uline, "DISKIO_CLOSEBUFFEREDFILEANDFLUSH") > 0) has_close_call = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_DIV_CALL=" has_div_call
    print "HAS_SPRINTF_CALL=" has_sprintf_call
    print "HAS_OPEN_CALL=" has_open_call
    print "HAS_WRITE_CALL=" has_write_call
    print "HAS_WILDCARD_CALL=" has_wildcard_call
    print "HAS_CLOSE_CALL=" has_close_call
    print "HAS_RETURN=" has_return
}
