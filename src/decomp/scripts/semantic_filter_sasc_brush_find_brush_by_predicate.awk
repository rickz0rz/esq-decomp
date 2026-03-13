BEGIN {
    has_entry = 0
    has_compare_call = 0
    has_next_368 = 0
    has_zero_match_check = 0
    has_null_return = 0
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

    if (ENTRY != "" && u == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_REGEX != "" && u ~ toupper(ENTRY_REGEX)) has_entry = 1

    if (u ~ /GROUP_AA_JMPTBL_STRING_COMPARENOCASE/ || u ~ /_GROUP_AA_JMPTBL_STRING_COMPARENOCASE/ || u ~ /GROUP_AA_JMPTBL_STRING_COMPARENO/ || u ~ /_GROUP_AA_JMPTBL_STRING_COMPARENO/ || u ~ /BSR\.[BWL]? _GROUP_AA_JMPTBL_STRING_COMPARENOCASE/ || u ~ /BSR\.[BWL]? _GROUP_AA_JMPTBL_STRING_COMPARENO/ || u ~ /JSR .*GROUP_AA_JMPTBL_STRING_COMPARENOCASE/ || u ~ /JSR .*GROUP_AA_JMPTBL_STRING_COMPARENO/ || u ~ /STRING_COMPARENOCASE/ || u ~ /_STRING_COMPARENOCASE/ || u ~ /BSR\.[BWL]? _STRING_COMPARENOCASE/ || u ~ /JSR .*STRING_COMPARENOCASE/) {
        has_compare_call = 1
    }

    if (u ~ /368\(/ || u ~ /\(368,/ || u ~ /#\$170/ || u ~ /#368/ || u ~ /\$170\([AD][0-7]\)/) {
        has_next_368 = 1
    }

    if (u ~ /TST\.L D0/ || u ~ /CMPI\.L #0,D0/ || u ~ /CMP\.L #0,D0/ || u ~ /BEQ/ || u ~ /JEQ/) {
        has_zero_match_check = 1
    }

    if (u ~ /MOVEQ(\.L)? #0,D0/ || u ~ /MOVEQ(\.L)? #\$0,D0/ || u ~ /CLR\.L D0/ || u ~ /SUBA\.L A0,A0/ || u ~ /SUB\.L A0,A0/) {
        has_null_return = 1
    }

    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_COMPARE_CALL=" has_compare_call
    print "HAS_NEXT_OFFSET_368=" has_next_368
    print "HAS_ZERO_MATCH_CHECK=" has_zero_match_check
    print "HAS_NULL_RETURN=" has_null_return
    print "HAS_RTS=" has_rts
}
