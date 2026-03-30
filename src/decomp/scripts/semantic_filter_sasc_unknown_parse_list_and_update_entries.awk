BEGIN {
    wildcard_calls = 0
    normalize_calls = 0
    copy_pad_calls = 0
    parse_long_calls = 0
    direct_mulu_calls = 0
    entry_ptr_calls = 0
    mode_counter_store = 0
    status_pattern_ref = 0
    status_entry_ref = 0
    clock_day_ref = 0
    clock_year_ref = 0
    plus_const = 0
    question_const = 0
    neg999_const = 0
    sentinel_12 = 0
    skip_advance7 = 0
    field1_store = 0
    field2_store = 0
    field3_store = 0
    inactive_set = 0
    inactive_clear = 0
    return_zero = 0
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

    if (u ~ /^(XREF|XDEF|END)( |$)/) next

    if (u ~ /^(JSR|BSR(\.W)?) .*UNKNOWN_JMPTBL_ESQ_WILDCARDMATCH/ || u ~ /^(JSR|BSR(\.W)?) .*ESQ_WILDCARDMATCH/) wildcard_calls++
    if (u ~ /^(JSR|BSR(\.W)?) .*UNKNOWN_JMPTBL_DST_NORMALIZEDAYO/ || u ~ /^(JSR|BSR(\.W)?) .*UNKNOWN_JMPTBL_DST_NORMALIZEDAYOFYEAR/ || u ~ /^(JSR|BSR(\.W)?) .*DST_NORMALIZEDAYO/ || u ~ /^(JSR|BSR(\.W)?) .*DST_NORMALIZEDAYOFYEAR/) normalize_calls++
    if (u ~ /^(JSR|BSR(\.W)?) .*STRING_COPYPADNUL/) copy_pad_calls++
    if (u ~ /^(JSR|BSR(\.W)?) .*PARSE_READSIGNEDLONGSKIPCLASS3_A/ || u ~ /^(JSR|BSR(\.W)?) .*PARSE_READSIGNEDLONGSKIPCLASS3_ALT/) parse_long_calls++
    if (u ~ /^(JSR|BSR(\.W)?) .*MATH_MULU32/) direct_mulu_calls++
    if (u ~ /^(JSR|BSR(\.W)?) .*STATUS_DAY_ENTRY_PTR/) entry_ptr_calls++

    if (u ~ /TLIBA1_DAYENTRYMODECOUNTER/) mode_counter_store = 1
    if (u ~ /WDISP_STATUSLISTMATCHPATTERN/) status_pattern_ref = 1
    if (u ~ /WDISP_STATUSDAYENTRY0/ || u ~ /STATUS_DAY_ENTRY_PTR/) status_entry_ref = 1
    if (u ~ /CLOCK_CURRENTDAYOFYEAR/) clock_day_ref = 1
    if (u ~ /CLOCK_CURRENTYEARVALUE/) clock_year_ref = 1

    if (u ~ /#43/ || u ~ /#\$2B/ || u ~ /#\+'\''/) plus_const = 1
    if (u ~ /#63/ || u ~ /#\$3F/ || u ~ /#\?'\''/) question_const = 1
    if (u ~ /-999/ || u ~ /#-999/ || u ~ /#\$FFFFFC19/) neg999_const = 1
    if (u ~ /#18/ || u ~ /#\$12/ || u ~ /COPY_LABEL_0X12/) sentinel_12 = 1

    if (u ~ /^ADDQ\.L #7,A[23]$/ || u ~ /^ADDQ\.L #\$7,A[23]$/) skip_advance7 = 1
    if (u ~ /MOVE\.L D0,4\(A[01]\)$/ || u ~ /MOVE\.L D0,\$4\(A0\)$/ || u ~ /MOVEQ(\.L)? #\$1,D0/ || u ~ /MOVEQ #1,D0/) field1_store = 1
    if (u ~ /MOVE\.L D0,8\(A[01]\)$/ || u ~ /MOVE\.L \$24\(A7\),\$8\(A0\)$/ || u ~ /MOVE\.L #\(-999\),8\(A1\)/) field2_store = 1
    if (u ~ /MOVE\.L D0,12\(A[01]\)$/ || u ~ /MOVE\.L \$24\(A7\),\$C\(A0\)$/ || u ~ /MOVE\.L #\(-999\),12\(A1\)/) field3_store = 1
    if (u ~ /MOVE\.L D1,16\(A1\)$/ || u ~ /MOVE\.L D3,\$10\(A0\)$/) inactive_set = 1
    if (u ~ /^CLR\.L 16\(A0\)$/ || u ~ /^CLR\.L \$10\(A0\)$/) inactive_clear = 1
    if (u ~ /^MOVEQ(\.L)? #\$0,D0$/ || u ~ /^MOVEQ #0,D0$/) return_zero = 1
    if (u ~ /^RTS$/) has_rts = 1
}

END {
    print "WILDCARD_CALLS=" wildcard_calls
    print "NORMALIZE_CALLS=" normalize_calls
    print "COPY_PAD_CALLS=" copy_pad_calls
    print "PARSE_LONG_CALLS=" parse_long_calls
    print "ENTRY_ADDRESS_RESOLUTION=" ((direct_mulu_calls + entry_ptr_calls) > 0 ? 1 : 0)
    print "MODE_COUNTER_STORE=" mode_counter_store
    print "STATUS_PATTERN_REF=" status_pattern_ref
    print "STATUS_ENTRY_REF=" status_entry_ref
    print "CLOCK_DAY_REF=" clock_day_ref
    print "CLOCK_YEAR_REF=" clock_year_ref
    print "PLUS_CONST=" plus_const
    print "QUESTION_CONST=" question_const
    print "NEG999_CONST=" neg999_const
    print "SENTINEL_12=" sentinel_12
    print "SKIP_ADVANCE7=" skip_advance7
    print "FIELD1_STORE=" field1_store
    print "FIELD2_STORE=" field2_store
    print "FIELD3_STORE=" field3_store
    print "INACTIVE_SET=" inactive_set
    print "INACTIVE_CLEAR=" inactive_clear
    print "RETURN_ZERO=" return_zero
    print "HAS_RTS=" has_rts
}
