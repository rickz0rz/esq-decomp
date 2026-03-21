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

    if (line ~ /^LOCAVAIL_RESETFILTERCURSORSTATE:/ || line ~ /^LOCAVAIL_RESETFILTERCURSORSTATE[A-Z0-9_]*:/) has_entry = 1
    if (line ~ /#-1/ || line ~ /#\$FFFFFFFF/ || line ~ /#\$FF/ || line ~ /MOVEQ\.L #\$FF/ || line ~ /MOVEQ #-1/) has_minus_one = 1
    if (line ~ /SELECTEDNODEINDEX/ || line ~ /SELECTEDPAYLOADINDEX/ || line ~ /8\(A[0-6]\)/ || line ~ /12\(A[0-6]\)/) has_state_store = 1
    if (line ~ /LOCAVAIL_FILTERCLASSID/) has_class_store = 1
    if (line ~ /LOCAVAIL_FILTERSTEP/) has_step_store = 1
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MINUS_ONE=" has_minus_one
    print "HAS_STATE_STORE=" has_state_store
    print "HAS_CLASS_STORE=" has_class_store
    print "HAS_STEP_STORE=" has_step_store
    print "HAS_RETURN=" has_return
}
