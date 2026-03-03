BEGIN {
    has_tail_a = 0
    has_tail_b = 0
    has_head_read = 0
    has_bias_write = 0
    has_step_counter = 0
    has_guard_counter = 0
    has_reset_call = 0
    has_rts = 0
}

function trim(s,    t) {
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

    if (u ~ /ESQ_COPPERBANNERTAILLISTA/) has_tail_a = 1
    if (u ~ /ESQ_COPPERBANNERTAILLISTB/) has_tail_b = 1
    if (u ~ /CONFIG_BANNERCOPPERHEADBYTE/ && u ~ /,D[0-7]$/) has_head_read = 1
    if (u ~ /ESQPARS2_BANNERTAILBIASVALUE/) has_bias_write = 1
    if (u ~ /ESQPARS2_BANNERCOLORSTEPCOUNTER/) has_step_counter = 1
    if (u ~ /ESQPARS2_BANNERSWEEPENTRYGUARDCOUNTER/) has_guard_counter = 1
    if (u ~ /ESQSHARED4_RESETBANNERCOLORTOSTART/) has_reset_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_TAIL_A=" has_tail_a
    print "HAS_TAIL_B=" has_tail_b
    print "HAS_HEAD_READ=" has_head_read
    print "HAS_BIAS_WRITE=" has_bias_write
    print "HAS_STEP_COUNTER=" has_step_counter
    print "HAS_GUARD_COUNTER=" has_guard_counter
    print "HAS_RESET_CALL=" has_reset_call
    print "HAS_RTS=" has_rts
}
