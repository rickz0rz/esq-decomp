BEGIN {
    has_entry = 0
    has_group_gate = 0
    has_primary_table = 0
    has_secondary_table = 0
    has_entry_ptr_load = 0
    has_slot_code_load = 0
    has_schedule_call = 0
    has_null_guard = 0
    has_empty_guard = 0
    has_clear_output = 0
    has_format_variant_load = 0
    has_format_minutes_call = 0
    has_hhmm_guard = 0
    has_digit_parse = 0
    has_slot_adjust = 0
    has_remainder_compare = 0
    has_round_increment = 0
    has_minutes_mod = 0
    has_wrap_guard = 0
    has_clock_table = 0
    has_copy_loop = 0
    has_tens_write = 0
    has_ones_write = 0
    has_restore = 0
    has_return = 0

    saw_null_test = 0
    saw_empty_test = 0
    saw_variant_div = 0
    saw_copy_store = 0
    prev1 = ""
    prev2 = ""
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
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TEXTDISP_FORMATENTRYTIME:/ || u ~ /^TEXTDISP_FORMATENTRYTIME[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (u ~ /TEXTDISP_ACTIVEGROUPID/ || u ~ /TST\.W TEXTDISP_ACTIVEGROUPID/ ||
        u ~ /MOVE\.W TEXTDISP_ACTIVEGROUPID\(A4\),D0/) {
        has_group_gate = 1
    }
    if (u ~ /TEXTDISP_PRIMARYTITLEPTRTABLE/) {
        has_primary_table = 1
    }
    if (u ~ /TEXTDISP_SECONDARYTITLEPTRTABLE/) {
        has_secondary_table = 1
    }
    if (n ~ /MOVEL56A2/ || n ~ /MOVEL38A3D0LA2/) {
        has_entry_ptr_load = 1
    }
    if (n ~ /MOVEB498A1D6/ || n ~ /MOVEB1F2A3D1/) {
        has_slot_code_load = 1
    }
    if (u ~ /COMPUTESCHEDULEOFFSETFORROW\(PC\)/ || u ~ /BSR\.W ESQDISP_COMPUTESCHEDULEOFFSETFOR/) {
        has_schedule_call = 1
    }

    if (u ~ /TST\.L -4\(A5\)/ || u ~ /MOVE\.L A2,D0/) {
        saw_null_test = 1
    }
    if (saw_null_test && (u ~ /^BEQ\./ || u ~ /BEQ\.W \.CLEAR_OUTPUT/ || u ~ /BEQ\.B ___TEXTDISP_FORMATENTRYTIME__/)) {
        has_null_guard = 1
        saw_null_test = 0
    }

    if (u ~ /TST\.B \(A0\)/ || u ~ /MOVE\.B \(A2\),D0/) {
        saw_empty_test = 1
    }
    if (saw_empty_test && (u ~ /^BEQ\./ || u ~ /BEQ\.W \.CLEAR_OUTPUT/ || u ~ /BNE\.B ___TEXTDISP_FORMATENTRYTIME__/)) {
        has_empty_guard = 1
        saw_empty_test = 0
    }
    if (u ~ /^\.CLEAR_OUTPUT:/ || u ~ /CLR\.B \(A3\)/ || u ~ /CLR\.B \(A5\)/) {
        has_clear_output = 1
    }

    if (u ~ /MOVE\.B CLOCK_FORMATVARIANTCODE/ || u ~ /MOVE\.B CLOCK_FORMATVARIANTCODE\(A4\),D0/) {
        has_format_variant_load = 1
    }
    if (u ~ /MATH_DIVS32\(PC\)/ || u ~ /BSR\.W MATH_DIVS32/) {
        saw_variant_div = 1
    }
    if (saw_variant_div &&
        (u ~ /CLEANUP_FORMATCLOCKFORMATENTRY\(PC\)/ || u ~ /BSR\.W CLEANUP_FORMATCLOCKFORMATENTRY/)) {
        has_format_minutes_call = 1
        saw_variant_div = 0
    }

    if ((u ~ /CMP\.B \(A0\),D0/ || u ~ /CMP\.B \(A2\),D0/) &&
        (prev1 ~ /MOVEQ(\.L)? #\$28,D0/ || prev1 ~ /MOVEQ(\.L)? #40,D0/)) {
        has_hhmm_guard = 1
    }
    if ((u ~ /CMP\.B 3\(A0\),D0/ || u ~ /CMP\.B \$3\(A2\),D0/) &&
        (prev1 ~ /MOVEQ(\.L)? #\$3A,D0/ || prev1 ~ /MOVEQ(\.L)? #58,D0/)) {
        has_hhmm_guard = 1
    }

    if (n ~ /MOVEB4A0D0/ || n ~ /ADDB4A2D0/) {
        has_digit_parse = 1
    }
    if (n ~ /MOVEB5A0D1/ || n ~ /ADDB5A2D0/) {
        has_digit_parse = 1
    }
    if ((u ~ /ADD\.L D0,D1/ &&
         (prev1 ~ /EXT\.L D1/ || prev1 ~ /MOVE\.L D5,D1/ || prev2 ~ /MOVE\.L D5,D1/)) ||
        (u ~ /ADD\.L D0,D6/ &&
         (prev1 ~ /LEA \$10\(A7\),A7/ || prev1 ~ /BSR\.W MATH_DIVS32/ || prev2 ~ /BSR\.W MATH_DIVS32/))) {
        has_slot_adjust = 1
    }
    if ((u ~ /CMP\.L D1,D0/ || u ~ /CMP\.L D1,D4/) &&
        (prev1 ~ /MOVE\.L 24\(A7\),D0/ || prev1 ~ /MOVE\.L D1,\$24\(A7\)/ || prev2 ~ /MOVE\.L D1,\$24\(A7\)/)) {
        has_remainder_compare = 1
    }
    if (u ~ /ADDQ\.[WL] #1,D5/ || u ~ /ADDQ\.L #\$1,D6/) {
        has_round_increment = 1
    }
    if (u ~ /DIVS #\$1E,D0/ || u ~ /MOVEQ\.L #\$1E,D1/ || u ~ /MOVEQ #30,D1/ || u ~ /MOVEQ\.L #30,D1/) {
        has_minutes_mod = 1
    }
    if ((u ~ /CMP\.W D0,D5/ || u ~ /CMP\.L D0,D6/) &&
        (prev1 ~ /MOVEQ(\.L)? #\$30,D0/ || prev1 ~ /MOVEQ(\.L)? #48,D0/)) {
        has_wrap_guard = 1
    }
    if (u ~ /GLOBAL_REF_STR_CLOCK_FORMAT/) {
        has_clock_table = 1
    }

    if (u ~ /MOVE\.B \(A1\)\+,\(A2\)\+/ || u ~ /MOVE\.B D0,\(A0\)/) {
        saw_copy_store = 1
    } else if (saw_copy_store && (u ~ /BNE\.S \.COPY_CLOCK_FORMAT/ || u ~ /BNE\.B ___TEXTDISP_FORMATENTRYTIME__/ || u ~ /TST\.B D0/)) {
        has_copy_loop = 1
        if (u !~ /TST\.B D0/) {
            saw_copy_store = 0
        }
    } else if (saw_copy_store && u !~ /^MOVE/ && u !~ /^BNE/ && u !~ /^TST/) {
        saw_copy_store = 0
    }

    if (u ~ /MOVE\.B D0,3\(A3\)/ || u ~ /MOVE\.B D0,\$FFFFFFFD\(A5\)/) {
        has_tens_write = 1
    }
    if (u ~ /MOVE\.B D1,4\(A3\)/ || u ~ /MOVE\.B D1,\$FFFFFFFE\(A5\)/) {
        has_ones_write = 1
    }
    if (u ~ /MOVEM\.L \(A7\)\+,D4-D7\/A2-A3/ || u ~ /MOVEM\.L \(A7\)\+,D4\/D5\/D6\/D7\/A2\/A3\/A5/) {
        has_restore = 1
    }
    if (u == "RTS") {
        has_return = 1
    }

    prev2 = prev1
    prev1 = u
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GROUP_GATE=" has_group_gate
    print "HAS_PRIMARY_TABLE=" has_primary_table
    print "HAS_SECONDARY_TABLE=" has_secondary_table
    print "HAS_ENTRY_PTR_LOAD=" has_entry_ptr_load
    print "HAS_SLOT_CODE_LOAD=" has_slot_code_load
    print "HAS_SCHEDULE_CALL=" has_schedule_call
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_EMPTY_GUARD=" has_empty_guard
    print "HAS_CLEAR_OUTPUT=" has_clear_output
    print "HAS_FORMAT_VARIANT_LOAD=" has_format_variant_load
    print "HAS_FORMAT_MINUTES_CALL=" has_format_minutes_call
    print "HAS_HHMM_GUARD=" has_hhmm_guard
    print "HAS_DIGIT_PARSE=" has_digit_parse
    print "HAS_SLOT_ADJUST=" has_slot_adjust
    print "HAS_REMAINDER_COMPARE=" has_remainder_compare
    print "HAS_ROUND_INCREMENT=" has_round_increment
    print "HAS_MINUTES_MOD=" has_minutes_mod
    print "HAS_WRAP_GUARD=" has_wrap_guard
    print "HAS_CLOCK_TABLE=" has_clock_table
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_TENS_WRITE=" has_tens_write
    print "HAS_ONES_WRITE=" has_ones_write
    print "HAS_RESTORE=" has_restore
    print "HAS_RETURN=" has_return
}
