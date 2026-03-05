BEGIN {
    has_entry = 0
    has_finalize = 0
    has_line_index = 0
    has_line_ptr_table = 0
    has_len_table = 0
    has_textlength_call = 0
    has_return = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next
    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1
    if (l ~ /DISPTEXT_FINALIZELINETABLE/ || l ~ /DISPTEXT_FINALIZELINETAB/) has_finalize = 1
    if (l ~ /DISPTEXT_CURRENTLINEINDEX/) has_line_index = 1
    if (l ~ /DISPTEXT_LINEPTRTABLE/) has_line_ptr_table = 1
    if (l ~ /DISPTEXT_LINELENGTHTABLE/) has_len_table = 1
    if (l ~ /LVOTEXTLENGTH/) has_textlength_call = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FINALIZE=" has_finalize
    print "HAS_LINE_INDEX=" has_line_index
    print "HAS_LINE_PTR_TABLE=" has_line_ptr_table
    print "HAS_LEN_TABLE=" has_len_table
    print "HAS_TEXTLENGTH_CALL=" has_textlength_call
    print "HAS_RETURN=" has_return
}
