BEGIN {
    has_entry = 0
    has_row_ptr_words = 0
    has_bitmap_ptr_words = 0
    has_row_select = 0
    has_fallback_flag = 0
    has_default_f0 = 0
    has_preset_table_ref = 0
    has_update_ptr_call = 0
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
    u = toupper(line)

    if (u ~ /^GCOMMAND_BUILDBANNERROW:/) has_entry = 1
    if (u ~ /^MOVE\.W D[0-7],730\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],734\(A[0-7]\)$/ || u ~ /^LEA \$2DA\(A[0-7]\),A[0-7]$/ || u ~ /^LEA \$2DE\(A[0-7]\),A[0-7]$/) has_row_ptr_words = 1
    if (u ~ /^MOVE\.W D[0-7],714\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],718\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],694\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],698\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],702\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],706\(A[0-7]\)$/ || u ~ /^LEA \$2CA\(A[0-7]\),A[0-7]$/ || u ~ /^LEA \$2CE\(A[0-7]\),A[0-7]$/ || u ~ /^LEA \$2B6\(A[0-7]\),A[0-7]$/ || u ~ /^LEA \$2BA\(A[0-7]\),A[0-7]$/ || u ~ /^LEA \$2BE\(A[0-7]\),A[0-7]$/ || u ~ /^LEA \$2C2\(A[0-7]\),A[0-7]$/) has_bitmap_ptr_words = 1
    if (u ~ /^TST\.[LW] D[0-7]$/ || u ~ /^BLE\.[A-Z]+ / || u ~ /^MOVE\.L D[0-7],D[0-7]$/) has_row_select = 1
    if (index(u, "GCOMMAND_BANNERROWFALLBACKONFIRSTROWFLAG") > 0 || index(u, "GCOMMAND_BANNERROWFALLBACKONFIRS") > 0) has_fallback_flag = 1
    if (u ~ /^MOVE\.W #\$F0,D[0-7]$/ || u ~ /^MOVE\.W #\$F0,\(A[0-7]\)$/ || u ~ /^MOVE\.W #240,\(A[0-7]\)$/) has_default_f0 = 1
    if (index(u, "GCOMMAND_PRESETVALUETABLE") > 0 || index(u, "GCOMMAND_PRESETWORKENTRY") > 0) has_preset_table_ref = 1
    if (index(u, "GCOMMAND_UPDATEBANNERROWPOINTERS") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_update_ptr_call = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ROW_PTR_WORDS=" has_row_ptr_words
    print "HAS_BITMAP_PTR_WORDS=" has_bitmap_ptr_words
    print "HAS_ROW_SELECT=" has_row_select
    print "HAS_FALLBACK_FLAG=" has_fallback_flag
    print "HAS_DEFAULT_F0=" has_default_f0
    print "HAS_PRESET_TABLE_REF=" has_preset_table_ref
    print "HAS_UPDATE_PTR_CALL=" has_update_ptr_call
    print "HAS_RETURN=" has_return
}
