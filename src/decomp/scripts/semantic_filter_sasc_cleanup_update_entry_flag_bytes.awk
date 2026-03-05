BEGIN {
    has_label = 0
    has_get_ptr = 0
    has_default_copy = 0
    has_charclass = 0
    has_parse_hex = 0
    has_store_primary = 0
    has_store_secondary = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_UPDATEENTRYFLAGBYTES[A-Z0-9_]*:/) has_label = 1
    if (u ~ /COI_GETANIMFIELDPOINTERBYMODE/) has_get_ptr = 1
    if (u ~ /COPY_DEFAULT_ENTRY_LOOP/ || u ~ /CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY/ || u ~ /CLOCK_STR_FALLBACK_ENTRY_FLAGS_P/ || u ~ /MOVE.B \(A0\)\+,\(A1\)\+/ || u ~ /MOVE.B \(A2\)\+,\(A0\)\+/) has_default_copy = 1
    if (u ~ /WDISP_CHARCLASSTABLE/) has_charclass = 1
    if (u ~ /GROUP_AE_JMPTBL_LADFUNC_PARSEHEXDIGIT/ || u ~ /GROUP_AE_JMPTBL_LADFUNC_PARSEHEX/) has_parse_hex = 1
    if (u ~ /DISPTEXT_INSETNIBBLEPRIMARY/) has_store_primary = 1
    if (u ~ /DISPTEXT_INSETNIBBLESECONDARY/) has_store_secondary = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_GET_PTR=" has_get_ptr
    print "HAS_DEFAULT_COPY=" has_default_copy
    print "HAS_CHARCLASS=" has_charclass
    print "HAS_PARSE_HEX=" has_parse_hex
    print "HAS_STORE_PRIMARY=" has_store_primary
    print "HAS_STORE_SECONDARY=" has_store_secondary
    print "HAS_RETURN=" has_return
}
