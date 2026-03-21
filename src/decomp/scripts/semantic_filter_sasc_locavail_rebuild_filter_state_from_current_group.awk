function norm(s, t) {
    t = toupper(s)
    sub(/;.*/, "", t)
    gsub(/^[ \t]+|[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return t
}

{
    line = norm($0)
    if (line == "") next

    if (line ~ /^LOCAVAIL_REBUILDFILTERSTATEFROMCURRENTGROUP:/ || line ~ /^LOCAVAIL_REBUILDFILTERSTATEFROMC[A-Z0-9_]*:/) has_entry = 1
    if (line ~ /LOCAVAIL_PRIMARYFILTERSTATE/ && line ~ /LOCAVAIL_FREERESOURCECHAIN/) has_free_primary = 1
    if (line ~ /LOCAVAIL_COPYFILTERSTATESTRUCTRETAINREFS/ && line ~ /LOCAVAIL_SECONDARYFILTERSTATE/ && line ~ /LOCAVAIL_PRIMARYFILTERSTATE/) has_copy_secondary_to_primary = 1
    if (line ~ /LOCAVAIL_SECONDARYFILTERSTATE/ && line ~ /LOCAVAIL_FREERESOURCECHAIN/) has_free_secondary = 1
    if (line ~ /LOCAVAIL_SECONDARYFILTERSTATE/ && line ~ /TEXTDISP_PRIMARYGROUPCODE/) has_secondary_group_reset = 1
    if (line ~ /LOCAVAIL_RESETFILTERCURSORSTATE/ && line ~ /LOCAVAIL_PRIMARYFILTERSTATE/) has_reset_cursor = 1
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FREE_PRIMARY=" has_free_primary
    print "HAS_COPY_SECONDARY_TO_PRIMARY=" has_copy_secondary_to_primary
    print "HAS_FREE_SECONDARY=" has_free_secondary
    print "HAS_SECONDARY_GROUP_RESET=" has_secondary_group_reset
    print "HAS_RESET_CURSOR=" has_reset_cursor
    print "HAS_RETURN=" has_return
}
