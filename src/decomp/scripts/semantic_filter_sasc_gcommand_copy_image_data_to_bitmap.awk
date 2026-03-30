BEGIN {
    has_entry = 0
    raster_refs = 0
    template_9306 = 0
    template_b306 = 0
    template_aaa = 0
    template_fffe = 0
    reg_100 = 0
    reg_182 = 0
    reg_84 = 0
    reg_86 = 0
    reg_8a = 0
    reg_e0 = 0
    reg_e2 = 0
    reg_e4 = 0
    reg_e6 = 0
    reg_e8 = 0
    reg_ea = 0
    first_row_seed = 0
    first_row_d9 = 0
    first_row_ptr_block = 0
    second_row_seed = 0
    second_row_d9 = 0
    second_row_db = 0
    second_row_ptr_block = 0
    final_row_seed = 0
    final_row_neg39 = 0
    final_row_ptr_block = 0
    final_tail_marker = 0
    db_writes = 0
    src_advances = 0
    src_reads = 0
    build_block_calls = 0
    build_row_calls = 0
    has_return = 0
    pending_a1 = ""
    pending_a6 = ""
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark_pending(offset,    off) {
    off = toupper(offset)

    if (off == "24" || off == "34" || off == "6C" || off == "2A8" || off == "2D0" || off == "F54") reg_182++
    if (off == "28" || off == "54" || off == "2AC" || off == "2C8" || off == "F28" || off == "F58") reg_e0++
    if (off == "2C" || off == "58" || off == "2B0" || off == "2CC" || off == "F2C" || off == "F5C") reg_e2++

    if (off == "2A2") first_row_ptr_block = 1
    if (off == "2C6") second_row_ptr_block = 1
    if (off == "F26") final_row_ptr_block = 1
}

function parse_lea_offset(line, target,    s) {
    if (line !~ target) return ""
    s = line
    sub(/^LEA \$/, "", s)
    sub(/\(A0\),A[16]$/, "", s)
    return s
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^LEA \$[0-9A-F]+\(A0\),A1$/) {
        pending_a1 = parse_lea_offset(u, /,A1$/)
    } else if (u ~ /^LEA \$[0-9A-F]+\(A0\),A6$/) {
        pending_a6 = parse_lea_offset(u, /,A6$/)
    }

    if (u ~ /^XREF / || u ~ /^XDEF / || u == "END") next

    if (u ~ /^GCOMMAND_COPYIMAGEDATATOBITMAP:/ || u ~ /^GCOMMAND_COPYIMAGEDATATOBIT[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVE\.W [^,]+,\(A1\)$/ && pending_a1 != "") {
        mark_pending(pending_a1)
        pending_a1 = ""
    } else if (u ~ /^MOVE\.W [^,]+,\(A6\)$/ && pending_a6 != "") {
        mark_pending(pending_a6)
        pending_a6 = ""
    }
    if (index(u, "WDISP_BANNERWORKRASTERPTR") > 0) raster_refs++
    if (u ~ /^MOVE\.W #\$9306,/) template_9306++
    if (u ~ /^MOVE\.W #\$B306,/) template_b306++
    if (u ~ /^MOVE\.W #\$AAA,/) template_aaa++
    if (u ~ /^MOVE\.W #\$FFFE,/) template_fffe++
    if (u ~ /^MOVE\.W #\$100,/) reg_100++
    if (u ~ /^MOVE\.W #\$182,/ || u ~ /^MOVE\.W D[0-7],(36|\$24)\(A[0-7]\)$/ || u ~ /^MOVE\.W D[0-7],(52|\$34)\(A[0-7]\)$/) reg_182++
    if (u ~ /^MOVE\.W #\$84,/) reg_84++
    if (u ~ /^MOVE\.W #\$86,/) reg_86++
    if (u ~ /^MOVE\.W #\$8A,/) reg_8a++
    if (u ~ /^MOVE\.W #\$E0,/) reg_e0++
    if (u ~ /^MOVE\.W #\$E2,/) reg_e2++
    if (u ~ /^MOVE\.W #\$E4,/) reg_e4++
    if (u ~ /^MOVE\.W #\$E6,/) reg_e6++
    if (u ~ /^MOVE\.W #\$E8,/) reg_e8++
    if (u ~ /^MOVE\.W #\$EA,/) reg_ea++
    if (u ~ /^MOVE\.B [^,]+,(672|\$2A0)\(A[0-7]\)$/) first_row_seed = 1
    if (u ~ /^MOVE\.B #\$D9,(673|\$2A1)\(A[0-7]\)$/) first_row_d9 = 1
    if (u ~ /^MOVE\.W [^,]+,(674|\$2A2)\(A[0-7]\)$/ && u !~ /^MOVE\.W #/) first_row_ptr_block = 1
    if (u ~ /^MOVE\.B [^,]+,(708|\$2C4)\(A[0-7]\)$/) second_row_seed = 1
    if (u ~ /^MOVE\.B #\$DB,(709|\$2C5)\(A[0-7]\)$/) second_row_db = 1
    if (u ~ /^MOVE\.W [^,]+,(710|\$2C6)\(A[0-7]\)$/ && u !~ /^MOVE\.W #/) second_row_ptr_block = 1
    if (u ~ /^MOVE\.B [^,]+,(3876|\$F24)\(A[0-7]\)$/) final_row_seed = 1
    if (u ~ /^MOVE\.B [^,]+,(3877|\$F25)\(A[0-7]\)$/) final_row_neg39 = 1
    if (u ~ /^MOVE\.W [^,]+,(3878|\$F26)\(A[0-7]\)$/ && u !~ /^MOVE\.W #/) final_row_ptr_block = 1
    if (u ~ /^MOVE\.B #\$80,(3916|\$F4C)\(A[0-7]\)$/ || u ~ /^MOVE\.W #\$80FE,(3918|\$F4E)\(A[0-7]\)$/) final_tail_marker = 1
    if (u ~ /^MOVE\.B #\$DB,/) db_writes++
    if (u ~ /^ADD\.B [^,]+,\(A[0-7]\)$/) src_advances++
    if (u ~ /^MOVE\.B \(A[0-7]\),D[0-7]$/) src_reads++
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
    print "REG_100=" (reg_100 >= 5)
    print "REG_182=" (reg_182 >= 6)
    print "REG_84=" (reg_84 >= 3)
    print "REG_86=" (reg_86 >= 3)
    print "REG_8A=" (reg_8a >= 3)
    print "REG_E0=" (reg_e0 >= 4)
    print "REG_E2=" (reg_e2 >= 5)
    print "REG_E4=" (reg_e4 >= 3)
    print "REG_E6=" (reg_e6 >= 3)
    print "REG_E8=" (reg_e8 >= 3)
    print "REG_EA=" (reg_ea >= 3)
    print "FIRST_ROW_SEED=" first_row_seed
    print "FIRST_ROW_D9=" first_row_d9
    print "FIRST_ROW_PTR_BLOCK=" first_row_ptr_block
    print "SECOND_ROW_SEED=" second_row_seed
    print "SECOND_ROW_DB=" second_row_db
    print "SECOND_ROW_PTR_BLOCK=" second_row_ptr_block
    print "FINAL_ROW_SEED=" final_row_seed
    print "FINAL_ROW_NEG39=" final_row_neg39
    print "FINAL_ROW_PTR_BLOCK=" final_row_ptr_block
    print "FINAL_TAIL_MARKER=" final_tail_marker
    print "DB_WRITES=" db_writes
    print "SRC_ADVANCES=" src_advances
    print "SRC_READS=" src_reads
    print "BUILD_BLOCK_CALLS=" build_block_calls
    print "BUILD_ROW_CALLS=" build_row_calls
    print "HAS_RETURN=" has_return
}
