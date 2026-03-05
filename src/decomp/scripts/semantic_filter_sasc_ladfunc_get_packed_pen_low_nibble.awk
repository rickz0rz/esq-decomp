BEGIN {
    has_entry = 0
    has_arg_load = 0
    has_mask_f = 0
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

    if (u ~ /^LADFUNC_GETPACKEDPENLOWNIBBLE:/ || u ~ /^LADFUNC_GETPACKEDPENLOWNIBB[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVE\.B [0-9]+\(A7\),D[0-7]$/ || u ~ /^MOVE\.L D[0-7],D0$/) has_arg_load = 1
    if (u ~ /^ANDI\.B #\$F,D0$/ || u ~ /^AND(\.L|I\.B) / || u ~ /^MOVEQ(\.L)? #\$F,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #15,D[0-7]$/) has_mask_f = 1
    if (u ~ /^MOVE\.L D[0-7],D0$/ || u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ARG_LOAD=" has_arg_load
    print "HAS_MASK_F=" has_mask_f
    print "HAS_RETURN=" has_return
}
