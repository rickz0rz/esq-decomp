BEGIN {
    has_wildcard_call = 0
    has_normalize_call = 0
    has_copy_pad_call = 0
    has_parse_long_call = 0
    has_mulu_call = 0
    has_mode_counter_store = 0
    has_status_pattern_ref = 0
    has_status_entry_ref = 0
    has_clock_day_ref = 0
    has_clock_year_ref = 0
    has_plus_const = 0
    has_question_const = 0
    has_neg999_const = 0
    has_stride20_const = 0
    has_sentinel_12 = 0
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

    if (u ~ /UNKNOWN_JMPTBL_ESQ_WILDCARDMATCH/) has_wildcard_call = 1
    if (u ~ /UNKNOWN_JMPTBL_DST_NORMALIZEDAYOFYEAR/) has_normalize_call = 1
    if (u ~ /STRING_COPYPADNUL/) has_copy_pad_call = 1
    if (u ~ /PARSE_READSIGNEDLONGSKIPCLASS3_ALT/) has_parse_long_call = 1
    if (u ~ /MATH_MULU32/ || u ~ /STATUS_ENTRY_PTR/) has_mulu_call = 1

    if (u ~ /TLIBA1_DAYENTRYMODECOUNTER/) has_mode_counter_store = 1
    if (u ~ /WDISP_STATUSLISTMATCHPATTERN/) has_status_pattern_ref = 1
    if (u ~ /WDISP_STATUSDAYENTRY0/ || u ~ /STATUS_ENTRY_PTR/) has_status_entry_ref = 1
    if (u ~ /CLOCK_CURRENTDAYOFYEAR/) has_clock_day_ref = 1
    if (u ~ /CLOCK_CURRENTYEARVALUE/) has_clock_year_ref = 1

    if (u ~ /#43/ || u ~ /#\+\'/) has_plus_const = 1
    if (u ~ /#63/ || u ~ /#\?\'/) has_question_const = 1
    if (u ~ /#-999/ || u ~ /#\(-999\)/) has_neg999_const = 1
    if (u ~ /#20/ || u ~ /STATUS_ENTRY_PTR/) has_stride20_const = 1
    if (u ~ /#18/ || u ~ /#\$12/ || u ~ /COPY_LABEL_0X12/) has_sentinel_12 = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_WILDCARD_CALL=" has_wildcard_call
    print "HAS_NORMALIZE_CALL=" has_normalize_call
    print "HAS_COPY_PAD_CALL=" has_copy_pad_call
    print "HAS_PARSE_LONG_CALL=" has_parse_long_call
    print "HAS_MULU_CALL=" has_mulu_call
    print "HAS_MODE_COUNTER_STORE=" has_mode_counter_store
    print "HAS_STATUS_PATTERN_REF=" has_status_pattern_ref
    print "HAS_STATUS_ENTRY_REF=" has_status_entry_ref
    print "HAS_CLOCK_DAY_REF=" has_clock_day_ref
    print "HAS_CLOCK_YEAR_REF=" has_clock_year_ref
    print "HAS_PLUS_CONST=" has_plus_const
    print "HAS_QUESTION_CONST=" has_question_const
    print "HAS_NEG999_CONST=" has_neg999_const
    print "HAS_STRIDE20_CONST=" has_stride20_const
    print "HAS_SENTINEL_12=" has_sentinel_12
    print "HAS_RTS=" has_rts
}
