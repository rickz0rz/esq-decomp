BEGIN {
    has_entry = 0
    raster_refs = 0
    template_9306 = 0
    template_b306 = 0
    template_aaa = 0
    template_fffe = 0
    first_row_seed = 0
    second_row_seed = 0
    final_row_seed = 0
    final_tail_marker = 0
    db_writes = 0
    src_advances = 0
    build_block_calls = 0
    build_row_calls = 0
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

    if (u ~ /^XREF / || u ~ /^XDEF / || u == "END") next

    if (u ~ /^GCOMMAND_COPYIMAGEDATATOBITMAP:/ || u ~ /^GCOMMAND_COPYIMAGEDATATOBIT[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "WDISP_BANNERWORKRASTERPTR") > 0) raster_refs++
    if (u ~ /^MOVE\.W #\$9306,/) template_9306++
    if (u ~ /^MOVE\.W #\$B306,/) template_b306++
    if (u ~ /^MOVE\.W #\$AAA,/) template_aaa++
    if (u ~ /^MOVE\.W #\$FFFE,/) template_fffe++
    if (u ~ /^MOVE\.B [^,]+,(672|\$2A0)\(A[0-7]\)$/) first_row_seed = 1
    if (u ~ /^MOVE\.B [^,]+,(708|\$2C4)\(A[0-7]\)$/) second_row_seed = 1
    if (u ~ /^MOVE\.B [^,]+,(3876|\$F24)\(A[0-7]\)$/) final_row_seed = 1
    if (u ~ /^MOVE\.B #\$80,(3916|\$F4C)\(A[0-7]\)$/ || u ~ /^MOVE\.W #\$80FE,(3918|\$F4E)\(A[0-7]\)$/) final_tail_marker = 1
    if (u ~ /^MOVE\.B #\$DB,/) db_writes++
    if (u ~ /^ADD\.B [^,]+,\(A[0-7]\)$/) src_advances++
    if (index(u, "GCOMMAND_BUILDBANNERBLOCK") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) build_block_calls++
    if (index(u, "GCOMMAND_BUILDBANNERROW") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) build_row_calls++
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "RASTER_REFS=" raster_refs
    print "TEMPLATE_9306=" template_9306
    print "TEMPLATE_B306=" template_b306
    print "TEMPLATE_AAA=" template_aaa
    print "TEMPLATE_FFFE=" template_fffe
    print "FIRST_ROW_SEED=" first_row_seed
    print "SECOND_ROW_SEED=" second_row_seed
    print "FINAL_ROW_SEED=" final_row_seed
    print "FINAL_TAIL_MARKER=" final_tail_marker
    print "DB_WRITES=" db_writes
    print "SRC_ADVANCES=" src_advances
    print "BUILD_BLOCK_CALLS=" build_block_calls
    print "BUILD_ROW_CALLS=" build_row_calls
    print "HAS_RETURN=" has_return
}
