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
    has_stack_guard = 0
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

    if (u ~ /^ESQIFF2_CLEARPRIMARYENTRYFLAGS34TO39:/ || u ~ /^ESQIFF2_CLEARPRIMARYENTRYFLAGS3[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^LINK\.W A5,#-8$/ || u ~ /^LINK\.W A[0-7],#-[0-9]+$/ || u ~ /^LINK\.W A[0-7],#-\$[0-9A-F]+$/) has_link = 1
    if (index(u, "__BASE(A4)") > 0 || index(u, "_XCOVF") > 0) has_stack_guard = 1
    if (u ~ /^MOVEM\.L D6-D7,-\(A7\)$/ || u ~ /^MOVEM\.L [DA][0-7](\/[DA][0-7])+,-\(A7\)$/) has_save = 1
    if (index(u, "TEXTDISP_PRIMARYGROUPENTRYCOUNT") > 0) has_count_load = 1
    if (u ~ /^CMP\.W D0,D7$/ || u ~ /^CMP\.W D[0-7],D[0-7]$/) has_outer_cmp = 1
    if (u ~ /^BGE\.[SWB] ESQIFF2_CLEARPRIMARYENTRYFLAGS34TO39_RETURN$/ || u ~ /^BGE\.[SWB] ___ESQIFF2_CLEARPRIMARYENTRYFLAGS3/ || u ~ /^BCC\.[SWB] ___ESQIFF2_CLEARPRIMARYENTRYFLAGS3/ || u ~ /^BCC\.[SWB] ESQIFF2_CLEARPRIMARYENTRYFLAGS34TO39_RETURN$/) has_ret_branch = 1
    if (index(u, "TEXTDISP_PRIMARYENTRYPTRTABLE") > 0) has_table_lea = 1
    if (u ~ /^CLR\.B 34\(A0,D6\.W\)$/ || u ~ /^CLR\.B \$22\(A5,D0\.L\)$/ || u ~ /^CLR\.B [\$0-9A-F]+\((A[0-7],)?D[0-7]\.[WL]\)$/ || u ~ /^CLR\.B [0-9]+\([A0-7]\)$/) has_inner_clear = 1
    if (u ~ /^ADDQ\.W #1,D6$/ || u ~ /^ADDQ\.W #\$1,D6$/ || u ~ /^ADDQ\.W #1,D[0-7]$/) has_inner_inc = 1
    if (u ~ /^ADDQ\.W #1,D7$/ || u ~ /^ADDQ\.W #\$1,D7$/ || u ~ /^ADDQ\.W #1,D[0-7]$/) has_outer_inc = 1
}

END {
    if (has_stack_guard) has_link = 1

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
