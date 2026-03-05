BEGIN {
    has_entry = 0
    has_rts = 0
    has_table = 0
    has_alt_table = 0
    has_sub_monthlen = 0
    has_inc_month = 0
    has_store_month = 0
    has_store_day = 0
    has_call = 0
}

function up(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = up($0)
    if (l == "") next

    if (ENTRY != "" && l == toupper(ENTRY) ":") has_entry = 1
    if (l == "RTS") has_rts = 1

    if (index(l, "CLOCK_MONTHLENGTHS") > 0) has_table = 1
    if (l ~ /#\$?18/ || l ~ /#24/) has_alt_table = 1
    if (l ~ /^SUB\.W D[0-7],D[0-7]$/ || l ~ /^SUB\.W [0-9]+\(A[0-7]\),D[0-7]$/) has_sub_monthlen = 1
    if (l ~ /^ADDQ\.W #\$?1,D[0-7]$/ || l ~ /^ADDQ\.W #1,D[0-7]$/) has_inc_month = 1
    if (l ~ /^MOVE\.W D[0-7],2\(A[0-7]\)$/ || l ~ /\$2\(A[0-7]\)/) has_store_month = 1
    if (l ~ /^MOVE\.W D[0-7],4\(A[0-7]\)$/ || l ~ /\$4\(A[0-7]\)/) has_store_day = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_TABLE=" has_table
    print "HAS_ALT_TABLE=" has_alt_table
    print "HAS_SUB_MONTHLEN=" has_sub_monthlen
    print "HAS_INC_MONTH=" has_inc_month
    print "HAS_STORE_MONTH=" has_store_month
    print "HAS_STORE_DAY=" has_store_day
    print "HAS_CALL=" has_call
}
