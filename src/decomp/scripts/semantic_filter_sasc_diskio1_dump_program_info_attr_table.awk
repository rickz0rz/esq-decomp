BEGIN {
    has_entry = 0
    has_program_info_fmt = 0
    has_null_guard = 0
    has_clock_ref = 0
    has_attr_test = 0
    has_copy_pad_nul = 0
    has_emit_escaped = 0
    has_suffix_fmt = 0
    fmt_calls = 0
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

    if (line ~ /FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ || line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTW/) fmt_calls++

    if (line ~ /DISKIO_FMT_PROGRAM_INFO_PCT_D/ || line ~ /DISKIO_FMT_PROGRAM_INFO_PCT_/) has_program_info_fmt = 1
    if (line ~ /^TST\.[BWL] / || line ~ /^CMP\.[BWL] #\$?0,/ || line ~ /^BEQ(\.[A-Z]+)? /) has_null_guard = 1
    if (line ~ /GLOBAL_REF_STR_CLOCK_FORMAT/) has_clock_ref = 1
    if (line ~ /^BTST / || line ~ /^ANDI\.[BWL] / || line ~ /^AND\.[BWL] / || line ~ /^CMP\.[BWL] / || line ~ /^CMPI\.[BWL] /) has_attr_test = 1
    if (line ~ /GROUP_AG_JMPTBL_STRING_COPYPADNUL/ || line ~ /GROUP_AG_JMPTBL_STRING_COPYPADNU/ || line ~ /STRING_COPYPADNUL/) has_copy_pad_nul = 1
    if (line ~ /GROUP_AG_JMPTBL_LADFUNC2_EMITESCAPEDSTRINGTOSCRATCH/ || line ~ /GROUP_AG_JMPTBL_LADFUNC2_EMITESC/ || line ~ /EMITESCAPEDSTRINGTOSCRATCH/) has_emit_escaped = 1
    if (line ~ /DISKIO_FMT_PROGRAMSTRINGSUFFIXWITHTYPEFIELDS/ || line ~ /DISKIO_FMT_PROGRAMSTRINGSUFFIXWITH/ || line ~ /DISKIO_FMT_PROGRAMSTRINGSUFFIXWI/) has_suffix_fmt = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PROGRAM_INFO_FMT=" has_program_info_fmt
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_CLOCK_REF=" has_clock_ref
    print "HAS_ATTR_TEST=" has_attr_test
    print "HAS_COPY_PAD_NUL=" has_copy_pad_nul
    print "HAS_EMIT_ESCAPED=" has_emit_escaped
    print "HAS_SUFFIX_FMT=" has_suffix_fmt
    print "FMT_CALL_COUNT_GE_6=" (fmt_calls >= 6)
}
