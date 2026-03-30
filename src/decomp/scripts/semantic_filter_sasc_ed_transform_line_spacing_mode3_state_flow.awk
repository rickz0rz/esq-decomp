BEGIN {
    h_entry = 0
    h_mulu = 0
    h_copy_pad = 0
    h_leading_scan = 0
    h_trailing_scan = 0
    h_fill_leading = 0
    h_fill_trailing = 0
    h_right_gap_shift = 0
    h_right_scratch_refs = 0
    h_right_live_refs = 0
    h_left_gap_shift = 0
    h_left_scratch_refs = 0
    h_left_live_refs = 0
    h_left_suffix = 0
    h_left_tail = 0
    h_rts = 0

    asr_count = 0
    lead_space_window = 0
    trail_space_window = 0
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = norm($0)
    if (l == "") {
        next
    }

    if (lead_space_window > 0) {
        if (l ~ /CMP\.B / && (l ~ /-49\(A5,D7\.L\)/ || l ~ /\$44\(A7,D5\.L\)/)) {
            h_leading_scan = 1
        }
        lead_space_window--
    }

    if (trail_space_window > 0) {
        if (l ~ /CMP\.B / && (l ~ /-49\(A5,D1\.L\)/ || l ~ /\$44\(A7,D1\.L\)/)) {
            h_trailing_scan = 1
        }
        trail_space_window--
    }

    if (l ~ /^ED_TRANSFORMLINESPACING_MODE3:/ || l ~ /^ED_TRANSFORMLINESPACING_MODE3[A-Z0-9_]*:/) {
        h_entry = 1
    }

    if (l ~ /(JSR|BSR).*ESQIFF_JMPTBL_MATH_MULU32/) {
        h_mulu = 1
    }
    if (l ~ /(JSR|BSR).*ESQFUNC_JMPTBL_STRING_COPYPADNUL/) {
        h_copy_pad = 1
    }

    if (l ~ /MOVEQ(\.L)? #(\$?20|32),D0/) {
        lead_space_window = 3
    }
    if (l ~ /MOVEQ(\.L)? #(\$?20|32),D2/) {
        trail_space_window = 4
    }

    if (l ~ /MOVE\.B \(A0\),-90\(A5,D7\.L\)/ || l ~ /MOVE\.B \$17\(A7\),\$1C\(A7,D5\.L\)/) {
        h_fill_leading = 1
    }
    if (l ~ /MOVE\.B \(A0\),-90\(A5,D0\.L\)/ || l ~ /MOVE\.B \$17\(A7\),\$1C\(A7,D0\.L\)/) {
        h_fill_trailing = 1
    }

    if (l ~ /ASR\.L #(\$?1|1),D0/) {
        asr_count++
        if (asr_count == 1) {
            h_right_gap_shift = 1
        } else if (asr_count == 2) {
            h_left_gap_shift = 1
        }
    }

    if (asr_count == 1) {
        if (l ~ /ED_EDITBUFFERSCRATCH/) {
            h_right_scratch_refs++
        }
        if (l ~ /ED_EDITBUFFERLIVE/) {
            h_right_live_refs++
        }
    } else if (asr_count >= 2) {
        if (l ~ /ED_EDITBUFFERSCRATCH/) {
            h_left_scratch_refs++
        }
        if (l ~ /ED_EDITBUFFERLIVE/) {
            h_left_live_refs++
        }
        if (l ~ /ED_LINETRANSFORMSUFFIXSCRATCHBUF/ || l ~ /ED_LINETRANSFORMSUFFIXSCRATCHBUFFER/) {
            h_left_suffix = 1
        }
        if (l ~ /ED_LINETRANSFORMTAILSCRATCHBUFFE/ || l ~ /ED_LINETRANSFORMTAILSCRATCHBUFFER/) {
            h_left_tail = 1
        }
    }

    if (l == "RTS") {
        h_rts = 1
    }
}

END {
    print "HAS_ENTRY=" h_entry
    print "HAS_MULU32_CALL=" h_mulu
    print "HAS_COPY_PAD_NUL_CALL=" h_copy_pad
    print "HAS_LEADING_SPACE_SCAN=" h_leading_scan
    print "HAS_TRAILING_SPACE_SCAN=" h_trailing_scan
    print "HAS_LEADING_FILL_WRITE=" h_fill_leading
    print "HAS_TRAILING_FILL_WRITE=" h_fill_trailing
    print "HAS_RIGHT_GAP_SHIFT=" h_right_gap_shift
    print "HAS_RIGHT_SHIFT_SCRATCH_REFS=" (h_right_scratch_refs >= 2 ? 1 : 0)
    print "HAS_RIGHT_SHIFT_LIVE_REFS=" (h_right_live_refs >= 2 ? 1 : 0)
    print "HAS_LEFT_GAP_SHIFT=" h_left_gap_shift
    print "HAS_LEFT_SHIFT_SCRATCH_REFS=" (h_left_scratch_refs >= 1 ? 1 : 0)
    print "HAS_LEFT_SHIFT_LIVE_REFS=" (h_left_live_refs >= 1 ? 1 : 0)
    print "HAS_LEFT_SUFFIX_WRITE=" h_left_suffix
    print "HAS_LEFT_TAIL_WRITE=" h_left_tail
    print "HAS_RTS=" h_rts
}
