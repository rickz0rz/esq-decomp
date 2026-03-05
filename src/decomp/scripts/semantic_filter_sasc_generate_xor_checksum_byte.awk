BEGIN {
    has_entry = 0
    has_rts = 0
    has_cached_flag_check = 0
    has_seed_invert = 0
    has_xor_loop = 0
    has_mask_ff = 0
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

    if (index(l, "USECACHEDCHECKSUMFLAG") > 0 || l ~ /^TST\.[BW] D[0-7]$/) has_cached_flag_check = 1
    if (l ~ /EORI\.[BWL] #\$?FF,D[0-7]/ || l ~ /^NOT\.B D[0-7]$/) has_seed_invert = 1
    if (l ~ /^EOR\.[BWL] D[0-7],D[0-7]$/) has_xor_loop = 1
    if (l ~ /ANDI\.[BWL] #\$?FF,D[0-7]/ || l ~ /^AND\.[BWL] D[0-7],D[0-7]$/) has_mask_ff = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_CACHED_FLAG_CHECK=" has_cached_flag_check
    print "HAS_SEED_INVERT=" has_seed_invert
    print "HAS_XOR_LOOP=" has_xor_loop
    print "HAS_MASK_FF=" has_mask_ff
    print "HAS_CALL=" has_call
}
