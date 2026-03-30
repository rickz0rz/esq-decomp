BEGIN {
    has_entry=0
    has_guard_store=0
    has_init_runtime_entries=0
    has_loop_10=0
    has_pattern_table=0
    has_runtime_table=0
    has_reg_8e=0
    has_reg_108=0
    has_reg_f2=0
    has_merged_reg_seed=0
    has_x_offset_load=0
    has_width_offset_load=0
    has_const_16=0
    has_div_helper=0
    has_shift4=0
    has_add_scaled=0
    has_const_76=0
    has_const_77=0
    has_const_154=0
    has_double_77=0
    has_math_mulu32=0
    has_flag_8000=0
    has_flag_8004=0
    has_flag_0004=0
    has_span_round=0
    has_mode_adjust_gate=0
    has_span_adjust=0
    has_const_1700=0
    has_const_ff00=0
    has_const_24=0
    has_plane_118=0
    has_plane_122=0
    has_plane_126=0
    has_plane_130=0
    has_plane_134=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TLIBA3_INITPATTERNTABLE:/ || u ~ /^TLIBA3_INITPATTERNTABL[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TLIBA1PATTERNTABLEINITGUARD/) has_guard_store=1
    if (n ~ /TLIBA3INITRUNTIMEENTRIES/) has_init_runtime_entries=1
    if (u ~ /#9([^0-9]|$)/ || u ~ /#10([^0-9]|$)/ || u ~ /#\$A/) has_loop_10=1
    if (n ~ /TLIBA3VMARRAYPATTERNTABLE/) has_pattern_table=1
    if (n ~ /TLIBA3VMARRAYRUNTIMETABLE/) has_runtime_table=1
    if (u ~ /#\$8E/ || u ~ /#142([^0-9]|$)/) has_reg_8e=1
    if (u ~ /#\$108/ || u ~ /#264([^0-9]|$)/) has_reg_108=1
    if (u ~ /#\$F2/ || u ~ /#242([^0-9]|$)/) has_reg_f2=1
    if (n ~ /MERGED/) has_merged_reg_seed=1
    if (u ~ /\$?6\(A[23]\)/) has_x_offset_load=1
    if (u ~ /\$?2\(A[23]\)/) has_width_offset_load=1
    if (u ~ /#16([^0-9]|$)/ || u ~ /#\$10/) has_const_16=1
    if (n ~ /MATHDIVS32/ || n ~ /DIVS16D1/ || n ~ /CXD33/) has_div_helper=1
    if (u ~ /ASL\.L #\$4/ || u ~ /ASL\.L #16/ || u ~ /ASL\.L #4/) has_shift4=1
    if (n ~ /ADDLD2D1/ || n ~ /ADDLD1D0/) has_add_scaled=1
    if (u ~ /#76([^0-9]|$)/ || u ~ /#\$4C/ || u ~ /\$4C/) has_const_76=1
    if (u ~ /#77([^0-9]|$)/ || u ~ /#\$4D/ || u ~ /\$4D/) has_const_77=1
    if (u ~ /#154([^0-9]|$)/ || u ~ /#\$9A/ || u ~ /\$9A/) has_const_154=1
    if (n ~ /ADDLD1D1/) has_double_77=1
    if (n ~ /MATHMULU32/) has_math_mulu32=1
    if (u ~ /8000/ || u ~ /\$8000/ || u ~ /BTST #7/ || u ~ /BTST #\$7/) has_flag_8000=1
    if (u ~ /8004/ || u ~ /\$8004/) has_flag_8004=1
    if (u ~ /0004/ || u ~ /\$4/ || u ~ /BTST #2,1\(/) has_flag_0004=1
    if ((u ~ /#15([^0-9]|$)/ || u ~ /#\$F/) && (n ~ /ASRL3D0/ || n ~ /ANDILFFFED0/)) has_span_round=1
    if (n ~ /TSTLD7/) has_mode_adjust_gate=1
    if ((u ~ /SUBQ\.[WL] #\$4/ || u ~ /SUBQ\.[WL] #4/) || (u ~ /SUBQ\.[WL] #\$2/ || u ~ /SUBQ\.[WL] #2/)) has_span_adjust=1
    if (u ~ /1700/ || u ~ /\$1700/) has_const_1700=1
    if (u ~ /FF00/ || u ~ /\$FF00/) has_const_ff00=1
    if (u ~ /#24([^0-9]|$)/ || u ~ /#\$24/) has_const_24=1
    if (u ~ /118\(A/ || u ~ /\$76\(A/ || u ~ /PLANEPTR118/) has_plane_118=1
    if (u ~ /122\(A/ || u ~ /\$7A\(A/) has_plane_122=1
    if (u ~ /126\(A/ || u ~ /\$7E\(A/) has_plane_126=1
    if (u ~ /130\(A/ || u ~ /\$82\(A/) has_plane_130=1
    if (u ~ /134\(A/ || u ~ /\$86\(A/ || u ~ /PLANEPTR134/) has_plane_134=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_GUARD_STORE="has_guard_store
    print "HAS_INIT_RUNTIME_ENTRIES_CALL="has_init_runtime_entries
    print "HAS_LOOP_10="has_loop_10
    print "HAS_PATTERN_TABLE="has_pattern_table
    print "HAS_RUNTIME_TABLE="has_runtime_table
    print "HAS_REG_SEED_TRIPLET="((has_reg_8e && has_reg_108 && has_reg_f2) || has_merged_reg_seed)
    print "HAS_X_OFFSET_LOAD="has_x_offset_load
    print "HAS_WIDTH_OFFSET_LOAD="has_width_offset_load
    print "HAS_DIV16_PATH="(has_const_16 && has_div_helper)
    print "HAS_REMAINDER_SCALE17="(has_shift4 && has_add_scaled)
    print "HAS_MUL_76="(has_const_76 && has_math_mulu32)
    print "HAS_MUL_154="((has_const_154 || (has_const_77 && has_double_77)) && has_math_mulu32)
    print "HAS_FLAG_8000="has_flag_8000
    print "HAS_FLAG_8004="has_flag_8004
    print "HAS_FLAG_0004="has_flag_0004
    print "HAS_SPAN_ROUND="has_span_round
    print "HAS_MODE_ADJUST_GATE="has_mode_adjust_gate
    print "HAS_SPAN_ADJUST="has_span_adjust
    print "HAS_CONST_1700="has_const_1700
    print "HAS_CONST_FF00="has_const_ff00
    print "HAS_CONST_24="has_const_24
    print "HAS_PLANE_118="has_plane_118
    print "HAS_PLANE_CLUSTER="(has_plane_118 && has_plane_122 && has_plane_126 && has_plane_130 && has_plane_134)
    print "HAS_PLANE_134="has_plane_134
    print "HAS_RTS="has_rts
}
