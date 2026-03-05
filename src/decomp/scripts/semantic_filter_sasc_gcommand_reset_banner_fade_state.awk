BEGIN {
    has_entry = 0
    has_pending_ref = 0
    has_clear_pending = 0
    has_build_call = 0
    has_base_offset = 0
    has_tail_offset = 0
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

    if (uline ~ /^GCOMMAND_RESETBANNERFADESTATE:/) has_entry = 1
    if (index(uline, "GCOMMAND_BANNERFADERESETPENDINGFLAG") > 0 || index(uline, "GCOMMAND_BANNERFADERESETPENDINGF") > 0) has_pending_ref = 1
    if ((index(uline, "GCOMMAND_BANNERFADERESETPENDINGFLAG") > 0 || index(uline, "GCOMMAND_BANNERFADERESETPENDINGF") > 0) && (uline ~ /^CLR\.[BWL] / || uline ~ /^MOVE\.[BWL] #(\$)?0,/ || uline ~ /^MOVEQ(\.L)? #(\$)?0,D[0-7]$/)) has_clear_pending = 1
    if ((uline ~ /^BSR(\.[A-Z]+)? / || uline ~ /^JSR /) && index(uline, "GCOMMAND_BUILDBANNERTABLES") > 0) has_build_call = 1
    if (index(uline, "ESQSHARED4_INTERLEAVECOPYBASEOFFSET") > 0 || index(uline, "ESQSHARED4_INTERLEAVECOPYBASEOFF") > 0) has_base_offset = 1
    if (index(uline, "ESQSHARED4_INTERLEAVECOPYTAILOFFSETRESET") > 0 || index(uline, "ESQSHARED4_INTERLEAVECOPYTAILOFF") > 0) has_tail_offset = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PENDING_REF=" has_pending_ref
    print "HAS_CLEAR_PENDING=" has_clear_pending
    print "HAS_BUILD_CALL=" has_build_call
    print "HAS_BASE_OFFSET=" has_base_offset
    print "HAS_TAIL_OFFSET=" has_tail_offset
    print "HAS_RTS=" has_rts
}
