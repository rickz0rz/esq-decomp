BEGIN {
    has_label = 0
    has_div_call = 0
    has_sprintf_call = 0
    has_open_call = 0
    has_write_call = 0
    has_wildcard_call = 0
    has_close_call = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^COI_WRITEOIDATAFILE[A-Z0-9_]*:/) has_label = 1
    if (u ~ /GROUP_AG_JMPTBL_MATH_DIVS32/ || u ~ /GROUP_AG_JMPTBL_MATH_DIVS/) has_div_call = 1
    if (u ~ /GROUP_AE_JMPTBL_WDISP_SPRINTF/ || u ~ /GROUP_AE_JMPTBL_WDISP_SPRIN/) has_sprintf_call = 1
    if (u ~ /DISKIO_OPENFILEWITHBUFFER/ || u ~ /DISKIO_OPENFILEWITHBUFF/) has_open_call = 1
    if (u ~ /DISKIO_WRITEBUFFEREDBYTES/ || u ~ /DISKIO_WRITEBUFFEREDBYT/) has_write_call = 1
    if (u ~ /ESQ_WILDCARDMATCH/ || u ~ /ESQ_WILDCARDMATC/) has_wildcard_call = 1
    if (u ~ /DISKIO_CLOSEBUFFEREDFILEANDFLUSH/ || u ~ /DISKIO_CLOSEBUFFEREDFILEAND/) has_close_call = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_DIV_CALL=" has_div_call
    print "HAS_SPRINTF_CALL=" has_sprintf_call
    print "HAS_OPEN_CALL=" has_open_call
    print "HAS_WRITE_CALL=" has_write_call
    print "HAS_WILDCARD_CALL=" has_wildcard_call
    print "HAS_CLOSE_CALL=" has_close_call
    print "HAS_RETURN=" has_return
}
