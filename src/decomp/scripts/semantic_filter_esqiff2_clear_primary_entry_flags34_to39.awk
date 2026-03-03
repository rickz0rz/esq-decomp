BEGIN {
    has_entry = 0
    has_link = 0
    has_save = 0
    has_count_load = 0
    has_outer_cmp = 0
    has_ret_branch = 0
    has_table_lea = 0
    has_inner_clear = 0
    has_inner_inc = 0
    has_outer_inc = 0
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

    if (uline ~ /^ESQIFF2_CLEARPRIMARYENTRYFLAGS34TO39:/) has_entry = 1
    if (uline ~ /^LINK\.W A5,#-8$/) has_link = 1
    if (uline ~ /^MOVEM\.L D6-D7,-\(A7\)$/) has_save = 1
    if (uline ~ /^MOVE\.W TEXTDISP_PRIMARYGROUPENTRYCOUNT,D0$/) has_count_load = 1
    if (uline ~ /^CMP\.W D0,D7$/) has_outer_cmp = 1
    if (uline ~ /^BGE\.[SW] ESQIFF2_CLEARPRIMARYENTRYFLAGS34TO39_RETURN$/) has_ret_branch = 1
    if (uline ~ /^LEA TEXTDISP_PRIMARYENTRYPTRTABLE,A0$/) has_table_lea = 1
    if (uline ~ /^CLR\.B 34\(A0,D6\.W\)$/) has_inner_clear = 1
    if (uline ~ /^ADDQ\.W #1,D6$/) has_inner_inc = 1
    if (uline ~ /^ADDQ\.W #1,D7$/) has_outer_inc = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_COUNT_LOAD=" has_count_load
    print "HAS_OUTER_CMP=" has_outer_cmp
    print "HAS_RET_BRANCH=" has_ret_branch
    print "HAS_TABLE_LEA=" has_table_lea
    print "HAS_INNER_CLEAR=" has_inner_clear
    print "HAS_INNER_INC=" has_inner_inc
    print "HAS_OUTER_INC=" has_outer_inc
}
