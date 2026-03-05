BEGIN {
    has_entry = 0
    has_rts = 0
    has_mask_f00 = 0
    has_mask_f0 = 0
    has_mask_f = 0
    has_shift8 = 0
    has_shift4 = 0
    has_add_100 = 0
    has_add_10 = 0
    has_add_1 = 0
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

    if (l ~ /#\$?F00/) has_mask_f00 = 1
    if (l ~ /#\$?F0/ && l !~ /F00/) has_mask_f0 = 1
    if (l ~ /#\$?F( |,|$)/ || l ~ /#15/) has_mask_f = 1
    if (l ~ /#\$?8/ && (l ~ /^ASL\.[BW] / || l ~ /^LSL\.[BW] /)) has_shift8 = 1
    if (l ~ /#\$?4/ && (l ~ /^ASL\.[BW] / || l ~ /^LSL\.[BW] /)) has_shift4 = 1
    if (l ~ /#\$?100/ || l ~ /#256/) has_add_100 = 1
    if (l ~ /#\$?10/ || l ~ /#16/) has_add_10 = 1
    if (l ~ /#\$?1( |,|$)/ || l ~ /#1/) has_add_1 = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_MASK_F00=" has_mask_f00
    print "HAS_MASK_F0=" has_mask_f0
    print "HAS_MASK_F=" has_mask_f
    print "HAS_SHIFT8=" has_shift8
    print "HAS_SHIFT4=" has_shift4
    print "HAS_ADD_100=" has_add_100
    print "HAS_ADD_10=" has_add_10
    print "HAS_ADD_1=" has_add_1
    print "HAS_CALL=" has_call
}
