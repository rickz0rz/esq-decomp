function toupper_line(s, out) {
    out = toupper(s)
    sub(/;.*/, "", out)
    gsub(/^[ \t]+|[ \t]+$/, "", out)
    gsub(/[ \t]+/, " ", out)
    return out
}

{
    line = toupper_line($0)
    if (line == "") {
        next
    }

    if (line ~ /^LOCAVAIL_RESETFILTERSTATESTRUCT:/ || line ~ /^LOCAVAIL_RESETFILTERSTATESTRUCT[A-Z0-9_]*:/) has_entry = 1
    if (line == "CLR.B (A3)" || line ~ /^MOVE\.[BWL] D[0-7],\(A3\)$/) has_mode_zero = 1
    if (line == "CLR.L 2(A3)" || line == "CLR.L $2(A3)" || line ~ /^MOVE\.[BWL] D[0-7],(\$2|2)\(A3\)$/) has_count_zero = 1
    if (line == "CLR.L 16(A3)" || line == "CLR.L $10(A3)" || line ~ /^MOVE\.[BWL] [DA][0-7],(\$10|16)\(A3\)$/) has_shared_ref_zero = 1
    if (line == "CLR.L 20(A3)" || line == "CLR.L $14(A3)" || line ~ /^MOVE\.[BWL] [DA][0-7],(\$14|20)\(A3\)$/) has_node_table_zero = 1
    if (line == "MOVE.B #'F',6(A3)" || line == "MOVE.B #70,6(A3)" || line == "MOVE.B #$46,$6(A3)") has_mode_char = 1
    if (line == "MOVE.L D0,8(A3)" || line == "MOVE.L D0,$8(A3)" || line == "MOVEQ #-1,D0" || line == "MOVEQ.L #$FF,D0") has_field8_seed = 1
    if (line == "MOVE.L D0,12(A3)" || line == "MOVE.L D0,$C(A3)") has_field12_seed = 1
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MODE_ZERO=" has_mode_zero
    print "HAS_COUNT_ZERO=" has_count_zero
    print "HAS_SHARED_REF_ZERO=" has_shared_ref_zero
    print "HAS_NODE_TABLE_ZERO=" has_node_table_zero
    print "HAS_MODE_CHAR=" has_mode_char
    print "HAS_FIELD8_SEED=" has_field8_seed
    print "HAS_FIELD12_SEED=" has_field12_seed
    print "HAS_RETURN=" has_return
}
