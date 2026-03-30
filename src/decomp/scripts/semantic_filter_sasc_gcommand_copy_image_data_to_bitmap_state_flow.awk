BEGIN {
    has_entry = 0
    has_first_seed = 0
    has_second_seed = 0
    has_final_seed = 0
    has_final_tail = 0
    has_first_raster_pair = 0
    has_second_raster_pair = 0
    has_final_raster_pair = 0
    has_first_plane0_pair = 0
    has_first_plane1_pair = 0
    has_first_plane2_pair = 0
    has_second_plane0_pair = 0
    has_second_plane1_pair = 0
    has_second_plane2_pair = 0
    has_final_plane0_pair = 0
    has_final_plane1_pair = 0
    has_final_plane2_pair = 0
    has_first_block_ptr = 0
    has_second_block_ptr = 0
    has_final_block_ptr = 0
    has_block17_arg = 0
    has_block98_arg = 0
    has_row_zero_arg = 0
    has_block_call_pair = 0
    has_row_call = 0
    has_return = 0

    build_block_calls = 0
    arg98_count = 0

    pending_a1 = ""
    pending_a6 = ""
    prev1 = ""
    prev2 = ""
    prev3 = ""
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function set_pending(offset, reg) {
    if (reg == "A1") {
        pending_a1 = offset
    } else if (reg == "A6") {
        pending_a6 = offset
    }
}

function mark_offset(offset, op) {
    if (offset == "F_RASTER_HI") has_first_raster_pair = 1
    else if (offset == "F_RASTER_LO") has_first_raster_pair = has_first_raster_pair && 1
    else if (offset == "S_RASTER_HI") has_second_raster_pair = 1
    else if (offset == "S_RASTER_LO") has_second_raster_pair = has_second_raster_pair && 1
    else if (offset == "T_RASTER_HI") has_final_raster_pair = 1
    else if (offset == "T_RASTER_LO") has_final_raster_pair = has_final_raster_pair && 1
}

function update_pair_flags(offset) {
    if (offset == "F_RASTER_HI") first_raster_hi = 1
    else if (offset == "F_RASTER_LO") first_raster_lo = 1
    else if (offset == "S_RASTER_HI") second_raster_hi = 1
    else if (offset == "S_RASTER_LO") second_raster_lo = 1
    else if (offset == "T_RASTER_HI") final_raster_hi = 1
    else if (offset == "T_RASTER_LO") final_raster_lo = 1
    else if (offset == "F_P0_HI") first_plane0_hi = 1
    else if (offset == "F_P0_LO") first_plane0_lo = 1
    else if (offset == "F_P1_HI") first_plane1_hi = 1
    else if (offset == "F_P1_LO") first_plane1_lo = 1
    else if (offset == "F_P2_HI") first_plane2_hi = 1
    else if (offset == "F_P2_LO") first_plane2_lo = 1
    else if (offset == "S_P0_HI") second_plane0_hi = 1
    else if (offset == "S_P0_LO") second_plane0_lo = 1
    else if (offset == "S_P1_HI") second_plane1_hi = 1
    else if (offset == "S_P1_LO") second_plane1_lo = 1
    else if (offset == "S_P2_HI") second_plane2_hi = 1
    else if (offset == "S_P2_LO") second_plane2_lo = 1
    else if (offset == "T_P0_HI") final_plane0_hi = 1
    else if (offset == "T_P0_LO") final_plane0_lo = 1
    else if (offset == "T_P1_HI") final_plane1_hi = 1
    else if (offset == "T_P1_LO") final_plane1_lo = 1
    else if (offset == "T_P2_HI") final_plane2_hi = 1
    else if (offset == "T_P2_LO") final_plane2_lo = 1
    else if (offset == "F_BLOCK_HI") first_block_hi = 1
    else if (offset == "F_BLOCK_LO") first_block_lo = 1
    else if (offset == "S_BLOCK_HI") second_block_hi = 1
    else if (offset == "S_BLOCK_LO") second_block_lo = 1
    else if (offset == "T_BLOCK_HI") final_block_hi = 1
    else if (offset == "T_BLOCK_LO") final_block_lo = 1
}

function maybe_commit_pending(u,    offset) {
    offset = ""
    if (u ~ /^MOVE\.[BWL] [^,]+,\(A1\)$/ || u ~ /^CLR\.[WL] \(A1\)$/) {
        offset = pending_a1
        pending_a1 = ""
    } else if (u ~ /^MOVE\.[BWL] [^,]+,\(A6\)$/ || u ~ /^CLR\.[WL] \(A6\)$/) {
        offset = pending_a6
        pending_a6 = ""
    }
    if (offset != "") {
        update_pair_flags(offset)
    }
}

{
    line = trim($0)
    if (line == "") next

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^GCOMMAND_COPYIMAGEDATATOBITMAP:/ || u ~ /^GCOMMAND_COPYIMAGEDATATOBIT[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (u ~ /^MOVE\.B [^,]+,(80|\$50)\(A0\)$/) has_first_seed = 1
    if (u ~ /^MOVE\.B [^,]+,(672|\$2A0)\(A0\)$/) has_second_seed = 1
    if (u ~ /^MOVE\.B [^,]+,(708|\$2C4)\(A0\)$/) has_second_seed = 1
    if (u ~ /^MOVE\.B [^,]+,(3876|\$F24)\(A0\)$/) has_final_seed = 1
    if (u ~ /^MOVE\.B #\$80,(3916|\$F4C)\(A0\)$/ || u ~ /^MOVE\.W #\$80FE,\(A1\)$/ && prev1 ~ /^LEA (\$F4E|3918)\(A0\),A1$/) {
        has_final_tail = 1
    }

    if (u ~ /^MOVE\.W [^,]+,(42|\$2A)\(A0\)$/) update_pair_flags("F_RASTER_HI")
    if (u ~ /^MOVE\.W [^,]+,(46|\$2E)\(A0\)$/) update_pair_flags("F_RASTER_LO")
    if (u ~ /^MOVE\.W [^,]+,(686|\$2AE)\(A0\)$/) update_pair_flags("S_RASTER_HI")
    if (u ~ /^MOVE\.W [^,]+,(690|\$2B2)\(A0\)$/) update_pair_flags("S_RASTER_LO")
    if (u ~ /^MOVE\.W [^,]+,(3930|\$F5A)\(A0\)$/) update_pair_flags("T_RASTER_HI")
    if (u ~ /^MOVE\.W [^,]+,(3934|\$F5E)\(A0\)$/) update_pair_flags("T_RASTER_LO")

    if (u ~ /^MOVE\.W [^,]+,(86|\$56)\(A0\)$/) update_pair_flags("F_P0_HI")
    if (u ~ /^MOVE\.W [^,]+,(90|\$5A)\(A0\)$/) update_pair_flags("F_P0_LO")
    if (u ~ /^MOVE\.W [^,]+,(94|\$5E)\(A0\)$/) update_pair_flags("F_P1_HI")
    if (u ~ /^MOVE\.W [^,]+,(98|\$62)\(A0\)$/) update_pair_flags("F_P1_LO")
    if (u ~ /^MOVE\.W [^,]+,(102|\$66)\(A0\)$/) update_pair_flags("F_P2_HI")
    if (u ~ /^MOVE\.W [^,]+,(106|\$6A)\(A0\)$/) update_pair_flags("F_P2_LO")

    if (u ~ /^MOVE\.W [^,]+,(714|\$2CA)\(A0\)$/) update_pair_flags("S_P0_HI")
    if (u ~ /^MOVE\.W [^,]+,(718|\$2CE)\(A0\)$/) update_pair_flags("S_P0_LO")
    if (u ~ /^MOVE\.W [^,]+,(694|\$2B6)\(A0\)$/) update_pair_flags("S_P1_HI")
    if (u ~ /^MOVE\.W [^,]+,(698|\$2BA)\(A0\)$/) update_pair_flags("S_P1_LO")
    if (u ~ /^MOVE\.W [^,]+,(702|\$2BE)\(A0\)$/) update_pair_flags("S_P2_HI")
    if (u ~ /^MOVE\.W [^,]+,(706|\$2C2)\(A0\)$/) update_pair_flags("S_P2_LO")

    if (u ~ /^MOVE\.W [^,]+,(3882|\$F2A)\(A0\)$/) update_pair_flags("T_P0_HI")
    if (u ~ /^MOVE\.W [^,]+,(3886|\$F2E)\(A0\)$/) update_pair_flags("T_P0_LO")
    if (u ~ /^MOVE\.W [^,]+,(3890|\$F32)\(A0\)$/) update_pair_flags("T_P1_HI")
    if (u ~ /^MOVE\.W [^,]+,(3894|\$F36)\(A0\)$/) update_pair_flags("T_P1_LO")
    if (u ~ /^MOVE\.W [^,]+,(3898|\$F3A)\(A0\)$/) update_pair_flags("T_P2_HI")
    if (u ~ /^MOVE\.W [^,]+,(3902|\$F3E)\(A0\)$/) update_pair_flags("T_P2_LO")

    if (u ~ /^MOVE\.W [^,]+,(118|\$76)\(A0\)$/) update_pair_flags("F_BLOCK_HI")
    if (u ~ /^MOVE\.W [^,]+,(122|\$7A)\(A0\)$/) update_pair_flags("F_BLOCK_LO")
    if (u ~ /^MOVE\.W [^,]+,(730|\$2DA)\(A0\)$/) update_pair_flags("S_BLOCK_HI")
    if (u ~ /^MOVE\.W [^,]+,(734|\$2DE)\(A0\)$/) update_pair_flags("S_BLOCK_LO")
    if (u ~ /^MOVE\.W [^,]+,(3906|\$F42)\(A0\)$/) update_pair_flags("T_BLOCK_HI")
    if (u ~ /^MOVE\.W [^,]+,(3910|\$F46)\(A0\)$/) update_pair_flags("T_BLOCK_LO")

    if (u ~ /^LEA (\$2A|42)\(A0\),A1$/) set_pending("F_RASTER_HI", "A1")
    else if (u ~ /^LEA (\$2E|46)\(A0\),A1$/) set_pending("F_RASTER_LO", "A1")
    else if (u ~ /^LEA (\$2AE|686)\(A0\),A1$/) set_pending("S_RASTER_HI", "A1")
    else if (u ~ /^LEA (\$2B2|690)\(A0\),A1$/) set_pending("S_RASTER_LO", "A1")
    else if (u ~ /^LEA (\$F5A|3930)\(A0\),A1$/) set_pending("T_RASTER_HI", "A1")
    else if (u ~ /^LEA (\$F5E|3934)\(A0\),A1$/) set_pending("T_RASTER_LO", "A1")
    else if (u ~ /^LEA (\$56|86)\(A0\),A6$/) set_pending("F_P0_HI", "A6")
    else if (u ~ /^LEA (\$5A|90)\(A0\),A6$/) set_pending("F_P0_LO", "A6")
    else if (u ~ /^LEA (\$5E|94)\(A0\),A6$/) set_pending("F_P1_HI", "A6")
    else if (u ~ /^LEA (\$62|98)\(A0\),A6$/) set_pending("F_P1_LO", "A6")
    else if (u ~ /^LEA (\$66|102)\(A0\),A1$/) set_pending("F_P2_HI", "A1")
    else if (u ~ /^LEA (\$6A|106)\(A0\),A1$/) set_pending("F_P2_LO", "A1")
    else if (u ~ /^LEA (\$2B6|694)\(A0\),A1$/) set_pending("S_P1_HI", "A1")
    else if (u ~ /^LEA (\$2BA|698)\(A0\),A1$/) set_pending("S_P1_LO", "A1")
    else if (u ~ /^LEA (\$2BE|702)\(A0\),A1$/) set_pending("S_P2_HI", "A1")
    else if (u ~ /^LEA (\$2C2|706)\(A0\),A1$/) set_pending("S_P2_LO", "A1")
    else if (u ~ /^LEA (\$2CA|714)\(A0\),A1$/) set_pending("S_P0_HI", "A1")
    else if (u ~ /^LEA (\$2CE|718)\(A0\),A1$/) set_pending("S_P0_LO", "A1")
    else if (u ~ /^LEA (\$F2A|3882)\(A0\),A1$/) set_pending("T_P0_HI", "A1")
    else if (u ~ /^LEA (\$F2E|3886)\(A0\),A1$/) set_pending("T_P0_LO", "A1")
    else if (u ~ /^LEA (\$F32|3890)\(A0\),A1$/) set_pending("T_P1_HI", "A1")
    else if (u ~ /^LEA (\$F36|3894)\(A0\),A1$/) set_pending("T_P1_LO", "A1")
    else if (u ~ /^LEA (\$F3A|3898)\(A0\),A1$/) set_pending("T_P2_HI", "A1")
    else if (u ~ /^LEA (\$F3E|3902)\(A0\),A1$/) set_pending("T_P2_LO", "A1")
    else if (u ~ /^LEA (\$76|118)\(A0\),A6$/) set_pending("F_BLOCK_HI", "A6")
    else if (u ~ /^LEA (\$7A|122)\(A0\),A6$/) set_pending("F_BLOCK_LO", "A6")
    else if (u ~ /^LEA (\$2DA|730)\(A0\),A6$/) set_pending("S_BLOCK_HI", "A6")
    else if (u ~ /^LEA (\$2DE|734)\(A0\),A6$/) set_pending("S_BLOCK_LO", "A6")
    else if (u ~ /^LEA (\$F42|3906)\(A0\),A6$/) set_pending("T_BLOCK_HI", "A6")
    else if (u ~ /^LEA (\$F46|3910)\(A0\),A6$/) set_pending("T_BLOCK_LO", "A6")

    maybe_commit_pending(u)

    if (u ~ /^PEA (\(\$11\)|17)\.W$/) has_block17_arg = 1
    if (u ~ /^PEA (\(\$62\)|98)\.W$/) {
        has_block98_arg = 1
        arg98_count++
    }
    if (u ~ /^CLR\.L -\(A7\)$/) has_row_zero_arg = 1

    if (index(u, "GCOMMAND_BUILDBANNERBLOCK") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) {
        build_block_calls++
    }
    if (index(u, "GCOMMAND_BUILDBANNERROW") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) {
        has_row_call = 1
    }

    if (u == "RTS") has_return = 1

    prev3 = prev2
    prev2 = prev1
    prev1 = u
}

END {
    has_first_raster_pair = first_raster_hi && first_raster_lo
    has_second_raster_pair = second_raster_hi && second_raster_lo
    has_final_raster_pair = final_raster_hi && final_raster_lo

    has_first_plane0_pair = first_plane0_hi && first_plane0_lo
    has_first_plane1_pair = first_plane1_hi && first_plane1_lo
    has_first_plane2_pair = first_plane2_hi && first_plane2_lo
    has_second_plane0_pair = second_plane0_hi && second_plane0_lo
    has_second_plane1_pair = second_plane1_hi && second_plane1_lo
    has_second_plane2_pair = second_plane2_hi && second_plane2_lo
    has_final_plane0_pair = final_plane0_hi && final_plane0_lo
    has_final_plane1_pair = final_plane1_hi && final_plane1_lo
    has_final_plane2_pair = final_plane2_hi && final_plane2_lo

    has_first_block_ptr = first_block_hi && first_block_lo
    has_second_block_ptr = second_block_hi && second_block_lo
    has_final_block_ptr = final_block_hi && final_block_lo

    has_block_call_pair = (build_block_calls == 2)

    print "HAS_ENTRY=" has_entry
    print "HAS_FIRST_SEED=" has_first_seed
    print "HAS_SECOND_SEED=" has_second_seed
    print "HAS_FINAL_SEED=" has_final_seed
    print "HAS_FINAL_TAIL=" has_final_tail
    print "HAS_FIRST_RASTER_PAIR=" has_first_raster_pair
    print "HAS_SECOND_RASTER_PAIR=" has_second_raster_pair
    print "HAS_FINAL_RASTER_PAIR=" has_final_raster_pair
    print "HAS_FIRST_PLANE0_PAIR=" has_first_plane0_pair
    print "HAS_FIRST_PLANE1_PAIR=" has_first_plane1_pair
    print "HAS_FIRST_PLANE2_PAIR=" has_first_plane2_pair
    print "HAS_SECOND_PLANE0_PAIR=" has_second_plane0_pair
    print "HAS_SECOND_PLANE1_PAIR=" has_second_plane1_pair
    print "HAS_SECOND_PLANE2_PAIR=" has_second_plane2_pair
    print "HAS_FINAL_PLANE0_PAIR=" has_final_plane0_pair
    print "HAS_FINAL_PLANE1_PAIR=" has_final_plane1_pair
    print "HAS_FINAL_PLANE2_PAIR=" has_final_plane2_pair
    print "HAS_FIRST_BLOCK_PTR=" has_first_block_ptr
    print "HAS_SECOND_BLOCK_PTR=" has_second_block_ptr
    print "HAS_FINAL_BLOCK_PTR=" has_final_block_ptr
    print "HAS_BLOCK17_ARG=" has_block17_arg
    print "HAS_BLOCK98_ARG=" has_block98_arg
    print "ARG98_COUNT=" arg98_count
    print "HAS_ROW_ZERO_ARG=" has_row_zero_arg
    print "HAS_BLOCK_CALL_PAIR=" has_block_call_pair
    print "HAS_ROW_CALL=" has_row_call
    print "HAS_RETURN=" has_return
}
