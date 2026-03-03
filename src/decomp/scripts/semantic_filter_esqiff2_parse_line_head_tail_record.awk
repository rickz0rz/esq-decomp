BEGIN {
    has_entry = 0
    has_mode_extract = 0
    has_clear_call = 0
    has_primary_updates = 0
    has_secondary_updates = 0
    has_delimiter_scan = 0
    has_replace_call = 0
    has_pending_flag = 0
    has_return_branch = 0
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

    if (uline ~ /^ESQIFF2_PARSELINEHEADTAILRECORD:/) has_entry = 1
    if (uline ~ /^MOVE\.B \(A3\),D0$/ || uline ~ /^AND\.L D1,D0$/) has_mode_extract = 1
    if (uline ~ /^BSR\.W ESQIFF2_CLEARLINEHEADTAILBYMODE$/) has_clear_call = 1
    if (uline ~ /^MOVE\.L D0,ESQIFF_PRIMARYLINEHEADPTR$/ || uline ~ /^MOVE\.L D0,ESQIFF_PRIMARYLINETAILPTR$/) has_primary_updates = 1
    if (uline ~ /^MOVE\.L D0,ESQIFF_SECONDARYLINEHEADPTR$/ || uline ~ /^MOVE\.L D0,ESQIFF_SECONDARYLINETAILPTR$/) has_secondary_updates = 1
    if (uline ~ /^\.LOOP_PRIMARY_FIND_DELIMITER:$/ || uline ~ /^\.LOOP_SECONDARY_FIND_DELIMITER:$/) has_delimiter_scan = 1
    if (uline ~ /^BSR\.W ESQPARS_REPLACEOWNEDSTRING$/) has_replace_call = 1
    if (uline ~ /^MOVE\.W #1,ESQDISP_SECONDARYLINEPROMOTEPENDINGFLAG$/) has_pending_flag = 1
    if (uline ~ /^BRA\.[SW] ESQIFF2_PARSELINEHEADTAILRECORD_RETURN$/ || uline ~ /^BNE\.[SW] ESQIFF2_PARSELINEHEADTAILRECORD_RETURN$/ || uline ~ /^JMP ESQIFF2_PARSELINEHEADTAILRECORD_RETURN$/) has_return_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MODE_EXTRACT=" has_mode_extract
    print "HAS_CLEAR_CALL=" has_clear_call
    print "HAS_PRIMARY_UPDATES=" has_primary_updates
    print "HAS_SECONDARY_UPDATES=" has_secondary_updates
    print "HAS_DELIMITER_SCAN=" has_delimiter_scan
    print "HAS_REPLACE_CALL=" has_replace_call
    print "HAS_PENDING_FLAG=" has_pending_flag
    print "HAS_RETURN_BRANCH=" has_return_branch
}
