BEGIN {
    has_cached_byte = 0
    has_cached_flag = 0
    has_eori_ff = 0
    has_xor = 0
    has_loop = 0
    has_mask_ff = 0
    has_rts = 0
}

function trim(s,    t) {
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

    if (u ~ /ESQIFF_RECORDCHECKSUMBYTE/) has_cached_byte = 1
    if (u ~ /ESQIFF_USECACHEDCHECKSUMFLAG/) has_cached_flag = 1

    if (u ~ /EORI?\.[BWL] #\$?FF,D[0-7]/ || u ~ /#255,D[0-7]/ || u ~ /^NOT\.B D[0-7]$/) has_eori_ff = 1
    if (u ~ /^EOR\.[BWL] D[0-7],D[0-7]$/ || u ~ /^EOR D[0-7],D[0-7]$/) has_xor = 1
    if (u ~ /^DBF / || u ~ /^DBRA / || u ~ /^J(B?NE|EQ|LT|LE|GT|GE) / || u ~ /^B(NE|EQ|LT|LE|GT|GE|PL|MI)/) has_loop = 1
    if (u ~ /ANDI?\.[BWL] #\$?FF,D[0-7]/ || u ~ /#255,D[0-7]/ || u ~ /^MOVE\.B D[0-7],D[0-7]$/) has_mask_ff = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_CACHED_BYTE=" has_cached_byte
    print "HAS_CACHED_FLAG=" has_cached_flag
    print "HAS_EORI_FF=" has_eori_ff
    print "HAS_XOR=" has_xor
    print "HAS_LOOP=" has_loop
    print "HAS_MASK_FF=" has_mask_ff
    print "HAS_RTS=" has_rts
}
