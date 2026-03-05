BEGIN {
    has_entry = 0
    has_step_counter = 0
    has_62 = 0
    has_19 = 0
    has_call_set = 0
    has_58 = 0
    has_call_bind = 0
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

    if (uline ~ /^ESQSHARED4_RESETBANNERCOLORTOSTART:/ || uline ~ /^ESQSHARED4_RESETBANNERCOLORTOST[A-Z0-9_]*:/) has_entry = 1
    if (index(uline, "ESQPARS2_BANNERCOLORSTEPCOUNTER") > 0 || index(uline, "ESQPARS2_BANNERCOLORSTEPC") > 0) has_step_counter = 1
    if (uline ~ /#(\$)?62/ || uline ~ /#98/) has_62 = 1
    if (uline ~ /#(\$)?19/ || uline ~ /#25/) has_19 = 1
    if (index(uline, "ESQSHARED4_SETBANNERCOPPERCOLORANDTHRESHOLD") > 0 || index(uline, "SETBANNERCOPPERCOLOR") > 0) has_call_set = 1
    if (uline ~ /#(\$)?58/ || uline ~ /\(\$58\)/ || uline ~ /#88/) has_58 = 1
    if (index(uline, "ESQSHARED4_BINDANDCLEARBANNERWORKRASTER") > 0 || index(uline, "BINDANDCLEARBANNERWOR") > 0) has_call_bind = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_STEP_COUNTER=" has_step_counter
    print "HAS_62_CONST=" has_62
    print "HAS_19_CONST=" has_19
    print "HAS_CALL_SET=" has_call_set
    print "HAS_58_CONST=" has_58
    print "HAS_CALL_BIND=" has_call_bind
    print "HAS_RTS=" has_rts
}
