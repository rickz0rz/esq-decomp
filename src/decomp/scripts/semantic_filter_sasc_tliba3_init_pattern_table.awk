BEGIN {
    has_entry=0
    has_guard_store=0
    has_init_runtime_entries=0
    has_loop_10=0
    has_pattern_table=0
    has_runtime_table=0
    has_mul_76=0
    has_mul_154=0
    has_flag_8000=0
    has_flag_8004=0
    has_flag_0004=0
    has_const_1700=0
    has_const_ff00=0
    has_const_24=0
    has_plane_118=0
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
    if ((u ~ /#76([^0-9]|$)/ || u ~ /#\$4C/) && n ~ /MATHMULU32/) has_mul_76=1
    if (((u ~ /#77([^0-9]|$)/ || u ~ /#\$4D/) && n ~ /ADDLD1D1/) || u ~ /#154([^0-9]|$)/ || u ~ /#\$9A/) has_mul_154=1
    if (u ~ /8000/ || u ~ /\$8000/ || u ~ /BTST #7/ || u ~ /BTST #\$7/) has_flag_8000=1
    if (u ~ /8004/ || u ~ /\$8004/) has_flag_8004=1
    if (u ~ /0004/ || u ~ /\$4/ || u ~ /BTST #2,1\(/) has_flag_0004=1
    if (u ~ /1700/ || u ~ /\$1700/) has_const_1700=1
    if (u ~ /FF00/ || u ~ /\$FF00/) has_const_ff00=1
    if (u ~ /#24([^0-9]|$)/ || u ~ /#\$24/) has_const_24=1
    if (u ~ /118\(A/ || u ~ /\$76\(A/ || u ~ /PLANEPTR118/) has_plane_118=1
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
    print "HAS_MUL_76="has_mul_76
    print "HAS_MUL_154="has_mul_154
    print "HAS_FLAG_8000="has_flag_8000
    print "HAS_FLAG_8004="has_flag_8004
    print "HAS_FLAG_0004="has_flag_0004
    print "HAS_CONST_1700="has_const_1700
    print "HAS_CONST_FF00="has_const_ff00
    print "HAS_CONST_24="has_const_24
    print "HAS_PLANE_118="has_plane_118
    print "HAS_PLANE_134="has_plane_134
    print "HAS_RTS="has_rts
}
