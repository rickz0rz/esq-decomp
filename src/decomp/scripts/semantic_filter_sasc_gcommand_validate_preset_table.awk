BEGIN {
    has_entry = 0
    has_row_bound = 0
    has_count_range = 0
    has_value_bound = 0
    has_disable = 0
    has_copymem = 0
    has_pending_flag = 0
    has_update_bounds = 0
    has_enable = 0
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

    if (u ~ /^GCOMMAND_VALIDATEPRESETTABLE:/ || u ~ /^GCOMMAND_VALIDATEPRESETTABLE[A-Z0-9_]*:/) has_entry = 1

    if (u ~ /^MOVEQ(\.L)? #\$10,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #16,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/) has_row_bound = 1
    if (u ~ /^CMPI\.[WL] #\$?1,/ || u ~ /^CMPI\.[WL] #\$?40,/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/) has_count_range = 1
    if (u ~ /^CMPI\.[WL] #\$?1000,/) has_value_bound = 1

    if (index(u, "_LVODISABLE") > 0 && (u ~ /^JSR / || u ~ /^BSR(\.[A-Z]+)? /)) has_disable = 1
    if (index(u, "_LVOCOPYMEM") > 0 && (u ~ /^JSR / || u ~ /^BSR(\.[A-Z]+)? /)) has_copymem = 1
    if ((index(u, "GCOMMAND_PRESETWORKRESETPENDINGFLAG") > 0 || index(u, "GCOMMAND_PRESETWORKRESETPENDINGF") > 0) && (u ~ /^MOVE\.W / || u ~ /^MOVE\.L /)) has_pending_flag = 1
    if (index(u, "GCOMMAND_UPDATEBANNERBOUNDS") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_update_bounds = 1
    if (index(u, "_LVOENABLE") > 0 && (u ~ /^JSR / || u ~ /^BSR(\.[A-Z]+)? /)) has_enable = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ROW_BOUND=" has_row_bound
    print "HAS_COUNT_RANGE=" has_count_range
    print "HAS_VALUE_BOUND=" has_value_bound
    print "HAS_DISABLE=" has_disable
    print "HAS_COPYMEM=" has_copymem
    print "HAS_PENDING_FLAG=" has_pending_flag
    print "HAS_UPDATE_BOUNDS=" has_update_bounds
    print "HAS_ENABLE=" has_enable
    print "HAS_RETURN=" has_return
}
