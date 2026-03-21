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

    if (line ~ /^LOCAVAIL_SYNCSECONDARYFILTERFORCURRENTGROUP:/ || line ~ /^LOCAVAIL_SYNCSECONDARYFILTERFORC[A-Z0-9_]*:/) has_entry = 1
    if (line ~ /LOCAVAIL_SECONDARYFILTERSTATE/ && line ~ /TEXTDISP_SECONDARYGROUPCODE/) has_secondary_group_check = 1
    if (line ~ /LOCAVAIL_PRIMARYFILTERSTATE/ && line ~ /TEXTDISP_PRIMARYGROUPCODE/) has_primary_group_check = 1
    if (line ~ /LOCAVAIL_SECONDARYFILTERSTATE/ && line ~ /LOCAVAIL_FREERESOURCECHAIN/) has_free_secondary = 1
    if ((line ~ /LOCAVAIL_COPYFILTERSTATESTRUCTRE/ || line ~ /COPYFILTERSTATESTRUCTRETAINREFS/) && line ~ /LOCAVAIL_SECONDARYFILTERSTATE/ && line ~ /LOCAVAIL_PRIMARYFILTERSTATE/) has_copy_primary_to_secondary = 1
    if (line ~ /LOCAVAIL_SECONDARYFILTERSTATE/ && line ~ /TEXTDISP_SECONDARYGROUPCODE/ && line ~ /MOVE/) has_secondary_group_store = 1
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SECONDARY_GROUP_CHECK=" has_secondary_group_check
    print "HAS_PRIMARY_GROUP_CHECK=" has_primary_group_check
    print "HAS_FREE_SECONDARY=" has_free_secondary
    print "HAS_COPY_PRIMARY_TO_SECONDARY=" has_copy_primary_to_secondary
    print "HAS_SECONDARY_GROUP_STORE=" has_secondary_group_store
    print "HAS_RETURN=" has_return
}
