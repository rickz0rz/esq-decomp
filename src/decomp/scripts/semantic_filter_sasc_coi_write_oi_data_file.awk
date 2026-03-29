BEGIN {
    has_label = 0
    has_primary_entry_guard = 0
    has_div_call = 0
    has_open_call = 0
    has_wildcard_call = 0
    has_close_call = 0
    has_open_error_status = 0
    has_return = 0
    has_secondary_pending_flag = 0
    has_secondary_pending_id = 0
    has_primary_pending_flag = 0
    has_primary_pending_id = 0
    has_secondary_table = 0
    has_primary_table = 0
    has_eof_marker = 0

    count_output_ops = 0
    count_format_ops = 0
    count_tab_delims = 0
    count_record_terminators = 0
    count_colon_a = 0
    count_colon_b = 0
    count_fmt_long_a = 0
    count_fmt_long_b = 0
    count_fmt_long_c = 0
    count_fmt_long_pad2 = 0
    count_fmt_dec_a = 0
    count_fmt_dec_b = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    if (line ~ /^(XREF|XDEF|END)( |$)/) next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^COI_WRITEOIDATAFILE[A-Z0-9_]*:/) has_label = 1
    if (u ~ /CMPI\.W #\$C8,D0/) has_primary_entry_guard = 1
    if (u ~ /GROUP_AG_JMPTBL_MATH_DIVS32/ || u ~ /GROUP_AG_JMPTBL_MATH_DIVS/) has_div_call = 1
    if (u ~ /DISKIO_OPENFILEWITHBUFFER/ || u ~ /DISKIO_OPENFILEWITHBUFF/) has_open_call = 1
    if (u ~ /ESQ_WILDCARDMATCH/ || u ~ /ESQ_WILDCARDMATC/) has_wildcard_call = 1
    if (u ~ /DISKIO_CLOSEBUFFEREDFILEANDFLUSH/ || u ~ /DISKIO_CLOSEBUFFEREDFILEAND/) has_close_call = 1
    if (u ~ /MOVEQ(\.L)? #(-3|\$FD),D0/) has_open_error_status = 1
    if (u ~ /CTASKS_SECONDARYOIWRITEPENDING/) has_secondary_pending_flag = 1
    if (u ~ /CTASKS_PENDINGSECONDARYOIDISKID/) has_secondary_pending_id = 1
    if (u ~ /CTASKS_PRIMARYOIWRITEPENDING/) has_primary_pending_flag = 1
    if (u ~ /CTASKS_PENDINGPRIMARYOIDISKID/) has_primary_pending_id = 1
    if (u ~ /TEXTDISP_SECONDARYENTRYPTRTABLE/ || u ~ /TEXTDISP_SECONDARYENTRYPTRTABL/) has_secondary_table = 1
    if (u ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/ || u ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/) has_primary_table = 1
    if (u ~ /CLOCK_FILEEOFMARKERCTRLZ/ || u ~ /CLOCK_FILEEOFMARKERCTR/) has_eof_marker = 1
    if (u == "RTS") has_return = 1

    if (u ~ /GROUP_AE_JMPTBL_WDISP_SPRINTF/ || u ~ /GROUP_AE_JMPTBL_WDISP_SPRIN/ ||
        u ~ /COI_WRITEFORMATTEDLONG/) {
        count_format_ops++
    }
    if (u ~ /DISKIO_WRITEBUFFEREDBYTES/ || u ~ /DISKIO_WRITEBUFFEREDBYT/ ||
        u ~ /COI_WRITEFORMATTEDLONG/ || u ~ /COI_WRITECSTRINGIFPRESENT/) {
        count_output_ops++
    }
    if (u ~ /COI_FIELDDELIMITERTAB/) count_tab_delims++
    if (u ~ /COI_RECORDTERMINATORCRLF/) count_record_terminators++
    if (u ~ /COI_STR_COLON_A/) count_colon_a++
    if (u ~ /COI_STR_COLON_B/) count_colon_b++
    if (u ~ /COI_FMT_LONG_DEC_A/) count_fmt_long_a++
    if (u ~ /COI_FMT_LONG_DEC_B/) count_fmt_long_b++
    if (u ~ /COI_FMT_LONG_DEC_C/) count_fmt_long_c++
    if (u ~ /COI_FMT_LONG_DEC_PAD2/) count_fmt_long_pad2++
    if (u ~ /COI_FMT_DEC_A/) count_fmt_dec_a++
    if (u ~ /COI_FMT_DEC_B/) count_fmt_dec_b++
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_PRIMARY_ENTRY_GUARD=" has_primary_entry_guard
    print "HAS_DIV_CALL=" has_div_call
    print "HAS_OPEN_CALL=" has_open_call
    print "HAS_WILDCARD_CALL=" has_wildcard_call
    print "HAS_CLOSE_CALL=" has_close_call
    print "HAS_OPEN_ERROR_STATUS=" has_open_error_status
    print "HAS_SECONDARY_PENDING_FLAG=" has_secondary_pending_flag
    print "HAS_SECONDARY_PENDING_ID=" has_secondary_pending_id
    print "HAS_PRIMARY_PENDING_FLAG=" has_primary_pending_flag
    print "HAS_PRIMARY_PENDING_ID=" has_primary_pending_id
    print "HAS_SECONDARY_TABLE=" has_secondary_table
    print "HAS_PRIMARY_TABLE=" has_primary_table
    print "HAS_EOF_MARKER=" has_eof_marker
    print "COUNT_OUTPUT_OPS=" count_output_ops
    print "COUNT_FORMAT_OPS=" count_format_ops
    print "COUNT_TAB_DELIMS=" count_tab_delims
    print "COUNT_RECORD_TERMINATORS=" count_record_terminators
    print "COUNT_COLON_A=" count_colon_a
    print "COUNT_COLON_B=" count_colon_b
    print "COUNT_FMT_LONG_A=" count_fmt_long_a
    print "COUNT_FMT_LONG_B=" count_fmt_long_b
    print "COUNT_FMT_LONG_C=" count_fmt_long_c
    print "COUNT_FMT_LONG_PAD2=" count_fmt_long_pad2
    print "COUNT_FMT_DEC_A=" count_fmt_dec_a
    print "COUNT_FMT_DEC_B=" count_fmt_dec_b
    print "HAS_RETURN=" has_return
}
