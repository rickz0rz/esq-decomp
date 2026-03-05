BEGIN {
    has_entry = 0
    has_loop_bound = 0
    has_mode_countdown = 0
    has_base_positive_guard = 0
    has_phase_accum = 0
    has_carry_1000 = 0
    has_step_clamp = 0
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

    if (u ~ /^GCOMMAND_TICKPRESETWORKENTRIES:/) has_entry = 1
    if (u ~ /^MOVEQ(\.L)? #\$4,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #4,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/) has_loop_bound = 1
    if (u ~ /^TST\.[LW] 20\(A[0-7]\)$/ || u ~ /^MOVE\.L \$14\(A[0-7]\),D[0-7]$/ || u ~ /^SUBQ\.[LW] #\$1,20\(A[0-7]\)$/ || u ~ /^SUBQ\.[LW] #1,20\(A[0-7]\)$/ || u ~ /^SUBQ\.[LW] #\$1,\$14\(A[0-7]\)$/ || u ~ /^SUBQ\.[LW] #1,\$14\(A[0-7]\)$/) has_mode_countdown = 1
    if (u ~ /^MOVE\.L 12\(A[0-7]\),D[0-7]$/ || u ~ /^TST\.[LW] D[0-7]$/) has_base_positive_guard = 1
    if (u ~ /^ADD\.[LW] D[0-7],16\(A[0-7]\)$/ || u ~ /^ADD\.[LW] D[0-7],\$10\(A[0-7]\)$/ || u ~ /^MOVE\.L 16\(A[0-7]\),D[0-7]$/ || u ~ /^MOVE\.L \$10\(A[0-7]\),D[0-7]$/) has_phase_accum = 1
    if (u ~ /^CMPI\.[LW] #\$?3E8,D[0-7]$/ || u ~ /^CMPI\.[LW] #1000,D[0-7]$/ || u ~ /^SUBI\.[LW] #\$?3E8,16\(A[0-7]\)$/ || u ~ /^SUBI\.[LW] #1000,16\(A[0-7]\)$/) has_carry_1000 = 1
    if (u ~ /^CLR\.[LW] 12\(A[0-7]\)$/ || u ~ /^CLR\.[LW] \$C\(A[0-7]\)$/ || u ~ /^MOVE\.L 4\(A[0-7]\),8\(A[0-7]\)$/ || u ~ /^MOVE\.L \$4\(A[0-7]\),\$8\(A[0-7]\)$/) has_step_clamp = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_MODE_COUNTDOWN=" has_mode_countdown
    print "HAS_BASE_POSITIVE_GUARD=" has_base_positive_guard
    print "HAS_PHASE_ACCUM=" has_phase_accum
    print "HAS_CARRY_1000=" has_carry_1000
    print "HAS_STEP_CLAMP=" has_step_clamp
    print "HAS_RETURN=" has_return
}
