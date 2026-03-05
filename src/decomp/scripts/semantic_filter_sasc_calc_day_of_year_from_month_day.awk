BEGIN {
    has_entry = 0
    has_rts = 0
    has_table = 0
    has_alt_table = 0
    has_sum_loop = 0
    has_add_day = 0
    has_store_doy = 0
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
    if (l ~ /^ADD\.W .*\(A[0-7],D[0-7]\.L\),D[0-7]$/ || l ~ /^ADD\.W \(A[0-7]\)\+,D[0-7]$/) has_sum_loop = 1
    if (l ~ /^ADD\.W D[0-7],D[0-7]$/ || l ~ /^ADD\.W [0-9]+\(A[0-7]\),D[0-7]$/) has_add_day = 1
    if (l ~ /^MOVE\.W D[0-7],\(A[0-7]\)$/ || l ~ /^MOVE\.W D[0-7],[0-9]+\(A[0-7]\)$/ || l ~ /\$10\(A[0-7]\)/) has_store_doy = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_TABLE=" has_table
    print "HAS_ALT_TABLE=" has_alt_table
    print "HAS_SUM_LOOP=" has_sum_loop
    print "HAS_ADD_DAY=" has_add_day
    print "HAS_STORE_DOY=" has_store_doy
    print "HAS_CALL=" has_call
}
