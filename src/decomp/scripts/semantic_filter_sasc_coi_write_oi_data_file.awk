BEGIN {
    has_label = 0
    has_div_call = 0
    has_sprintf_call = 0
    has_open_call = 0
    has_write_call = 0
    has_wildcard_call = 0
    has_close_call = 0
    has_return = 0
    has_secondary_table = 0
    has_primary_table = 0
    has_colon_a = 0
    has_colon_b = 0
    has_fmt_long_b = 0
    has_fmt_long_pad2 = 0
    has_fmt_dec_b = 0
    has_eof_marker = 0
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
    if (u ~ /TEXTDISP_SECONDARYENTRYPTRTABLE/ || u ~ /TEXTDISP_SECONDARYENTRYPTRTABL/) has_secondary_table = 1
    if (u ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/ || u ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/) has_primary_table = 1
    if (u ~ /COI_STR_COLON_A/) has_colon_a = 1
    if (u ~ /COI_STR_COLON_B/) has_colon_b = 1
    if (u ~ /COI_FMT_LONG_DEC_B/) has_fmt_long_b = 1
    if (u ~ /COI_FMT_LONG_DEC_PAD2/) has_fmt_long_pad2 = 1
    if (u ~ /COI_FMT_DEC_B/) has_fmt_dec_b = 1
    if (u ~ /CLOCK_FILEEOFMARKERCTRLZ/ || u ~ /CLOCK_FILEEOFMARKERCTR/) has_eof_marker = 1
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
    print "HAS_SECONDARY_TABLE=" has_secondary_table
    print "HAS_PRIMARY_TABLE=" has_primary_table
    print "HAS_COLON_A=" has_colon_a
    print "HAS_COLON_B=" has_colon_b
    print "HAS_FMT_LONG_B=" has_fmt_long_b
    print "HAS_FMT_LONG_PAD2=" has_fmt_long_pad2
    print "HAS_FMT_DEC_B=" has_fmt_dec_b
    print "HAS_EOF_MARKER=" has_eof_marker
    print "HAS_RETURN=" has_return
}
