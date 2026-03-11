BEGIN {
    has_seed = 0
    has_template = 0
    has_list_a = 0
    has_list_b = 0
    has_add6 = 0
    has_mask_100 = 0
    has_clear_bit8 = 0
    has_rol = 0
    has_loop = 0
    has_off_136_or_140 = 0
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

    if (u ~ /HIGHLIGHT_COPPEREFFECTSEED/) has_seed = 1
    if (u ~ /ESQ_COPPEREFFECTTEMPLATEROWSSET0/) has_template = 1
    if (u ~ /ESQ_COPPEREFFECTLISTA/) has_list_a = 1
    if (u ~ /ESQ_COPPEREFFECTLISTB/) has_list_b = 1

    if (u ~ /#6,A[0-7]/ || u ~ /#\$6,A[0-7]/ || u ~ /#6,D[0-7]/ || u ~ /#6,SP/ || u ~ /ADDQ\.[BWL] #\$?6,A[0-7]/) has_add6 = 1
    if (u ~ /#\$?100,D[0-7]/ || u ~ /#256,D[0-7]/ || u ~ /#\$?100,A[0-7]/ || u ~ /#256,A[0-7]/) has_mask_100 = 1
    if (u ~ /BCLR #8,D[0-7]/ || u ~ /#\$?FEFF,D[0-7]/ || u ~ /#65279,D[0-7]/ || u ~ /#-257,D[0-7]/) has_clear_bit8 = 1

    if (u ~ /^ROL\.[BWL] #/ || u ~ /^ROL\.L #/ || u ~ /^ROR\./ || u ~ /LSL\.[BWL] #5,D[0-7]/ || u ~ /ASL\.L #\$?5,D[0-7]/ || u ~ /ROL32/) has_rol = 1
    if (u ~ /^DBF / || u ~ /^DBRA / || u ~ /^J(B?NE|EQ|LT|LE|GT|GE) / || u ~ /^B(NE|EQ|LT|LE|GT|GE|PL|MI)/) has_loop = 1

    if (u ~ /136\(/ || u ~ /140\(/ || u ~ /#136,/ || u ~ /#140,/ || u ~ /68\(/ || u ~ /70\(/ || u ~ /\(134,/ || u ~ /\(138,/ || u ~ /\(270,/ || u ~ /\(271,/) has_off_136_or_140 = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SEED=" has_seed
    print "HAS_TEMPLATE=" has_template
    print "HAS_LIST_A=" has_list_a
    print "HAS_LIST_B=" has_list_b
    print "HAS_ADD6=" has_add6
    print "HAS_MASK_100=" has_mask_100
    print "HAS_CLEAR_BIT8=" has_clear_bit8
    print "HAS_ROL=" has_rol
    print "HAS_LOOP=" has_loop
    print "HAS_OFF_136_OR_140=" has_off_136_or_140
    print "HAS_RTS=" has_rts
}
