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
    uline = toupper(line)

    if (uline ~ /^STREAM_BUFFEREDGETC:/) {
        mark("ENTRY")
    }

    if (uline ~ /MODEFLAG_TEXTTRANSLATE_BIT/ || uline ~ /^BTST #\$7,\(A2\)$/ || uline ~ /^BTST #\$7,.*MODEFLAGS/) {
        mark("TEXT_MODE_FLAG")
    }

    if (uline ~ /OPENMASK_FLUSHREJECT/ || uline ~ /^MOVEQ(\.L)? #\$30,D0$/ || uline ~ /^AND\.L .*#?\$?30/) {
        mark("FLUSH_REJECT_MASK")
    }

    if (uline ~ /^CLR\.L \$8\(A5\)$/ || uline ~ /^CLR\.L .*READREMAINING/) {
        mark("CLEAR_READ_REMAINING")
    }

    if ((uline ~ /^MOVEQ(\.L)? #\$FF,D0$/ || uline ~ /^MOVEQ #-1,D0$/) && ("FLUSH_REJECT_MASK" in seen) && !("FLUSH_REJECT_EOF_RETURN" in seen)) {
        mark("FLUSH_REJECT_EOF_RETURN")
    }

    if (uline ~ /PREREADFLUSHGATEHI/ || uline ~ /^BTST #\$7,\(A3\)$/ || uline ~ /^BTST #\$7,.*STATEFLAGS/) {
        mark("PREREAD_GATE_HI")
    }

    if (uline ~ /PREREADFLUSHGATELO/ || uline ~ /^BTST #\$6,\(A3\)$/ || uline ~ /^BTST #\$6,.*STATEFLAGS/) {
        mark("PREREAD_GATE_LO")
    }

    if (uline ~ /STREAM_BUFFEREDPUTCORFLUSH/) {
        mark("PREFLUSH_CALL")
    }

    if (uline ~ /TST\.L .*BUFFERCAPACITY/ || uline ~ /^TST\.L \$14\(A5\)$/) {
        mark("BUFFER_CAPACITY_TEST")
    }

    if (uline ~ /UNBUFFERED_BIT/ || uline ~ /^BTST #\$2,\(A3\)$/ || uline ~ /^BTST #\$2,.*STATEFLAGS/) {
        mark("UNBUFFERED_FLAG")
    }

    if (uline ~ /LEA .*INLINEBYTE/ || uline ~ /^LEA \$20\(A5\),A0$/) {
        mark("SET_INLINE_BUFFER")
    }

    if (uline ~ /BUFFER_ENSUREALLOCATED/) {
        mark("ENSURE_ALLOC_CALL")
    }

    if ((uline ~ /IOERROR_BIT/ || uline ~ /^BSET #\$5,\(A3\)$/) && !("ENSURE_ALLOC_FAIL_IO" in seen)) {
        mark("ENSURE_ALLOC_FAIL_IO")
    }

    if (uline ~ /^TST\.[BL] D7$/ || uline ~ /^TST\.L D7$/) {
        mark("TEXTMODE_CONSUME_GUARD")
    }

    if (uline ~ /^ADDQ\.L #\$2,\$8\(A5\)$/ || uline ~ /^ADDQ\.L #2,.*READREMAINING/) {
        mark("TEXT_COUNT_PLUS2")
    }

    if (uline ~ /^ADDQ\.L #\$1,\$4\(A5\)$/ || uline ~ /^MOVE\.L A1,.*BUFFERCURSOR/ || uline ~ /^LEA 1\(A0\),A1$/) {
        mark("ADVANCE_CURSOR")
    }

    if (uline ~ /#\$1A/ || uline ~ /#26([^0-9]|$)/ || uline ~ /CTRL_Z/) {
        mark("CTRL_Z_CHECK")
    }

    if ((uline ~ /EOFORSHORT_BIT/ || uline ~ /^BSET #\$4,\(A3\)$/) && !("CTRL_Z_EOF_SET" in seen)) {
        mark("CTRL_Z_EOF_SET")
    }

    if (uline ~ /#\$D([^0-9A-F]|$)/ || uline ~ /#13([^0-9]|$)/ || uline ~ /CHAR_CR/) {
        mark("CR_CHECK")
    }

    if (uline ~ /^SUBQ\.L #\$1,\$8\(A5\)$/ || uline ~ /^SUBQ\.L #1,.*READREMAINING/) {
        mark("CR_OR_FINAL_DEC")
    }

    if ((uline ~ /^ADDQ\.L #\$1,\$4\(A5\)$/ || uline ~ /^MOVE\.L A1,.*BUFFERCURSOR/ || uline ~ /^LEA 1\(A0\),A1$/) &&
        ("CR_OR_FINAL_DEC" in seen) && !("CR_SECOND_CHAR_FETCH" in seen)) {
        mark("CR_SECOND_CHAR_FETCH")
    }

    if (uline ~ /BSR\.W STREAM_BUFFEREDGETC/ || uline ~ /JSR STREAM_BUFFEREDGETC/ || uline ~ /BRAW STREAM_BUFFEREDGETC/) {
        mark("RECURSE")
    }

    if (uline ~ /^BTST #\$1,\(A3\)$/ || uline ~ /WRITEPENDING_BIT/) {
        mark("WRITE_PENDING_GATE")
    }

    if (uline ~ /^BSET #\$0,\(A3\)$/ || uline ~ /READREFILLISSUED_BIT/) {
        mark("READ_REFILL_SET")
    }

    if (uline ~ /DOS_READBYINDEX/) {
        mark("DOS_READ_CALL")
    }

    if ((uline ~ /IOERROR_BIT/ || uline ~ /^BSET #\$5,\(A3\)$/) && !("READ_IO_ERROR_SET" in seen) && ("DOS_READ_CALL" in seen)) {
        mark("READ_IO_ERROR_SET")
    }

    if ((uline ~ /EOFORSHORT_BIT/ || uline ~ /^BSET #\$4,\(A3\)$/) && !("READ_EOF_SET" in seen) && ("DOS_READ_CALL" in seen)) {
        mark("READ_EOF_SET")
    }

    if (uline == "NEG.L D0") {
        mark("NEGATE_TEXT_READ_COUNT")
    }

    if (uline ~ /^MOVE\.L D0,\$8\(A5\)$/ || uline ~ /^MOVE\.L D5,.*READREMAINING/ || uline ~ /^MOVE\.L D0,.*READREMAINING/) {
        mark("STORE_READ_REMAINING")
    }

    if ((uline ~ /^MOVE\.L D0,\$8\(A5\)$/ || uline ~ /^MOVE\.L D0,.*READREMAINING/) &&
        ("NEGATE_TEXT_READ_COUNT" in seen) && !("STORE_NEGATED_TEXT_COUNT" in seen)) {
        mark("STORE_NEGATED_TEXT_COUNT")
    }

    if ((uline ~ /^MOVE\.L D5,.*READREMAINING/ || uline ~ /^MOVE\.L D6,.*READREMAINING/ || uline ~ /^MOVE\.L D0,\$8\(A5\)$/) &&
        !("NEGATE_TEXT_READ_COUNT" in seen) && ("DOS_READ_CALL" in seen) && !("STORE_POSITIVE_READ_COUNT" in seen)) {
        mark("STORE_POSITIVE_READ_COUNT")
    }

    if (uline ~ /^MOVE\.L \$10\(A5\),\$4\(A5\)$/ || uline ~ /^MOVE\.L A0,.*BUFFERCURSOR/) {
        mark("RESET_CURSOR_BASE")
    }

    if (uline ~ /OPENMASK_READREJECT/ || uline ~ /^MOVEQ(\.L)? #\$32,D0$/) {
        mark("READ_REJECT_MASK")
    }

    if ((uline ~ /^MOVEQ(\.L)? #\$FF,D0$/ || uline ~ /^MOVEQ #-1,D0$/) && ("READ_REJECT_MASK" in seen)) {
        mark("READ_REJECT_EOF_VALUE")
    }

    if ((uline ~ /^MOVEQ(\.L)? #\$FF,D0$/ || uline ~ /^MOVEQ #-1,D0$/) &&
        ("READ_REJECT_MASK" in seen) && !("READ_REJECT_SET_NEG1" in seen)) {
        mark("READ_REJECT_SET_NEG1")
    }

    if ((uline ~ /^MOVEQ(\.L)? #\$0,D0$/ || uline ~ /^MOVEQ #0,D0$/) &&
        ("READ_REJECT_MASK" in seen) && !("READ_REJECT_SET_ZERO" in seen)) {
        mark("READ_REJECT_SET_ZERO")
    }

    if ((uline ~ /^MOVE\.L D0,\$8\(A5\)$/ || uline ~ /^MOVE\.L D0,.*READREMAINING/) &&
        ("READ_REJECT_SET_NEG1" in seen) && !("READ_REJECT_STORE_NEG1" in seen)) {
        mark("READ_REJECT_STORE_NEG1")
    }

    if ((uline ~ /^MOVE\.L D0,\$8\(A5\)$/ || uline ~ /^MOVE\.L D0,.*READREMAINING/) &&
        ("READ_REJECT_SET_ZERO" in seen) && !("READ_REJECT_STORE_ZERO" in seen)) {
        mark("READ_REJECT_STORE_ZERO")
    }

    if (uline ~ /BSR\.W STREAM_BUFFEREDGETC/ || uline ~ /JSR STREAM_BUFFEREDGETC/ || uline ~ /BRAW STREAM_BUFFEREDGETC/) {
        if ("READ_REJECT_MASK" in seen) {
            mark("FINAL_RECURSE_AFTER_DEC")
        }
    }

    if (uline == "RTS") {
        mark("RTS")
    }
}

END {
    order[1] = "ENTRY"
    order[2] = "TEXT_MODE_FLAG"
    order[3] = "FLUSH_REJECT_MASK"
    order[4] = "CLEAR_READ_REMAINING"
    order[5] = "FLUSH_REJECT_EOF_RETURN"
    order[6] = "PREREAD_GATE_HI"
    order[7] = "PREREAD_GATE_LO"
    order[8] = "PREFLUSH_CALL"
    order[9] = "BUFFER_CAPACITY_TEST"
    order[10] = "UNBUFFERED_FLAG"
    order[11] = "SET_INLINE_BUFFER"
    order[12] = "ENSURE_ALLOC_CALL"
    order[13] = "ENSURE_ALLOC_FAIL_IO"
    order[14] = "TEXTMODE_CONSUME_GUARD"
    order[15] = "TEXT_COUNT_PLUS2"
    order[16] = "ADVANCE_CURSOR"
    order[17] = "CTRL_Z_CHECK"
    order[18] = "CTRL_Z_EOF_SET"
    order[19] = "CR_CHECK"
    order[20] = "CR_OR_FINAL_DEC"
    order[21] = "CR_SECOND_CHAR_FETCH"
    order[22] = "RECURSE"
    order[23] = "WRITE_PENDING_GATE"
    order[24] = "READ_REFILL_SET"
    order[25] = "DOS_READ_CALL"
    order[26] = "READ_IO_ERROR_SET"
    order[27] = "READ_EOF_SET"
    order[28] = "NEGATE_TEXT_READ_COUNT"
    order[29] = "STORE_NEGATED_TEXT_COUNT"
    order[30] = "STORE_POSITIVE_READ_COUNT"
    order[31] = "STORE_READ_REMAINING"
    order[32] = "RESET_CURSOR_BASE"
    order[33] = "READ_REJECT_MASK"
    order[34] = "READ_REJECT_SET_NEG1"
    order[35] = "READ_REJECT_STORE_NEG1"
    order[36] = "READ_REJECT_SET_ZERO"
    order[37] = "READ_REJECT_STORE_ZERO"
    order[38] = "READ_REJECT_EOF_VALUE"
    order[39] = "FINAL_RECURSE_AFTER_DEC"
    order[40] = "RTS"

    for (i = 1; i <= 40; i++) {
        tag = order[i]
        if (seen[tag]) {
            print i ":" tag
        }
    }
}
