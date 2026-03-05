BEGIN {
    has_entry = 0
    has_rts = 0
    has_len6 = 0
    has_ff_fastpath = 0
    has_bitloop = 0
    has_bset = 0
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

    if ((l ~ /#\$?6/ || l ~ /#6/ || l ~ /#\$?5/ || l ~ /#5/) && l ~ /^MOVEQ(\.L)? /) has_len6 = 1
    if (l ~ /^DBF D0,/) has_len6 = 1
    if (l ~ /#\$?FF/ || l ~ /^NOT\.B D[0-7]$/) has_ff_fastpath = 1
    if ((l ~ /#\$?8/ || l ~ /#8/ || l ~ /#\$?7/ || l ~ /#7/) && (l ~ /^CMP\.[BW] / || l ~ /^MOVEQ(\.L)? /)) has_bitloop = 1
    if (l ~ /^DBF D2,/) has_bitloop = 1
    if (l ~ /^BSET /) has_bset = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_LEN6=" has_len6
    print "HAS_FF_FASTPATH=" has_ff_fastpath
    print "HAS_BITLOOP=" has_bitloop
    print "HAS_BSET=" has_bset
    print "HAS_CALL=" has_call
}
