BEGIN {
    has_entry = 0
    has_move_long_postinc = 0
    has_loop_control = 0
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

    if (uline ~ /^ESQSHARED4_COPYLONGWORDBLOCKDBFLOOP:/ || uline ~ /^ESQSHARED4_COPYLONGWORDBLOCKDBF[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /^MOVE\.L \(A[0-7]\)\+,\(A[0-7]\)\+/ || uline ~ /MOVE\.L .*\(A[0-7]\)\+.*\(A[0-7]\)\+/) has_move_long_postinc = 1
    if (uline ~ /^DBF / || uline ~ /^DBRA / || uline ~ /^SUBQ\.W #(\$)?1,D[0-7]/ || uline ~ /^SUBI\.W #(\$)?1,D[0-7]/ || uline ~ /^CMP\.[WL] / || uline ~ /^CMPI\.[WL] / || uline ~ /^BNE(\.[BWL])? / || uline ~ /^BPL(\.[BWL])? / || uline ~ /^BHI(\.[BWL])? / || uline ~ /^BRA(\.[BWL])? /) has_loop_control = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MOVE_LONG_POSTINC=" has_move_long_postinc
    print "HAS_LOOP_CONTROL=" has_loop_control
    print "HAS_RTS=" has_rts
}
