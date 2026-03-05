BEGIN {
    has_entry = 0
    has_tail_a = 0
    has_tail_b = 0
    has_tail_bias = 0
    has_step_counter = 0
    has_guard_counter = 0
    has_f6 = 0
    has_f5 = 0
    has_80 = 0
    has_62 = 0
    has_1 = 0
    has_call_reset = 0
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

    if (uline ~ /^ESQSHARED4_RESETBANNERCOLORSWEEPSTATE:/ || uline ~ /^ESQSHARED4_RESETBANNERCOLORSWEEP[A-Z0-9_]*:/) has_entry = 1
    if (index(uline, "ESQ_COPPERBANNERTAILLISTA") > 0 || index(uline, "ESQ_COPPERBANNERTAILLIS") > 0) has_tail_a = 1
    if (index(uline, "ESQ_COPPERBANNERTAILLISTB") > 0 || index(uline, "ESQ_COPPERBANNERTAILLIS") > 0) has_tail_b = 1
    if (index(uline, "ESQPARS2_BANNERTAILBIASVALUE") > 0 || index(uline, "ESQPARS2_BANNERTAILBIASV") > 0) has_tail_bias = 1
    if (index(uline, "ESQPARS2_BANNERCOLORSTEPCOUNTER") > 0 || index(uline, "ESQPARS2_BANNERCOLORSTEPC") > 0) has_step_counter = 1
    if (index(uline, "ESQPARS2_BANNERSWEEPENTRYGUARDCOUNTER") > 0 || index(uline, "ESQPARS2_BANNERSWEEPENTRY") > 0) has_guard_counter = 1
    if (uline ~ /#(\$)?F6\b/ || uline ~ /#246\b/) has_f6 = 1
    if (uline ~ /#(\$)?F5\b/ || uline ~ /#245\b/) has_f5 = 1
    if (uline ~ /#(\$)?80\b/ || uline ~ /#128\b/) has_80 = 1
    if (uline ~ /#(\$)?62\b/ || uline ~ /#98\b/) has_62 = 1
    if (uline ~ /#(\$)?1\b/) has_1 = 1
    if (index(uline, "ESQSHARED4_RESETBANNERCOLORTOSTART") > 0 || index(uline, "ESQSHARED4_RESETBANNERCOLOR") > 0) has_call_reset = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TAIL_A=" has_tail_a
    print "HAS_TAIL_B=" has_tail_b
    print "HAS_TAIL_BIAS=" has_tail_bias
    print "HAS_STEP_COUNTER=" has_step_counter
    print "HAS_GUARD_COUNTER=" has_guard_counter
    print "HAS_F6_CONST=" has_f6
    print "HAS_F5_CONST=" has_f5
    print "HAS_80_CONST=" has_80
    print "HAS_62_CONST=" has_62
    print "HAS_1_CONST=" has_1
    print "HAS_CALL_RESET=" has_call_reset
    print "HAS_RTS=" has_rts
}
