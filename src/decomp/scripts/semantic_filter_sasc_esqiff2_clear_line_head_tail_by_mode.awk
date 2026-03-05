BEGIN {
    has_entry = 0
    has_save = 0
    has_mode_cmp = 0
    has_branch_primary = 0
    has_secondary_head = 0
    has_secondary_tail = 0
    has_primary_head = 0
    has_primary_tail = 0
    has_replace_calls = 0
    has_restore = 0
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
    u = toupper(line)

    if (u ~ /^ESQIFF2_CLEARLINEHEADTAILBYMODE:/ || u ~ /^ESQIFF2_CLEARLINEHEADTAILBYM[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVE\.L D7,-\(A7\)$/ || u ~ /^MOVEM\.L [DA][0-7](\/[DA][0-7])+,-\(A7\)$/) has_save = 1
    if (u ~ /^CMP\.W D0,D7$/ || u ~ /^CMPI\.W #2,D[0-7]$/ || u ~ /^CMPI\.W #\$2,D[0-7]$/ || u ~ /^SUBQ\.W #2,D0$/ || u ~ /^SUBQ\.W #\$2,D0$/) has_mode_cmp = 1
    if (u ~ /^BNE\.[SWB] \.CLEAR_PRIMARY_LINE_HEAD_TAIL$/ || u ~ /^BNE\.[SWB] ___ESQIFF2_CLEARLINEHEADTAILBYM/) has_branch_primary = 1
    if (index(u, "MOVE.L D0,ESQIFF_SECONDARYLINEHEADPTR") > 0 || index(u, "SECONDARYLINEHEADPTR") > 0) has_secondary_head = 1
    if (index(u, "MOVE.L D0,ESQIFF_SECONDARYLINETAILPTR") > 0 || index(u, "SECONDARYLINETAILPTR") > 0) has_secondary_tail = 1
    if (index(u, "MOVE.L D0,ESQIFF_PRIMARYLINEHEADPTR") > 0 || index(u, "PRIMARYLINEHEADPTR") > 0) has_primary_head = 1
    if (index(u, "MOVE.L D0,ESQIFF_PRIMARYLINETAILPTR") > 0 || index(u, "PRIMARYLINETAILPTR") > 0) has_primary_tail = 1
    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "REPLACEOWNEDSTRING") > 0) has_replace_calls++
    if (u ~ /^MOVE\.L \(A7\)\+,D7$/ || u ~ /^MOVEM\.L \(A7\)\+,[DA][0-7].*$/) has_restore = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_MODE_CMP=" has_mode_cmp
    print "HAS_BRANCH_PRIMARY=" has_branch_primary
    print "HAS_SECONDARY_HEAD=" has_secondary_head
    print "HAS_SECONDARY_TAIL=" has_secondary_tail
    print "HAS_PRIMARY_HEAD=" has_primary_head
    print "HAS_PRIMARY_TAIL=" has_primary_tail
    print "HAS_REPLACE_CALLS_GE2=" (has_replace_calls >= 2)
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
