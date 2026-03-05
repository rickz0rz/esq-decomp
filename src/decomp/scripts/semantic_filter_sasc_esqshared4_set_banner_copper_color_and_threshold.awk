BEGIN {
    has_entry = 0
    has_list_a = 0
    has_list_b = 0
    has_wait_row_a = 0
    has_wait_row_b = 0
    has_wait_start_a = 0
    has_wait_start_b = 0
    has_wait_end_a = 0
    has_wait_end_b = 0
    has_threshold = 0
    has_add_1 = 0
    has_add_11 = 0
    has_and_ff = 0
    has_rts = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQSHARED4_SETBANNERCOPPERCOLORANDTHRESHOLD:/ || uline ~ /^ESQSHARED4_SETBANNERCOPPERCOLOR[A-Z0-9_]*:/) has_entry = 1
    if (index(uline, "ESQ_COPPERLISTBANNERA") > 0 || index(uline, "ESQ_COPPERLISTBANNER") > 0) has_list_a = 1
    if (index(uline, "ESQ_COPPERLISTBANNERB") > 0 || index(uline, "ESQ_COPPERLISTBANNER") > 0) has_list_b = 1
    if (index(uline, "ESQ_BANNERSWEEPWAITROWA") > 0 || index(uline, "ESQ_BANNERSWEEPWAITROW") > 0) has_wait_row_a = 1
    if (index(uline, "ESQ_BANNERSWEEPWAITROWB") > 0 || index(uline, "ESQ_BANNERSWEEPWAITROW") > 0) has_wait_row_b = 1
    if (index(uline, "ESQ_BANNERSWEEPWAITSTARTPROGRAMA") > 0 || index(uline, "ESQ_BANNERSWEEPWAITSTART") > 0) has_wait_start_a = 1
    if (index(uline, "ESQ_BANNERSWEEPWAITSTARTPROGRAMB") > 0 || index(uline, "ESQ_BANNERSWEEPWAITSTART") > 0) has_wait_start_b = 1
    if (index(uline, "ESQ_BANNERSWEEPWAITENDPROGRAMA") > 0 || index(uline, "ESQ_BANNERSWEEPWAITEND") > 0) has_wait_end_a = 1
    if (index(uline, "ESQ_BANNERSWEEPWAITENDPROGRAMB") > 0 || index(uline, "ESQ_BANNERSWEEPWAITEND") > 0) has_wait_end_b = 1
    if (index(uline, "ESQPARS2_BANNERCOLORTHRESHOLD") > 0 || index(uline, "ESQPARS2_BANNERCOLORTHRES") > 0) has_threshold = 1
    if (uline ~ /#(\$)?1/ || uline ~ /ADDQ\.W #(\$)?1/ || uline ~ /ADDI\.B #(\$)?1/) has_add_1 = 1
    if (uline ~ /#(\$)?11/ || uline ~ /#17/) has_add_11 = 1
    if (uline ~ /ANDI\.W #(\$)?FF/ || uline ~ /AND\.W #(\$)?FF/ || uline ~ /#255/) has_and_ff = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LIST_A=" has_list_a
    print "HAS_LIST_B=" has_list_b
    print "HAS_WAIT_ROW_A=" has_wait_row_a
    print "HAS_WAIT_ROW_B=" has_wait_row_b
    print "HAS_WAIT_START_A=" has_wait_start_a
    print "HAS_WAIT_START_B=" has_wait_start_b
    print "HAS_WAIT_END_A=" has_wait_end_a
    print "HAS_WAIT_END_B=" has_wait_end_b
    print "HAS_THRESHOLD=" has_threshold
    print "HAS_ADD_1=" has_add_1
    print "HAS_ADD_11=" has_add_11
    print "HAS_AND_FF=" has_and_ff
    print "HAS_RTS=" has_rts
}
