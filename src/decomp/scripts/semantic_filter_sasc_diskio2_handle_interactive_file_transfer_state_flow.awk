BEGIN {
    has_label = 0

    status_update_count = 0

    checksum_seed_default = 0
    checksum_seed_crc32 = 0

    filename_cap = 0
    filename_waits = 0
    filename_reads = 0
    filename_xor = 0
    filename_eor_seen = 0
    filename_loop_flow = 0

    ngad_stage = 0
    has_ngad_guard = 0

    target_stage = 0
    target_copy_count = 0
    filename_display_calls = 0
    saw_target_copy_loop = 0
    saw_ram_prefix_copy = 0
    saw_short_name_copy = 0
    has_target_setup = 0

    size_stage = 0
    has_size_guard_flow = 0
    attention_clear_count = 0
    has_oversize_exit = 0

    checksum_gate_count = 0
    has_checksum_gate = 0

    open_fail_stage = 0
    has_open_fail = 0

    transfer_setup_stage = 0
    transfer_setup_done = 0

    sync_stage = 0
    receive_call_count = 0
    has_receive_dispatch = 0

    delete_bb_count = 0
    delete_ff_count = 0
    delete_not_count = 0
    has_delete_marker_flow = 0

    close_call_count = 0
    dealloc_call_count = 0
    clear_line_count = 0
    has_teardown_flow = 0

    success_stage = 0
    delete_file_count = 0
    append_count = 0
    has_success_copy_flow = 0

    error_draw_count = 0
    has_error_cleanup = 0

    finalize_stage = 0
    finalize_display_calls = 0
    has_finalize_diag = 0
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

    if (u ~ /^DISKIO2_HANDLEINTERACTIVEFILETRA[A-Z0-9_]*:/) {
        has_label = 1
    }

    if (u ~ /UPDATESTATUSMASKANDREFRESH|UPDATESTATUSMASKANDREFRE/) {
        status_update_count++
    }

    if (u ~ /#\$B7|#183|NOT\.B D0/) {
        checksum_seed_default = 1
    }
    if (u ~ /#\$C2|#194|MOVEQ(\.L)? #\$61,D0/) {
        checksum_seed_crc32 = 1
    }

    if (u ~ /CMPI\.B #\$1F|MOVEQ(\.L)? #\$1F,D0/) {
        filename_cap = 1
    }
    if (u ~ /WAITFORCLOCKCHANGEANDSERVICEUI|WAITFORCLOCKCHANGEANDSER/) {
        filename_waits++
    }
    if (u ~ /SCRIPT_READSERIALRBFBYTE|SCRIPT_READNEXTRBFBYTE|READSERIALRBFBYTE/) {
        filename_reads++
    }
    if (u ~ /EOR\.B/) {
        filename_eor_seen = 1
    }
    if (u ~ /TRANSFERXORCHECKSUMBYTE/ && filename_eor_seen) {
        filename_xor = 1
    }
    if (filename_cap && filename_waits >= 2 && filename_reads >= 1 && filename_xor) {
        filename_loop_flow = 1
    }

    if (u ~ /CTASKS_EXT_GRF/) {
        ngad_stage = advance_stage(ngad_stage, 1)
    }
    if (u ~ /ESQ_WILDCARDMATCH|WILDCARDMATCH/) {
        if (ngad_stage >= 1) {
            ngad_stage = advance_stage(ngad_stage, 2)
        }
    }
    if (u ~ /GLOBAL_STR_SPECIAL_NGAD/) {
        if (ngad_stage >= 2) {
            has_ngad_guard = 1
        }
    }

    if (u ~ /LEA DISKIO2_TRANSFERFILENAMEBUFFER|PEA DISKIO2_TRANSFERFILENAMEBUFFER/) {
        target_stage = advance_stage(target_stage, 1)
    }
    if (u ~ /MOVE\.B \(A0\)\+,\(A1\)\+|MOVE\.B D0,\$0\(A0,D1\.W\)/) {
        if (target_stage >= 1) {
            saw_target_copy_loop = 1
        }
    }
    if (u ~ /STRING_COPYPADNUL|COPYPADNUL/) {
        target_copy_count++
    }
    if (u ~ /GLOBAL_STR_RAM/) {
        saw_ram_prefix_copy = 1
    }
    if ((u ~ /DISKIO2_TRANSFERFILENAMEBUFFER/ || u ~ /\$CC\(A7\)|-68\(A5\)/) &&
        target_copy_count >= 2) {
        saw_short_name_copy = 1
    }
    if ((saw_target_copy_loop || target_copy_count >= 1) && saw_ram_prefix_copy) {
        target_stage = advance_stage(target_stage, 2)
    }
    if (u ~ /GLOBAL_STR_FILENAME/ && target_stage >= 2) {
        target_stage = advance_stage(target_stage, 3)
    }
    if (u ~ /DISPLIB_DISPLAYTEXTATPOSITION/) {
        filename_display_calls++
    }
    if ((u ~ /MOVE\.B D0,-64\(A5\)|CLR\.B \$C8\(A7\)/) && target_stage >= 3) {
        target_stage = advance_stage(target_stage, 4)
    }
    if (target_stage >= 4 && filename_display_calls >= 2 &&
        saw_ram_prefix_copy && saw_short_name_copy) {
        has_target_setup = 1
    }

    if (u ~ /CMPI\.B #\$8|MOVEQ(\.L)? #\$8,D0/) {
        size_stage = advance_stage(size_stage, 1)
    }
    if (u ~ /LVOLock|_LVOLock/i || u ~ /LOCK\(A6\)/) {
        if (size_stage >= 1) {
            size_stage = advance_stage(size_stage, 2)
        }
    }
    if (u ~ /LVOINFO|_LVOINFO|STRUCT_INFODATA_SIZE/) {
        if (size_stage >= 2) {
            size_stage = advance_stage(size_stage, 3)
        }
    }
    if (u ~ /LVOUNLOCK|_LVOUNLOCK/) {
        if (size_stage >= 3) {
            size_stage = advance_stage(size_stage, 4)
        }
    }
    if (u ~ /PARSE_READSIGNEDLONGSKIPCLASS3|READSIGNEDLONGSKIPCLASS3/) {
        if (size_stage >= 4) {
            size_stage = advance_stage(size_stage, 5)
        }
    }
    if (u ~ /SHOWATTENTIONOVERLAY|BRUSH_SNAPSHOTHEADER/) {
        if (size_stage >= 5) {
            has_size_guard_flow = 1
        }
    }
    if (u ~ /INTERACTIVETRANSFERARMED/) {
        attention_clear_count++
    }
    if (has_size_guard_flow && attention_clear_count >= 1 &&
        (u ~ /MOVEQ(\.L)? #(-2|\$FE),D0/ || u ~ /MOVEQ #\$FE,D0/)) {
        has_oversize_exit = 1
    }

    if (u ~ /ESQIFF_RECORDCHECKSUMBYTE/ || u ~ /TRANSFERXORCHECKSUMBYTE/ || u ~ /CMP\.L D0,D5/) {
        checksum_gate_count++
    }
    if (checksum_gate_count >= 3) {
        has_checksum_gate = 1
    }

    if (u ~ /DOS_OPENFILEWITHMODE|OPENFILEWITHMODE/) {
        open_fail_stage = advance_stage(open_fail_stage, 1)
    }
    if ((u ~ /DRAWTRANSFERERRORMESSAGEIFDIAGNOSTICS/ || u ~ /DRAWTRANSFERERRORMESSAGEI/) &&
        open_fail_stage >= 1) {
        open_fail_stage = advance_stage(open_fail_stage, 2)
    }
    if (open_fail_stage >= 2 &&
        (u ~ /MOVEQ(\.L)? #(-1|\$FF),D0/ || u ~ /MOVEQ #\$FF,D0/)) {
        has_open_fail = 1
    }

    if (u ~ /SAVEDREADMODEFLAGS/ && u ~ /ESQPARS2_READMODEFLAGS/) {
        transfer_setup_stage = advance_stage(transfer_setup_stage, 1)
    }
    if (u ~ /TRANSFERCRCERRORCOUNT/) {
        if (transfer_setup_stage >= 1) {
            transfer_setup_stage = advance_stage(transfer_setup_stage, 2)
        }
    }
    if (u ~ /TRANSFERBLOCKSEQUENCE/) {
        if (transfer_setup_stage >= 2) {
            transfer_setup_stage = advance_stage(transfer_setup_stage, 3)
        }
    }
    if (u ~ /TRANSFERBLOCKBUFFERPTR|MEMORY_ALLOCATEMEMORY|ALLOCATEMEMORY/) {
        if (transfer_setup_stage >= 3) {
            transfer_setup_stage = advance_stage(transfer_setup_stage, 4)
        }
    }
    if (u ~ /TRANSFERBUFFEREDBYTECOUNT|TRANSFERBUFFEREDBYTECOUN/ && transfer_setup_stage >= 4) {
        transfer_setup_done = 1
    }

    if (u ~ /#\$55|#85/) {
        sync_stage = advance_stage(sync_stage, 1)
    }
    if (u ~ /#\$AA|ADD\.L D0,D0/) {
        if (sync_stage >= 1) {
            sync_stage = advance_stage(sync_stage, 2)
        }
    }
    if (u ~ /#\$48|#72/) {
        if (sync_stage >= 2) {
            sync_stage = advance_stage(sync_stage, 3)
        }
    }
    if (u ~ /#\$3D|#61/) {
        if (sync_stage >= 2) {
            sync_stage = advance_stage(sync_stage, 4)
        }
    }
    if (u ~ /RECEIVETRANSFERBLOCKSTOFILE|RECEIVETRANSFERBLOCKSTOF/) {
        receive_call_count++
    }
    if (u ~ /(SEQ D0|SCC D1|NEG\.B D0|NEG\.B D1|MOVEQ\.L #\$0,D1|MOVEQ #0,D1)/) {
        has_receive_dispatch = 1
    }

    if (u ~ /#\$BB/) {
        delete_bb_count++
    }
    if (u ~ /NOT\.B D0/) {
        delete_not_count++
    }
    if (u ~ /#\$FF/ && u ~ /CMPI\.B|CMP\.L/) {
        delete_ff_count++
    }
    if ((delete_bb_count >= 2 || delete_not_count >= 2) &&
        (delete_ff_count >= 1 || delete_not_count >= 2) &&
        (u ~ /MOVEQ(\.L)? #\$4,D6/ || u ~ /MOVEQ(\.L)? #\$4,D0/ ||
         u ~ /MOVEQ #4,D6/ || u ~ /MOVEQ #4,D0/)) {
        has_delete_marker_flow = 1
    }

    if (u ~ /LVOCLOSE|_LVOCLOSE/) {
        close_call_count++
    }
    if (u ~ /MEMORY_DEALLOCATEMEMORY|MEMORY_DEALLOCAT/) {
        dealloc_call_count++
    }
    if (u ~ /DIAGTRANSFERSTATUSCLEARLINE210|DIAGTRANSFERSTATUSCLEARLINE240|DIAGTRANSFERSTATUSCL/) {
        clear_line_count++
    }
    if (clear_line_count >= 2) {
        has_teardown_flow = 1
    }

    if (u ~ /LVODELETEFILE|_LVODELETEFILE/) {
        delete_file_count++
        success_stage = advance_stage(success_stage, 1)
    }
    if (u ~ /FORCEUIREFRESHIFIDLE/ && success_stage >= 1) {
        success_stage = advance_stage(success_stage, 2)
    }
    if (u ~ /STRING_APPENDATNULL|APPENDATNULL/) {
        append_count++
    }
    if (append_count >= 3 && success_stage >= 2) {
        success_stage = advance_stage(success_stage, 3)
    }
    if (u ~ /LVOEXECUTE|_LVOEXECUTE/ && success_stage >= 3) {
        success_stage = advance_stage(success_stage, 4)
    }
    if (u ~ /RESETCTRLINPUTSTATEIFIDLE/ && success_stage >= 4) {
        success_stage = advance_stage(success_stage, 5)
    }
    if ((u ~ /GLOBAL_STR_STORED/ || u ~ /DC\.B 'STORED'/ || u ~ /__MERGED/) &&
        success_stage >= 5) {
        has_success_copy_flow = 1
    }

    if (u ~ /DRAWTRANSFERERRORMESSAGEIFDIAGNOSTICS|DRAWTRANSFERERRORMESSAGEI/) {
        error_draw_count++
    }
    if (error_draw_count >= 1 && delete_file_count >= 2) {
        has_error_cleanup = 1
    }

    if (u ~ /INTERACTIVETRANSFERARMED/) {
        finalize_stage = advance_stage(finalize_stage, 1)
    }
    if (u ~ /UPDATESTATUSMASKANDREFRESH|UPDATESTATUSMASKANDREFRE/) {
        if (finalize_stage >= 1) {
            finalize_stage = advance_stage(finalize_stage, 2)
        }
    }
    if (u ~ /QUERYDISKUSAGEPERCENTANDSETBUFFERSIZE|QUERYDISKUSAGEPERCENT/ && finalize_stage >= 2) {
        finalize_stage = advance_stage(finalize_stage, 3)
    }
    if (u ~ /QUERYVOLUMESOFTERRORCOUNT/ && finalize_stage >= 3) {
        finalize_stage = advance_stage(finalize_stage, 4)
    }
    if (u ~ /WDISP_SPRINTF|SPRINTF/ && finalize_stage >= 4) {
        finalize_stage = advance_stage(finalize_stage, 5)
    }
    if (u ~ /#\$5A|#90|PEA 90\.W|PEA \(\$5A\)\.W/) {
        if (finalize_stage >= 5) {
            finalize_stage = advance_stage(finalize_stage, 6)
        }
    }
    if (u ~ /DISPLIB_DISPLAYTEXTATPOSITION/ && finalize_stage >= 6) {
        finalize_display_calls++
    }
    if (finalize_stage >= 6 && finalize_display_calls >= 1) {
        has_finalize_diag = 1
    }
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_STATUS_BUSY_TOGGLE=" (status_update_count >= 2)
    print "HAS_CHECKSUM_SEEDS=" (checksum_seed_default && checksum_seed_crc32)
    print "HAS_FILENAME_LOOP_FLOW=" filename_loop_flow
    print "HAS_NGAD_GUARD=" has_ngad_guard
    print "HAS_TARGET_SETUP=" has_target_setup
    print "HAS_SIZE_GUARD_FLOW=" has_size_guard_flow
    print "HAS_OVERSIZE_EXIT=" has_oversize_exit
    print "HAS_CHECKSUM_GATE=" has_checksum_gate
    print "HAS_OPEN_FAIL=" has_open_fail
    print "HAS_TRANSFER_SETUP=" transfer_setup_done
    print "HAS_RECEIVE_DISPATCH=" (sync_stage >= 4 && receive_call_count >= 1 && has_receive_dispatch)
    print "HAS_DELETE_MARKER_FLOW=" has_delete_marker_flow
    print "HAS_TEARDOWN_FLOW=" has_teardown_flow
    print "HAS_SUCCESS_COPY_FLOW=" has_success_copy_flow
    print "HAS_ERROR_CLEANUP=" has_error_cleanup
    print "HAS_FINALIZE_DIAG=" has_finalize_diag
}
