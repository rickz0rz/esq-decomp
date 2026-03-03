BEGIN {
    has_mask_f00 = 0
    has_mask_f0 = 0
    has_mask_0f = 0
    has_shift8 = 0
    has_shift4 = 0
    has_add_100 = 0
    has_add_10 = 0
    has_add_1 = 0
    has_cmp = 0
    has_add_combine = 0
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

    if (u ~ /#\$?F00,D[0-7]/ || u ~ /#3840,D[0-7]/) has_mask_f00 = 1
    if (u ~ /#\$?F0,D[0-7]/ || u ~ /#240,D[0-7]/) has_mask_f0 = 1
    if (u ~ /#\$?F,D[0-7]/ || u ~ /#15,D[0-7]/) has_mask_0f = 1

    if (u ~ /LSL\.[BWL] #8,D[0-7]/ || u ~ /ASL\.[BWL] #8,D[0-7]/) has_shift8 = 1
    if (u ~ /LSL\.[BWL] #4,D[0-7]/ || u ~ /ASL\.[BWL] #4,D[0-7]/) has_shift4 = 1

    if (u ~ /#\$?100,D[0-7]/ || u ~ /#256,D[0-7]/) has_add_100 = 1
    if (u ~ /#\$?10,D[0-7]/ || u ~ /#16,D[0-7]/) has_add_10 = 1
    if (u ~ /ADDI?\.[BWL] #1,D[0-7]/ || u ~ /ADDQ\.[BWL] #1,D[0-7]/ || u ~ /ADDQ #1,D[0-7]/) has_add_1 = 1

    if (u ~ /^CMP\.[BWL] D[0-7],D[0-7]$/ || u ~ /^CMP D[0-7],D[0-7]$/ || u ~ /^CMP\.[BWL] #/ || u ~ /^CMPI\.[BWL] /) has_cmp = 1
    if (u ~ /^ADD\.[BWL] D[0-7],D[0-7]$/ || u ~ /^ADD D[0-7],D[0-7]$/) has_add_combine = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_MASK_F00=" has_mask_f00
    print "HAS_MASK_F0=" has_mask_f0
    print "HAS_MASK_0F=" has_mask_0f
    print "HAS_SHIFT8=" has_shift8
    print "HAS_SHIFT4=" has_shift4
    print "HAS_ADD_100=" has_add_100
    print "HAS_ADD_10=" has_add_10
    print "HAS_ADD_1=" has_add_1
    print "HAS_CMP=" has_cmp
    print "HAS_ADD_COMBINE=" has_add_combine
    print "HAS_RTS=" has_rts
}
