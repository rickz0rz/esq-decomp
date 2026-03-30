BEGIN {
    has_entry=0
    has_guard_store=0
    has_init_runtime_entries=0
    has_loop_bound_10=0
    has_pattern_stride_76=0
    has_runtime_stride_154=0
    has_runtime_x_fetch=0
    has_div16=0
    has_remainder_nonzero_gate=0
    has_remainder_scale_17=0
    has_base_ddf_40=0
    has_store_ddf_start=0
    has_flag_8000=0
    has_const_1700=0
    has_const_ff00=0
    has_flag_0004=0
    has_span_round_mask=0
    has_index_nonzero_gate=0
    has_flag_8004_mask=0
    has_span_minus4=0
    has_span_minus2=0
    has_store_modulo=0
    has_store_ddf_modulo=0
    has_store_const24=0
    has_plane_118=0
    has_plane_134=0
    has_loop_increment=0
    has_rts=0

}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    u=trim($0)
    if (u=="") next
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TLIBA3_INITPATTERNTABLE:/ || u ~ /^TLIBA3_INITPATTERNTABL[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TLIBA1PATTERNTABLEINITGUARD/) has_guard_store=1
    if (n ~ /TLIBA3INITRUNTIMEENTRIES/) has_init_runtime_entries=1
    if ((u ~ /^MOVEQ #9,D0/ || u ~ /^MOVEQ\.L #\$A,D0/ || u ~ /^CMPI\.L #\$A,D7/) && !has_loop_bound_10) has_loop_bound_10=1
    if (u ~ /^MOVEQ #76,D1/ || u ~ /PEA \(\$4C\)\.W/ || u ~ /PEA 76\.W/ || u ~ /#\$4C/) {
        has_pattern_stride_76=1
    }
    if (u ~ /^MOVEQ #77,D1/ || u ~ /PEA \(\$9A\)\.W/ || u ~ /PEA 154\.W/ || u ~ /#\$9A/ || u ~ /^ADD\.L D1,D1$/) has_runtime_stride_154=1
    if (u ~ /MOVE\.W 6\(A2\),D0/ || u ~ /MOVE\.W \$6\(A3\),D6/ || n ~ /RUNTIMEX6/) has_runtime_x_fetch=1
    if (u ~ /^DIVS #16,D1/ || u ~ /PEA \(\$10\)\.W/ || u ~ /^MOVEQ #16,D1/ || u ~ /^MOVEQ\.L #\$10,D1/ || n ~ /_CXD33/) {
        has_div16=1
    }
    if (u ~ /^TST\.W D1/ || u ~ /^TST\.L D1/ || u ~ /^BEQ\.S \.IF_EQ_1810/ || u ~ /^BEQ\.B ___TLIBA3_INITPATTERNTABLE__13/) has_remainder_nonzero_gate=1
    if (u ~ /ASL\.L #4,D1/ || u ~ /ASL\.L #\$4,D0/ || u ~ /ADD\.L D2,D1/ || u ~ /ADD\.L D1,D0/) has_remainder_scale_17=1
    if (u ~ /^MOVEQ #40,D6/ || u ~ /^MOVEQ\.L #\$28,D0/ || u ~ /^MOVEQ\.L #\$28,D6/) has_base_ddf_40=1
    if (u ~ /MOVE\.W D0,10\(A2\)/ || u ~ /MOVE\.W D0,\$A\(A5\)/ || u ~ /MOVE\.W D1,\$A\(A5\)/) has_store_ddf_start=1
    if (u ~ /BTST #7,\(A2\)/ || u ~ /BTST #\$7,\(A3\)/ || u ~ /BTST #\$7,\(A0\)/ || u ~ /\$8000/) has_flag_8000=1
    if (u ~ /ADDI\.W #\$1700,D3/ || u ~ /#\$1700/ || n ~ /1700/) has_const_1700=1
    if (u ~ /ADDI\.L #\$FF00,D1/ || u ~ /#\$FF00/ || n ~ /FF00/) has_const_ff00=1
    if (u ~ /BTST #2,1\(A2\)/ || u ~ /BTST #\$2,\$1\(A3\)/ || u ~ /ANDI\.L #\$4/ || n ~ /0004/) has_flag_0004=1
    if (u ~ /ANDI\.L #\$FFFE,D0/ || u ~ /ANDI\.L #\$FFFE,D1/ || n ~ /FFFE/) has_span_round_mask=1
    if (u ~ /^TST\.L D7/ || u ~ /^CMP\.L D1,D7/ || u ~ /^BNE\.S \.IF_NE_1818/ || u ~ /^BNE\.B ___TLIBA3_INITPATTERNTABLE__21/) has_index_nonzero_gate=1
    if (u ~ /MOVE\.L #\$8004,D1/ || u ~ /CMPI\.L #\$8004,D0/ || n ~ /8004/) has_flag_8004_mask=1
    if (u ~ /SUBQ\.W #4,-22\(A5\)/ || u ~ /SUBQ\.L #\$4,D0/ || u ~ /SUBQ\.L #\$4,\$24\(A7\)/) has_span_minus4=1
    if (u ~ /SUBQ\.W #2,-22\(A5\)/ || u ~ /SUBQ\.L #\$2,D0/ || u ~ /SUBQ\.L #\$2,\$24\(A7\)/) has_span_minus2=1
    if (u ~ /MOVE\.W \(A3\),26\(A2\)/ || u ~ /MOVE\.W D0,\$1A\(A5\)/ || u ~ /MOVE\.W D1,\$1A\(A5\)/) has_store_modulo=1
    if (u ~ /MOVE\.W -20\(A5\),D2/ || u ~ /MOVE\.W D2,30\(A2\)/ || u ~ /MOVE\.W D1,\$1E\(A5\)/ || n ~ /PAIR7VALUE/) has_store_ddf_modulo=1
    if (u ~ /MOVE\.W #\$24,34\(A2\)/ || u ~ /MOVE\.W #\$24,\$22\(A5\)/) has_store_const24=1
    if (u ~ /MOVE\.L 118\(A3\),D2/ || u ~ /MOVE\.L \$76\(A3\),D2/ || u ~ /MOVE\.L \$76\(A3\),D0/ || n ~ /PLANEPTR118/) has_plane_118=1
    if (u ~ /MOVE\.L 134\(A3\),D2/ || u ~ /MOVE\.L 134\(A1\),D0/ || u ~ /MOVE\.L \$86\(A3\),D2/ || u ~ /MOVE\.L \$86\(A3\),D0/ || n ~ /PLANEPTR134/) has_plane_134=1
    if (u ~ /^ADDQ\.L #1,D7/ || u ~ /^ADDQ\.L #\$1,D7/) has_loop_increment=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_GUARD_STORE="has_guard_store
    print "HAS_INIT_RUNTIME_ENTRIES="has_init_runtime_entries
    print "HAS_LOOP_BOUND_10="has_loop_bound_10
    print "HAS_PATTERN_STRIDE_76="has_pattern_stride_76
    print "HAS_RUNTIME_STRIDE_154="has_runtime_stride_154
    print "HAS_RUNTIME_X_FETCH="has_runtime_x_fetch
    print "HAS_DIV16="has_div16
    print "HAS_REMAINDER_NONZERO_GATE="has_remainder_nonzero_gate
    print "HAS_REMAINDER_SCALE_17="has_remainder_scale_17
    print "HAS_BASE_DDF_40="has_base_ddf_40
    print "HAS_STORE_DDF_START="has_store_ddf_start
    print "HAS_FLAG_8000="has_flag_8000
    print "HAS_CONST_1700="has_const_1700
    print "HAS_CONST_FF00="has_const_ff00
    print "HAS_FLAG_0004="has_flag_0004
    print "HAS_SPAN_ROUND_MASK="has_span_round_mask
    print "HAS_INDEX_NONZERO_GATE="has_index_nonzero_gate
    print "HAS_FLAG_8004_MASK="has_flag_8004_mask
    print "HAS_SPAN_MINUS4="has_span_minus4
    print "HAS_SPAN_MINUS2="has_span_minus2
    print "HAS_STORE_MODULO="has_store_modulo
    print "HAS_STORE_DDF_MODULO="has_store_ddf_modulo
    print "HAS_STORE_CONST24="has_store_const24
    print "HAS_PLANE_118="has_plane_118
    print "HAS_PLANE_134="has_plane_134
    print "HAS_LOOP_INCREMENT="has_loop_increment
    print "HAS_RTS="has_rts
}
