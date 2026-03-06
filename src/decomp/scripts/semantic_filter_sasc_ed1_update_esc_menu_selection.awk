BEGIN {
    has_index_math = 0
    has_table_load = 0
    has_save_key = 0
    has_cmp_31 = 0
    has_bottom_help_call = 0
    has_clear_diag = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = trim($0)
    if (l == "") next

    if (l ~ /^LSL\.L #\$?2,D0$/ || l ~ /^ASL\.L #\$?2,D[01]$/ || l ~ /^ADD\.L ED_STATERINGINDEX(\(A4\))?,D[01]$/ || l ~ /^MULU\.W #\$?5,D0$/) has_index_math = 1
    if (l ~ /^MOVE\.B \(A0\),D[07]$/ || l ~ /^MOVE\.B 0\(A0\),D[07]$/ || l ~ /^MOVE\.B \$0\(A0,D[01]\.L\),D[07]$/) has_table_load = 1
    if (l ~ /^MOVE\.B D[07],ED_LASTKEYCODE(\(A[0-7]\))?$/) has_save_key = 1
    if (l ~ /^SUBI\.W #\$?31,D[01]$/ || l ~ /^CMPI\.B #\$?31,D0$/ || l ~ /^CMP\.B #\$?31,D0$/) has_cmp_31 = 1
    if (l ~ /(JSR|BSR).*ED_DRAWESCMENUBOTTOMHELP/) has_bottom_help_call = 1
    if (l ~ /^CLR\.W ED_DIAGNOSTICSSCREENACTIVE(\(A[0-7]\))?$/ || l ~ /^MOVE\.W #\$?0,ED_DIAGNOSTICSSCREENACTIVE(\(A[0-7]\))?$/) has_clear_diag = 1
    if (l == "RTS") has_rts = 1
}

END {
    print "HAS_INDEX_MATH=" has_index_math
    print "HAS_TABLE_LOAD=" has_table_load
    print "HAS_SAVE_KEY=" has_save_key
    print "HAS_CMP_31=" has_cmp_31
    print "HAS_BOTTOM_HELP_CALL=" has_bottom_help_call
    print "HAS_CLEAR_DIAG=" has_clear_diag
    print "HAS_RTS=" has_rts
}
