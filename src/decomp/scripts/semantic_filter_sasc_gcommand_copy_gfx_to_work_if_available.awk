BEGIN {
    has_entry = 0
    has_lock = 0
    has_unlock = 0
    has_gfx_ref = 0
    has_work_ref = 0
    has_system_tag_call = 0
    has_wait0 = 0
    has_wait1 = 0
    wait_call_count = 0
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

    if (u ~ /^GCOMMAND_COPYGFXTOWORKIFAVAILAB[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "_LVOLOCK") > 0) has_lock = 1
    if (index(u, "_LVOUNLOCK") > 0) has_unlock = 1
    if (index(u, "GCOMMAND_PATH_GFX_COLON") > 0) has_gfx_ref = 1
    if (index(u, "GCOMMAND_STR_WORK_COLON") > 0) has_work_ref = 1
    if (index(u, "GROUP_AT_JMPTBL_DOS_SYSTEMTAGLIST") > 0 || index(u, "GROUP_AT_JMPTBL_DOS_SYSTEMTAGL") > 0 ||
        index(u, "DOS_SYSTEMTAGLIST") > 0) has_system_tag_call = 1
    if (index(u, "GROUP_AT_JMPTBL_ED1_WAITFORFLAGANDCLEARBIT0") > 0 ||
        index(u, "ED1_WAITFORFLAGANDCLEARBIT0") > 0) has_wait0 = 1
    if (index(u, "GROUP_AT_JMPTBL_ED1_WAITFORFLAGANDCLEARBIT1") > 0 ||
        index(u, "ED1_WAITFORFLAGANDCLEARBIT1") > 0) has_wait1 = 1
    if (index(u, "GROUP_AT_JMPTBL_ED1_WAITFORFLAGA") > 0 ||
        index(u, "ED1_WAITFORFLAGANDCLEARBIT") > 0) wait_call_count += 1
    if (u == "RTS") has_return = 1
}

END {
    if (wait_call_count >= 2) {
        has_wait0 = 1
        has_wait1 = 1
    }
    print "HAS_ENTRY=" has_entry
    print "HAS_LOCK=" has_lock
    print "HAS_UNLOCK=" has_unlock
    print "HAS_GFX_REF=" has_gfx_ref
    print "HAS_WORK_REF=" has_work_ref
    print "HAS_SYSTEM_TAG_CALL=" has_system_tag_call
    print "HAS_WAIT0=" has_wait0
    print "HAS_WAIT1=" has_wait1
    print "HAS_RETURN=" has_return
}
