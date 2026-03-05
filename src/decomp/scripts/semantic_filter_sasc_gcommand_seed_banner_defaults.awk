BEGIN {
    has_entry = 0
    has_build_call = 0
    has_table_a_ref = 0
    has_table_b_ref = 0
    has_head_31 = 0
    has_d9 = 0
    has_fffe = 0
    has_tail_f8 = 0
    has_tail_offsets = 0
    has_return = 0
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
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^GCOMMAND_SEEDBANNERDEFAULTS:/) has_entry = 1
    if (index(u, "GCOMMAND_BUILDBANNERTABLES") > 0 && (u ~ /^BSR\./ || u ~ /^JSR /)) has_build_call = 1

    if (index(u, "ESQ_COPPERLISTBANNERA") > 0) has_table_a_ref = 1
    if (index(u, "ESQ_COPPERLISTBANNERB") > 0) has_table_b_ref = 1

    if (u ~ /^MOVEQ(\.L)? #31,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$1F,D[0-7]$/ || u ~ /^MOVE\.B #\$1F,/) has_head_31 = 1
    if (u ~ /^MOVEQ(\.L)? #\-39,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$D9,D[0-7]$/ || u ~ /^MOVE\.B #\$D9,/) has_d9 = 1
    if (u ~ /^MOVEQ(\.L)? #\-2,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$FE,D[0-7]$/ || u ~ /^MOVE\.W #\$FFFE,/) has_fffe = 1
    if (u ~ /^MOVEQ(\.L)? #\-8,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$F8,D[0-7]$/ || u ~ /^MOVE\.B #\$F8,/) has_tail_f8 = 1

    if (u ~ /3916\(A[0-7]\)/ || u ~ /\$F4C\(A[0-7]\)/ || u ~ /ESQ_COPPERLISTBANNER[AB]\+\$F4C\(A4\)/) has_tail_offsets = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_BUILD_CALL=" has_build_call
    print "HAS_TABLE_A_REF=" has_table_a_ref
    print "HAS_TABLE_B_REF=" has_table_b_ref
    print "HAS_HEAD_31=" has_head_31
    print "HAS_D9=" has_d9
    print "HAS_FFFE=" has_fffe
    print "HAS_TAIL_F8=" has_tail_f8
    print "HAS_TAIL_OFFSETS=" has_tail_offsets
    print "HAS_RETURN=" has_return
}
