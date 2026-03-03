BEGIN {
    has_entry = 0
    has_probe = 0
    has_tick_inc = 0
    has_tick_clear = 0
    has_tick_set_neg1 = 0
    has_warn_msg_a = 0
    has_warn_msg_b = 0
    has_draw = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQFUNC_UPDATEDISKWARNINGANDREFRESHTICK:/) has_entry = 1
    if (uline ~ /ESQFUNC_JMPTBL_DISKIO_PROBEDRIVESANDASSIGNPATHS/) has_probe = 1
    if (uline ~ /^ADDQ\.W #1,D0$/) has_tick_inc = 1
    if (uline ~ /^CLR\.W GLOBAL_REFRESHTICKCOUNTER$/) has_tick_clear = 1
    if (uline ~ /^MOVE\.W #\(-1\),GLOBAL_REFRESHTICKCOUNTER$/) has_tick_set_neg1 = 1
    if (uline ~ /GLOBAL_STR_DISK_0_IS_WRITE_PROTECTED/) has_warn_msg_a = 1
    if (uline ~ /GLOBAL_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0/) has_warn_msg_b = 1
    if (uline ~ /ESQFUNC_JMPTBL_TLIBA3_DRAWCENTEREDWRAPPEDTEXTLINES/) has_draw = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PROBE=" has_probe
    print "HAS_TICK_INC=" has_tick_inc
    print "HAS_TICK_CLEAR=" has_tick_clear
    print "HAS_TICK_SET_NEG1=" has_tick_set_neg1
    print "HAS_WARN_MSG_A=" has_warn_msg_a
    print "HAS_WARN_MSG_B=" has_warn_msg_b
    print "HAS_DRAW=" has_draw
    print "HAS_RETURN=" has_return
}
