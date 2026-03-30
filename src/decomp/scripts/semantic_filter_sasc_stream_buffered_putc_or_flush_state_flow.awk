BEGIN {
    btst2_count = 0
    bset1_count = 0
    bset5_count = 0
    recurse_count = 0
    seek_count = 0
    write_reject_armed = 0
    write_with_callback_armed = 0
    write_single_armed = 0
    ctrlz_loop_armed = 0
    flush_reject_armed = 0
    split("ENTRY WRITE_REJECT_GATE ALLOC_UNBUFFERED_GUARD ENSURE_ALLOCATED ALLOC_FAIL_IO_ERROR ALLOC_PENDING_SET NEGATIVE_CAPACITY_PATH ALLOC_STORE_OR_STAGE_BYTE ALLOC_RETRY_RECURSE DIRECT_UNBUFFERED_GATE DIRECT_FLUSH_RETURNS_ZERO DIRECT_LF_MOVEP_WRITE DIRECT_SINGLE_BYTE_WRITE DIRECT_PATH_FORCES_FLUSH BUFFERED_PENDING_SET TEXTMODE_BUFFER_EXPAND TEXTMODE_INSERT_CR CR_FLUSH_RECURSE PENDING_COUNT_COMPUTE PREWRITE_SCAN_GATE SEEK_TO_END SEEK_BACKWARD_SCAN READ_BACKWARD_SCAN_BYTE CHECK_DOS_IO_ERROR CHECK_CTRL_Z CTRLZ_SCAN_LOOP BUFFER_FLUSH_WRITE WRITE_FAIL_IO_ERROR SHORT_WRITE_FLAG RESET_NEGATIVE_COUNT RESET_UNBUFFERED_GATE RESET_BUFFER_CURSOR FINAL_STORE_BYTE FINAL_RETRY_RECURSE FLUSH_REJECT_GATE RETURN_ZERO_ON_FLUSH RETURN_INPUT_BYTE RTS", order, " ")
    order_count = 38
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    seen[tag] = 1
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^STREAM_BUFFEREDPUTCORFLUSH:/) {
        mark("ENTRY")
    }

    if (n ~ /OPENMASKWRITEREJECT/ || u ~ /^MOVEQ(\.L)? #\$31,D0$/ || u ~ /^MOVEQ #49,D0$/) {
        write_reject_armed = 1
    }

    if (((n ~ /OPENMASKWRITEREJECT/ && n ~ /ANDL/) ||
         (write_reject_armed && u ~ /^AND\.L /)) &&
        !("WRITE_REJECT_GATE" in seen)) {
        mark("WRITE_REJECT_GATE")
        write_reject_armed = 0
    }

    if ((n ~ /OPENFLAGSLOWBIT2UNBUFFERED/ || (u ~ /^BTST / && u ~ /#\$?2/ && u ~ /\(A3\)$/))) {
        btst2_count += 1
        if (btst2_count == 1) {
            mark("ALLOC_UNBUFFERED_GUARD")
        } else if (btst2_count == 2) {
            mark("DIRECT_UNBUFFERED_GATE")
        } else if (btst2_count == 3) {
            mark("RESET_UNBUFFERED_GATE")
        }
    }

    if (n ~ /BUFFERENSUREALLOCATED/ && (u ~ /^BSR/ || u ~ /^JSR /)) {
        mark("ENSURE_ALLOCATED")
    }

    if ((n ~ /OPENFLAGSLOWBIT5IOERROR/ || (u ~ /^BSET / && u ~ /#\$?5/ && u ~ /\(A3\)$/))) {
        bset5_count += 1
        if (bset5_count == 1) {
            mark("ALLOC_FAIL_IO_ERROR")
        } else if (bset5_count == 2) {
            mark("WRITE_FAIL_IO_ERROR")
        }
    }

    if ((n ~ /OPENFLAGSLOWBIT1WRITEPENDING/ || (u ~ /^BSET / && u ~ /#\$?1/ && u ~ /\(A3\)$/))) {
        bset1_count += 1
        if (bset1_count == 1) {
            mark("ALLOC_PENDING_SET")
        } else if (bset1_count == 2) {
            mark("BUFFERED_PENDING_SET")
        }
    }

    if ((u ~ /^NEG\.L D1$/ || u ~ /^NEG\.L D2$/) && !("NEGATIVE_CAPACITY_PATH" in seen)) {
        mark("NEGATIVE_CAPACITY_PATH")
    }

    if ((n ~ /BSRWSTREAMBUFFEREDPUTCORFLUSH/ || n ~ /JSRSTREAMBUFFEREDPUTCORFLUSH/)) {
        recurse_count += 1
        if (recurse_count == 1) {
            mark("ALLOC_RETRY_RECURSE")
        } else if (recurse_count == 2) {
            mark("CR_FLUSH_RECURSE")
        } else if (recurse_count == 3) {
            mark("FINAL_RETRY_RECURSE")
        }
    }

    if ((u ~ /^MOVE\.B D0,\(A0\)$/ || u ~ /^MOVE\.B D0,\$1F\(A7\)$/) &&
        !("ALLOC_STORE_OR_STAGE_BYTE" in seen)) {
        mark("ALLOC_STORE_OR_STAGE_BYTE")
    }

    if ((u ~ /^MOVEQ(\.L)? #\$0,D0$/ || u ~ /^MOVEQ #0,D0$/) &&
        ("DIRECT_UNBUFFERED_GATE" in seen) &&
        !("DIRECT_FLUSH_RETURNS_ZERO" in seen)) {
        mark("DIRECT_FLUSH_RETURNS_ZERO")
    }

    if (n ~ /DOSMOVEPWORDREADCALLBACK/) {
        write_with_callback_armed = 1
    }

    if ((u ~ /^PEA -1\(A5\)$/ || u ~ /^PEA \$[0-9A-F]+\((A7|A[0-7])\)$/) &&
        !write_with_callback_armed) {
        write_single_armed = 1
    }

    if (n ~ /DOSWRITEBYINDEX/ && (u ~ /^BSR/ || u ~ /^JSR /)) {
        if (write_with_callback_armed && !("DIRECT_LF_MOVEP_WRITE" in seen)) {
            mark("DIRECT_LF_MOVEP_WRITE")
            write_with_callback_armed = 0
            write_single_armed = 0
        } else if (write_single_armed && !("DIRECT_SINGLE_BYTE_WRITE" in seen)) {
            mark("DIRECT_SINGLE_BYTE_WRITE")
            write_single_armed = 0
        } else {
            mark("BUFFER_FLUSH_WRITE")
        }
    }

    if ((u ~ /^MOVEQ(\.L)? #\$FF,D7$/ || u ~ /^MOVEQ #-1,D7$/) &&
        !("DIRECT_PATH_FORCES_FLUSH" in seen)) {
        mark("DIRECT_PATH_FORCES_FLUSH")
    }

    if ((u ~ /^ADDQ\.L #\$2,\$C\(A5\)$/ || n ~ /ADDQL2STRUCTPREALLOCHANDLENODEWRITEREMAINING/) &&
        !("TEXTMODE_BUFFER_EXPAND" in seen)) {
        mark("TEXTMODE_BUFFER_EXPAND")
    }

    if ((u ~ /^MOVE\.B #\$D,\(A0\)$/ || u ~ /^MOVE\.B #\$0D,\(A0\)$/) &&
        !("TEXTMODE_INSERT_CR" in seen)) {
        mark("TEXTMODE_INSERT_CR")
    }

    if ((u ~ /^SUB\.L \$10\(A5\),D0$/ ||
         u ~ /^MOVE\.L D0,\$24\(A7\)$/ ||
         n ~ /SUBLSTRUCTPREALLOCHANDLENODEBUFFERBASE/ ||
         n ~ /MOVELD016A5/) &&
        !("PENDING_COUNT_COMPUTE" in seen)) {
        mark("PENDING_COUNT_COMPUTE")
    }

    if ((n ~ /MODEFLAGPREWRITESCAN/ || (u ~ /^BTST / && u ~ /#\$?6/ && u ~ /\(A2\)$/)) &&
        !("PREWRITE_SCAN_GATE" in seen)) {
        mark("PREWRITE_SCAN_GATE")
    }

    if (n ~ /DOSSEEKBYINDEX/ && (u ~ /^BSR/ || u ~ /^JSR /)) {
        seek_count += 1
        if (seek_count == 1) {
            mark("SEEK_TO_END")
        } else if (seek_count == 2) {
            mark("SEEK_BACKWARD_SCAN")
            ctrlz_loop_armed = 1
        }
    }

    if (n ~ /DOSREADBYINDEX/ && ctrlz_loop_armed) {
        mark("READ_BACKWARD_SCAN_BYTE")
    }

    if ((n ~ /GLOBALDOSIOERR/ || u ~ /^TST\.L GLOBAL_DOSIOERR/) && ctrlz_loop_armed) {
        mark("CHECK_DOS_IO_ERROR")
    }

    if ((u ~ /#\$1A/ || u ~ /#26([^0-9]|$)/) && ctrlz_loop_armed) {
        mark("CHECK_CTRL_Z")
    }

    if (ctrlz_loop_armed && (u ~ /^BRA\.B / || u ~ /^BEQ\.S / || u ~ /^BEQ\.B /)) {
        mark("CTRLZ_SCAN_LOOP")
        ctrlz_loop_armed = 0
    }

    if ((n ~ /OPENFLAGSLOWBIT4EOFORSHORT/ || (u ~ /^BSET / && u ~ /#\$?4/ && u ~ /\(A3\)$/)) &&
        !("SHORT_WRITE_FLAG" in seen)) {
        mark("SHORT_WRITE_FLAG")
    }

    if ((u ~ /^MOVE\.L D2,\$C\(A5\)$/ || n ~ /WRITEREMAINING/ && u ~ /^MOVE\.L D2,/) &&
        !("RESET_NEGATIVE_COUNT" in seen)) {
        mark("RESET_NEGATIVE_COUNT")
    }

    if ((n ~ /BUFFERBASE/ && n ~ /BUFFERCURSOR/) ||
        u ~ /^MOVE\.L \$10\(A5\),\$4\(A5\)$/ ||
        u ~ /^MOVE\.L A0,STRUCT_PREALLOCHANDLENODE__BUFFERCURSOR/) {
        mark("RESET_BUFFER_CURSOR")
    }

    if ((u ~ /^MOVE\.B D0,\(A0\)$/ || u ~ /^MOVE\.L D7,D0$/) &&
        ("RESET_BUFFER_CURSOR" in seen) &&
        !("FINAL_STORE_BYTE" in seen) &&
        recurse_count >= 2) {
        mark("FINAL_STORE_BYTE")
    }

    if (n ~ /OPENMASKFLUSHREJECT/ || u ~ /^MOVEQ(\.L)? #\$30,D0$/ || u ~ /^MOVEQ #48,D0$/) {
        flush_reject_armed = 1
    }

    if (((n ~ /OPENMASKFLUSHREJECT/ && n ~ /ANDL/) ||
         (flush_reject_armed && u ~ /^AND\.L /)) &&
        !("FLUSH_REJECT_GATE" in seen)) {
        mark("FLUSH_REJECT_GATE")
        flush_reject_armed = 1
    }

    if (flush_reject_armed && (u ~ /^MOVEQ(\.L)? #\$0,D0$/ || u ~ /^MOVEQ #0,D0$/) &&
        !("RETURN_ZERO_ON_FLUSH" in seen)) {
        mark("RETURN_ZERO_ON_FLUSH")
    }

    if ((u ~ /^MOVE\.L D4,D0$/ || u ~ /^MOVE\.L D6,D0$/ || u ~ /^MOVE\.B D0,D1$/) &&
        ("FLUSH_REJECT_GATE" in seen) &&
        !("RETURN_INPUT_BYTE" in seen)) {
        mark("RETURN_INPUT_BYTE")
    }

    if (u == "RTS") {
        mark("RTS")
    }
}

END {
    step = 0
    for (i = 1; i <= order_count; i++) {
        tag = order[i]
        if (seen[tag]) {
            step += 1
            print step ":" tag
        }
    }
}
