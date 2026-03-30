BEGIN {
    has_label = 0

    saw_primary_entry_guard = 0
    saw_invalid_disk_status = 0

    saw_secondary_code = 0
    saw_secondary_present = 0
    saw_secondary_pending_flag = 0
    saw_secondary_pending_id = 0
    saw_secondary_entry_count = 0

    saw_primary_code = 0
    saw_primary_pending_flag = 0
    saw_primary_pending_id = 0
    saw_primary_entry_count = 0

    setup_stage = 0
    has_path_setup = 0
    has_open_error_status = 0

    header_stage = 0
    has_header_bundle = 0

    saw_secondary_table = 0
    saw_primary_table = 0
    entry_stage = 0
    has_entry_loop = 0
    duplicate_stage = 0
    has_duplicate_flow = 0
    compare_loop_stage = 0
    has_compare_loop = 0

    detail_stage = 0
    has_detail_bundle = 0

    subentry_stage = 0
    has_subentry_bundle = 0
    has_subentry_loop = 0

    finish_stage = 0
    has_finish_flow = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function advance_stage(stage, target) {
    if (stage == target - 1) {
        return target
    }
    return stage
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^COI_WRITEOIDATAFILE[A-Z0-9_]*:/) has_label = 1

    if (u ~ /CMPI\.W #\$C8,D0/) saw_primary_entry_guard = 1
    if (u ~ /MOVEQ(\.L)? #(1|\$1),D0/) saw_invalid_disk_status = 1

    if (u ~ /TEXTDISP_SECONDARYGROUPCODE/) saw_secondary_code = 1
    if (u ~ /TEXTDISP_SECONDARYGROUPPRESENTFL/) saw_secondary_present = 1
    if (u ~ /CTASKS_SECONDARYOIWRITEPENDINGFL/) saw_secondary_pending_flag = 1
    if (u ~ /CTASKS_PENDINGSECONDARYOIDISKID/) saw_secondary_pending_id = 1
    if (u ~ /TEXTDISP_SECONDARYGROUPENTRYCOUN/) saw_secondary_entry_count = 1

    if (u ~ /TEXTDISP_PRIMARYGROUPCODE/) saw_primary_code = 1
    if (u ~ /CTASKS_PRIMARYOIWRITEPENDINGFLAG/) saw_primary_pending_flag = 1
    if (u ~ /CTASKS_PENDINGPRIMARYOIDISKID/) saw_primary_pending_id = 1
    if (u ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/) saw_primary_entry_count = 1

    if (u ~ /GROUP_AG_JMPTBL_MATH_DIVS32/ || u ~ /GROUP_AG_JMPTBL_MATH_DIVS/) {
        setup_stage = advance_stage(setup_stage, 1)
    }
    if (u ~ /GLOBAL_STR_DF0_OI_PERCENT_2_LX_D/ && setup_stage >= 1) {
        setup_stage = advance_stage(setup_stage, 2)
    }
    if (u ~ /GROUP_AE_JMPTBL_WDISP_SPRINTF/ || u ~ /GROUP_AE_JMPTBL_WDISP_SPRIN/) {
        if (setup_stage >= 2) {
            setup_stage = advance_stage(setup_stage, 3)
        }
    }
    if (u ~ /DISKIO_OPENFILEWITHBUFFER/ || u ~ /DISKIO_OPENFILEWITHBUFF/) {
        if (setup_stage >= 3) {
            has_path_setup = 1
        }
    }
    if (u ~ /MOVEQ(\.L)? #(-3|\$FD),D0/) has_open_error_status = 1

    if (u ~ /COI_FMT_LONG_DEC_A/) header_stage = advance_stage(header_stage, 1)
    if (u ~ /COI_FIELDDELIMITERTAB/ && header_stage == 1) header_stage = advance_stage(header_stage, 2)
    if (u ~ /COI_FMT_DEC_A/ && header_stage >= 2) header_stage = advance_stage(header_stage, 3)
    if (u ~ /COI_RECORDTERMINATORCRLF/ && header_stage >= 3) has_header_bundle = 1

    if (u ~ /TEXTDISP_SECONDARYENTRYPTRTABLE/ || u ~ /TEXTDISP_SECONDARYENTRYPTRTABL/) saw_secondary_table = 1
    if (u ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/ || u ~ /TEXTDISP_PRIMARYENTRYPTRTABL/) saw_primary_table = 1
    if (u ~ /CMP\.W -32\(A5\),D0|CMP\.W D5,D0/) {
        entry_stage = advance_stage(entry_stage, 1)
    }
    if (u ~ /BGE\.[BW] / && entry_stage >= 1) {
        entry_stage = advance_stage(entry_stage, 2)
    }
    if (entry_stage >= 2 &&
        u ~ /ADDQ\.W #1,-26\(A5\)|ADDQ\.W #\$1,\$[0-9A-F]+\((A7|A5)\)/) {
        has_entry_loop = 1
    }
    if (u ~ /ESQ_WILDCARDMATCH/ || u ~ /ESQ_WILDCARDMATC/) duplicate_stage = advance_stage(duplicate_stage, 1)
    if (duplicate_stage >= 1 && u ~ /(SEQ|SCC) D1/) duplicate_stage = advance_stage(duplicate_stage, 2)
    if (duplicate_stage >= 2 && u ~ /NEG\.B D1/) duplicate_stage = advance_stage(duplicate_stage, 3)
    if (duplicate_stage >= 3 && u ~ /MOVE\.L D1,D6|MOVE\.L D1,\$[0-9A-F]+\((A7|A5)\)/) has_duplicate_flow = 1
    if (u ~ /CMP\.W -26\(A5\),D0|CMP\.W \$[0-9A-F]+\((A7|A5)\),D0/) {
        compare_loop_stage = advance_stage(compare_loop_stage, 1)
    }
    if ((u ~ /ESQ_WILDCARDMATCH/ || u ~ /ESQ_WILDCARDMATC/) && compare_loop_stage >= 1) {
        compare_loop_stage = advance_stage(compare_loop_stage, 2)
    }
    if (compare_loop_stage >= 2 &&
        u ~ /ADDQ\.W #1,-28\(A5\)|ADDQ\.W #\$1,\$[0-9A-F]+\((A7|A5)\)/) {
        has_compare_loop = 1
    }

    if (u ~ /COI_STR_COLON_A/) detail_stage = advance_stage(detail_stage, 1)
    if (u ~ /COI_FMT_LONG_DEC_B/ && detail_stage >= 1) detail_stage = advance_stage(detail_stage, 2)
    if (u ~ /COI_FMT_LONG_DEC_C/ && detail_stage >= 2) detail_stage = advance_stage(detail_stage, 3)
    if (u ~ /COI_RECORDTERMINATORCRLF/ && detail_stage >= 3) has_detail_bundle = 1

    if (u ~ /CMP\.W 36\(A2\),D0|CMP\.W D0,D1/) {
        subentry_stage = advance_stage(subentry_stage, 1)
    }
    if (u ~ /COI_FMT_LONG_DEC_PAD2/) subentry_stage = advance_stage(subentry_stage, 1)
    if (u ~ /COI_STR_COLON_B/ && subentry_stage >= 1) subentry_stage = advance_stage(subentry_stage, 2)
    if (u ~ /COI_FMT_DEC_B/ && subentry_stage >= 2) subentry_stage = advance_stage(subentry_stage, 3)
    if (u ~ /COI_RECORDTERMINATORCRLF/ && subentry_stage >= 3) has_subentry_bundle = 1
    if (subentry_stage >= 3 &&
        u ~ /ADDQ\.W #1,-28\(A5\)|ADDQ\.W #\$1,\$[0-9A-F]+\((A7|A5)\)/) {
        has_subentry_loop = 1
    }

    if (u ~ /CLOCK_FILEEOFMARKERCTRLZ/ || u ~ /CLOCK_FILEEOFMARKERCTR/) {
        finish_stage = advance_stage(finish_stage, 1)
    }
    if ((u ~ /DISKIO_CLOSEBUFFEREDFILEANDFLUSH/ || u ~ /DISKIO_CLOSEBUFFEREDFILEAND/) &&
        finish_stage >= 1) {
        finish_stage = advance_stage(finish_stage, 2)
    }
    if (finish_stage >= 2 &&
        (u ~ /MOVEQ(\.L)? #(0|\$0),D0/ || u == "CLR.L D0")) {
        finish_stage = advance_stage(finish_stage, 3)
    }
    if (finish_stage >= 3 && u == "RTS") has_finish_flow = 1
}

END {
    has_secondary_selection = (saw_secondary_code &&
        saw_secondary_present &&
        saw_secondary_pending_flag &&
        saw_secondary_pending_id &&
        saw_secondary_entry_count) ? 1 : 0

    has_primary_selection = (saw_primary_code &&
        saw_primary_pending_flag &&
        saw_primary_pending_id &&
        saw_primary_entry_count) ? 1 : 0

    has_table_bundle = (saw_secondary_table && saw_primary_table) ? 1 : 0

    print "HAS_LABEL=" has_label
    print "HAS_PRIMARY_ENTRY_GUARD=" saw_primary_entry_guard
    print "HAS_INVALID_DISK_STATUS=" saw_invalid_disk_status
    print "HAS_SECONDARY_SELECTION=" has_secondary_selection
    print "HAS_PRIMARY_SELECTION=" has_primary_selection
    print "HAS_PATH_SETUP=" has_path_setup
    print "HAS_OPEN_ERROR_STATUS=" has_open_error_status
    print "HAS_HEADER_BUNDLE=" has_header_bundle
    print "HAS_TABLE_BUNDLE=" has_table_bundle
    print "HAS_ENTRY_LOOP=" has_entry_loop
    print "HAS_DUPLICATE_FLOW=" has_duplicate_flow
    print "HAS_COMPARE_LOOP=" has_compare_loop
    print "HAS_DETAIL_BUNDLE=" has_detail_bundle
    print "HAS_SUBENTRY_BUNDLE=" has_subentry_bundle
    print "HAS_SUBENTRY_LOOP=" has_subentry_loop
    print "HAS_FINISH_FLOW=" has_finish_flow
}
