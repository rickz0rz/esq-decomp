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
    u = toupper(line)

    if (u ~ /^ESQIFF2_PARSELINEHEADTAILRECORD:/ || u ~ /^ESQIFF2_PARSELINEHEADTAILREC[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVE\.B \(A3\),D0$/ || u ~ /^AND\.L D1,D0$/ || u ~ /^AND\.W #\$FF,D[0-7]$/ || u ~ /^MOVEQ\.L #\$FF,D[0-7]$/) has_mode_extract = 1
    if (index(u, "ESQIFF2_CLEARLINEHEADTAILBYMODE") > 0 || index(u, "CLEARLINEHEADTAILBYMODE") > 0) has_clear_call = 1
    if (index(u, "ESQIFF_PRIMARYLINEHEADPTR") > 0 || index(u, "ESQIFF_PRIMARYLINETAILPTR") > 0) has_primary_updates = 1
    if (index(u, "ESQIFF_SECONDARYLINEHEADPTR") > 0 || index(u, "ESQIFF_SECONDARYLINETAILPTR") > 0) has_secondary_updates = 1
    if (index(u, "LOOP_PRIMARY_FIND_DELIMITER") > 0 || index(u, "LOOP_SECONDARY_FIND_DELIMITER") > 0 || u ~ /^CMP\.W #103,D[0-7]$/ || u ~ /^CMP\.W #\$67,D[0-7]$/ || u ~ /^MOVEQ\.L #\$67,D[0-7]$/ || u ~ /^CMP\.W D[0-7],D[0-7]$/ || u ~ /^ADDQ\.W #\$1,D5$/ || u ~ /^ADDQ\.W #1,D5$/) has_delimiter_scan = 1
    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "REPLACEOWNEDSTRING") > 0) has_replace_call = 1
    if (index(u, "ESQDISP_SECONDARYLINEPROMOTEPENDINGFLAG") > 0 || index(u, "SECONDARYLINEPROMOTEPENDINGFLAG") > 0 || index(u, "SECONDARYLINEPROMOTEPEND") > 0) has_pending_flag = 1
    if (u ~ /^BRA\.[SWB] ESQIFF2_PARSELINEHEADTAILRECORD_RETURN$/ || u ~ /^BNE\.[SWB] ESQIFF2_PARSELINEHEADTAILRECORD_RETURN$/ || u ~ /^JMP ESQIFF2_PARSELINEHEADTAILRECORD_RETURN$/ || u ~ /^BRA\.[SWB] ___ESQIFF2_PARSELINEHEADTAILREC/ || u ~ /^BNE\.[SWB] ___ESQIFF2_PARSELINEHEADTAILREC/) has_return_branch = 1
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
