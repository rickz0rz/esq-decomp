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
    uline = toupper(line)

    if (uline ~ /^ESQIFF2_CLEARLINEHEADTAILBYMODE:/) has_entry = 1
    if (uline ~ /^MOVE\.L D7,-\(A7\)$/) has_save = 1
    if (uline ~ /^CMP\.W D0,D7$/) has_mode_cmp = 1
    if (uline ~ /^BNE\.[SW] \.CLEAR_PRIMARY_LINE_HEAD_TAIL$/) has_branch_primary = 1
    if (uline ~ /^MOVE\.L D0,ESQIFF_SECONDARYLINEHEADPTR$/) has_secondary_head = 1
    if (uline ~ /^MOVE\.L D0,ESQIFF_SECONDARYLINETAILPTR$/) has_secondary_tail = 1
    if (uline ~ /^MOVE\.L D0,ESQIFF_PRIMARYLINEHEADPTR$/) has_primary_head = 1
    if (uline ~ /^MOVE\.L D0,ESQIFF_PRIMARYLINETAILPTR$/) has_primary_tail = 1
    if (uline ~ /^BSR\.[WL] ESQPARS_REPLACEOWNEDSTRING$/) has_replace_calls++
    if (uline ~ /^MOVE\.L \(A7\)\+,D7$/) has_restore = 1
    if (uline ~ /^RTS$/) has_rts = 1
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
