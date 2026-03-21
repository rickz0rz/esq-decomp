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

    if (line ~ /^LOCAVAIL_UPDATEFILTERSTATEMACHINE:/ || line ~ /^LOCAVAIL_UPDATEFILTERSTATEMACHIN[A-Z0-9_]*:/) has_entry = 1
    if (line ~ /LOCAVAIL_FILTERMODEFLAG/) has_mode_flag = 1
    if (line ~ /LOCAVAIL_FILTERSTEP/) has_step_global = 1
    if (line ~ /LOCAVAIL_FILTERCLASSID/) has_class_global = 1
    if (line ~ /LOCAVAIL_FILTERPREVCLASSID/) has_prev_class = 1
    if (line ~ /NEWGRID_JMPTBL_MATH_MULU32/) has_mulu = 1
    if (line ~ /GROUP_AS_JMPTBL_STR_FINDCHARPTR/ || line ~ /STR_FINDCHARPTR/) has_find_char = 1
    if (line ~ /SCRIPT_READHANDSHAKEBIT5MASK/ || line ~ /READCIABBIT5MASK/) has_handshake = 1
    if (line ~ /LOCAVAIL_FILTERCOOLDOWNTICKS/) has_cooldown_store = 1
    if (line ~ /LOCAVAIL_FILTERWINDOWHALFSPAN/) has_window_store = 1
    if (line ~ /LOCAVAIL_RESETFILTERCURSORSTATE/) has_reset_call = 1
    if (line ~ /14\(A[0-6]\)/ || line ~ /18\(A[0-6]\)/ || line ~ /20\(A[0-6]\)/ || line ~ /24\(A[0-6]\)/ || line ~ /VALUE24/) has_ctx_field_updates = 1
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MODE_FLAG=" has_mode_flag
    print "HAS_STEP_GLOBAL=" has_step_global
    print "HAS_CLASS_GLOBAL=" has_class_global
    print "HAS_PREV_CLASS=" has_prev_class
    print "HAS_MULU=" has_mulu
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_HANDSHAKE=" has_handshake
    print "HAS_COOLDOWN_STORE=" has_cooldown_store
    print "HAS_WINDOW_STORE=" has_window_store
    print "HAS_RESET_CALL=" has_reset_call
    print "HAS_CTX_FIELD_UPDATES=" has_ctx_field_updates
    print "HAS_RETURN=" has_return
}
