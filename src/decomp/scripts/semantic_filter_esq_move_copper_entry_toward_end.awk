BEGIN {
    has_mask_1f = 0
    has_shift_2 = 0
    has_step_4 = 0
    has_limit_20 = 0
    has_primary_sym = 0
    has_secondary_sym = 0
    has_loop_cmp = 0
    has_branch = 0
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

    if (u ~ /#\$?1F,D[0-7]/ || u ~ /#31,D[0-7]/) has_mask_1f = 1
    if (u ~ /LSL\.[BWL] #2,D[0-7]/ || u ~ /ASL\.[BWL] #2,D[0-7]/) has_shift_2 = 1
    if (u ~ /#\$?20,D[0-7]/ || u ~ /#32,D[0-7]/ || u ~ /#31,D[0-7]/) has_limit_20 = 1
    if (u ~ /#4,D[0-7]/ || u ~ /#-4,D[0-7]/) has_step_4 = 1

    if (u ~ /ESQ_COPPERSTATUSDIGITSA/) has_primary_sym = 1
    if (u ~ /ESQ_COPPERSTATUSDIGITSB/) has_secondary_sym = 1

    if (u ~ /^CMP\.[BWL] D[0-7],D[0-7]$/ || u ~ /^CMP D[0-7],D[0-7]$/) has_loop_cmp = 1
    if (u ~ /^B(MI|PL|GE|GT|LE|LT|EQ|NE|RA|SR)/ || u ~ /^J(EQ|NE|LT|LE|GT|GE) /) has_branch = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_MASK_1F=" has_mask_1f
    print "HAS_SHIFT_2=" has_shift_2
    print "HAS_STEP_4=" has_step_4
    print "HAS_LIMIT_20=" has_limit_20
    print "HAS_PRIMARY_SYM=" has_primary_sym
    print "HAS_SECONDARY_SYM=" has_secondary_sym
    print "HAS_LOOP_CMP=" has_loop_cmp
    print "HAS_BRANCH=" has_branch
    print "HAS_RTS=" has_rts
}
