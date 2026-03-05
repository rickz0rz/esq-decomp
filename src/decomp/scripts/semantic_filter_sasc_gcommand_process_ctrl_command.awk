BEGIN {
    has_entry = 0
    has_type_read = 0
    has_type1_check = 0
    has_ring_ref = 0
    has_call48 = 0
    has_ring_advance = 0
    has_ring_wrap20 = 0
    has_type15_16_check = 0
    has_drive_probe_set = 0
    has_zero_return = 0
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

    if (u ~ /^GCOMMAND_PROCESSCTRLCOMMAND[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVE\.B 4\(A[0-7]\),D[0-7]$/ || u ~ /^MOVE\.B \$4\(A[0-7]\),D[0-7]$/) has_type_read = 1
    if (u ~ /^MOVEQ(\.L)? #1,D[0-7]$/ || u ~ /^CMP\.B D[0-7],D[0-7]$/) has_type1_check = 1

    if (index(u, "ED_STATERINGWRITEINDEX") > 0 || index(u, "ED_STATERINGTABLE") > 0) has_ring_ref = 1
    if (index(u, "GROUP_AV_JMPTBL_EXEC_CALLVECTOR_48") > 0 || index(u, "GROUP_AV_JMPTBL_EXEC_CALLVECTOR_") > 0) has_call48 = 1

    if (index(u, "ED_STATERINGWRITEINDEX") > 0 && (u ~ /^ADDQ\.L #\$1,/ || u ~ /^ADDQ\.L #1,/ || u ~ /^MOVE\.L /)) has_ring_advance = 1
    if (u ~ /^CMPI\.[LW] #\$14,ED_STATERINGWRITEINDEX/ || u ~ /^CMPI\.[LW] #20,ED_STATERINGWRITEINDEX/ || u ~ /^CLR\.L ED_STATERINGWRITEINDEX/) has_ring_wrap20 = 1

    if (u ~ /^MOVEQ(\.L)? #16,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #15,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$10,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$F,D[0-7]$/) has_type15_16_check = 1
    if (index(u, "GCOMMAND_DRIVEPROBEREQUESTEDFLAG") > 0 && u ~ /^MOVE\.W /) has_drive_probe_set = 1

    if (u ~ /^MOVEQ(\.L)? #0,D0$/ || u ~ /^MOVEQ(\.L)? #\$0,D0$/) has_zero_return = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TYPE_READ=" has_type_read
    print "HAS_TYPE1_CHECK=" has_type1_check
    print "HAS_RING_REF=" has_ring_ref
    print "HAS_CALL48=" has_call48
    print "HAS_RING_ADVANCE=" has_ring_advance
    print "HAS_RING_WRAP20=" has_ring_wrap20
    print "HAS_TYPE15_16_CHECK=" has_type15_16_check
    print "HAS_DRIVE_PROBE_SET=" has_drive_probe_set
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_RETURN=" has_return
}
