BEGIN {
    has_entry = 0
    has_save = 0
    has_lea = 0
    has_zero = 0
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

    if (uline ~ /^LOCAVAIL2_AUTOREQUESTNOOP:/) has_entry = 1
    if (uline ~ /^MOVE\.L A4,-\(A7\)$/) has_save = 1
    if (uline ~ /^LEA GLOBAL_REF_LONG_FILE_SCRATCH,A4$/) has_lea = 1
    if (uline ~ /^MOVEQ #0,D0$/) has_zero = 1
    if (uline ~ /^MOVEA\.L \(A7\)\+,A4$/) has_restore = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_LEA=" has_lea
    print "HAS_ZERO=" has_zero
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
