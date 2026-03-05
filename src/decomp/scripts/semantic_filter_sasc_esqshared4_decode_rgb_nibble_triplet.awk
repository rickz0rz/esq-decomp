BEGIN {
    has_entry = 0
    has_load_b0 = 0
    has_load_b1 = 0
    has_load_b2 = 0
    has_mask0f = 0
    has_shift8 = 0
    has_shift4 = 0
    has_add_or_merge = 0
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

    if (uline ~ /^ESQSHARED4_DECODERGBNIBBLETRIPLET:/ || uline ~ /^ESQSHARED4_DECODERGBNIBBLE[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/ || uline ~ /^MOVE\.B \(A[0-7]\),D[0-7]$/) {
        if (!has_load_b0) has_load_b0 = 1
        else if (!has_load_b1) has_load_b1 = 1
        else has_load_b2 = 1
    }
    if (uline ~ /ANDI\.W #(\$)?0?F\b/ || uline ~ /AND\.W #(\$)?0?F\b/ || uline ~ /#15\b/) has_mask0f = 1
    if (uline ~ /LSL\.W #8\b/ || uline ~ /ASL\.W #8\b/) has_shift8 = 1
    if (uline ~ /LSL\.W #4\b/ || uline ~ /ASL\.W #4\b/) has_shift4 = 1
    if (uline ~ /^ADD\.W / || uline ~ /^ADD\.L / || uline ~ /^OR\.W / || uline ~ /^OR\.L /) has_add_or_merge = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD_B0=" has_load_b0
    print "HAS_LOAD_B1=" has_load_b1
    print "HAS_LOAD_B2=" has_load_b2
    print "HAS_MASK_0F=" has_mask0f
    print "HAS_SHIFT_8=" has_shift8
    print "HAS_SHIFT_4=" has_shift4
    print "HAS_ADD_OR_MERGE=" has_add_or_merge
    print "HAS_RTS=" has_rts
}
