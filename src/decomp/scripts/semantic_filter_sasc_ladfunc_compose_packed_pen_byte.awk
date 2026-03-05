BEGIN {
    has_entry = 0
    has_arg_load = 0
    has_low_mask = 0
    has_shift4 = 0
    has_or = 0
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

    if (u ~ /^LADFUNC_COMPOSEPACKEDPENBYTE:/ || u ~ /^LADFUNC_COMPOSEPACKEDPENBY[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVE\.B [0-9]+\(A7\),D[0-7]$/ || u ~ /^MOVE\.L D[0-7],D[0-7]$/) has_arg_load = 1
    if (u ~ /^MOVEQ(\.L)? #15,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$F,D[0-7]$/ || u ~ /^AND(\.L|I\.B) /) has_low_mask = 1
    if (u ~ /^ASL\.L #4,D[0-7]$/ || u ~ /^ASL\.L #\$4,D[0-7]$/) has_shift4 = 1
    if (u ~ /^OR\.L D[0-7],D0$/ || u ~ /^OR\.L D[0-7],D[0-7]$/) has_or = 1
    if (u ~ /^MOVE\.L D[0-7],D0$/ || u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ARG_LOAD=" has_arg_load
    print "HAS_LOW_MASK=" has_low_mask
    print "HAS_SHIFT4=" has_shift4
    print "HAS_OR=" has_or
    print "HAS_RETURN=" has_return
}
