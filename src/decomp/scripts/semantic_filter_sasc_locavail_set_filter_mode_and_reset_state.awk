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

    if (line ~ /^LOCAVAIL_SETFILTERMODEANDRESETSTATE:/ || line ~ /^LOCAVAIL_SETFILTERMODEANDRESETST[A-Z0-9_]*:/) has_entry = 1
    if (line ~ /LOCAVAIL_FILTERMODEFLAG/) has_mode_flag = 1
    if (line ~ /#1/ || line ~ /#\$1/ || line ~ /#0/ || line ~ /#\$0/) has_mode_checks = 1
    if (line ~ /LOCAVAIL_FILTERMODEFLAG/ && line ~ /MOVE/) has_mode_store = 1
    if (line ~ /LOCAVAIL_RESETFILTERCURSORSTATE/ && line ~ /LOCAVAIL_PRIMARYFILTERSTATE/) has_reset_call = 1
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MODE_FLAG=" has_mode_flag
    print "HAS_MODE_CHECKS=" has_mode_checks
    print "HAS_MODE_STORE=" has_mode_store
    print "HAS_RESET_CALL=" has_reset_call
    print "HAS_RETURN=" has_return
}
