BEGIN {
    saw_find_char = 0
    saw_copy_pad = 0
    saw_parse_year_day = 0
    saw_year_store = 0
    saw_day_store = 0
    saw_cache_year = 0
    saw_leap_check = 0
    saw_hour_parse = 0
    saw_minute_parse = 0
    saw_normalize_month = 0
    saw_normalize_seconds = 0
    saw_seconds_to_struct = 0
    saw_fail_clear = 0
    saw_success = 0
    saw_return = 0
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

    if (u ~ /STR_FINDCHARPTR/) saw_find_char = 1
    if (u ~ /STRING_COPYPADNUL/) saw_copy_pad = 1
    if (u ~ /PARSE_READSIGNEDLONGSKIPCLASS3_A/ || u ~ /PARSE_READSIGNEDLONGSKIPCLASS3_ALT/) saw_parse_year_day = 1
    if (u ~ /MOVE\.W .*6\(A3\)/ || u ~ /W\(OUTSTRUCT, 6\)/ || u ~ /LEA \$6\(A5\),A0/) saw_year_store = 1
    if (u ~ /MOVE\.W .*16\(A3\)/ || u ~ /W\(OUTSTRUCT, 16\)/ || u ~ /LEA \$10\(A5\),A0/) saw_day_store = 1
    if (u ~ /CLOCK_CACHEYEAR/) saw_cache_year = 1
    if (u ~ /DATETIME_ISLEAPYEAR/) saw_leap_check = 1
    if (u ~ /MOVE\.W .*8\(A3\)/ || u ~ /W\(OUTSTRUCT, 8\)/ || u ~ /LEA \$8\(A5\),A0/) saw_hour_parse = 1
    if (u ~ /MOVE\.W .*10\(A3\)/ || u ~ /W\(OUTSTRUCT, 10\)/ || u ~ /LEA \$A\(A5\),A0/) saw_minute_parse = 1
    if (u ~ /DATETIME_NORMALIZEMONTHRANGE/) saw_normalize_month = 1
    if (u ~ /DATETIME_NORMALIZESTRUCTTOSECOND/ || u ~ /DATETIME_NORMALIZESTRUCTTOSECONDS/) saw_normalize_seconds = 1
    if (u ~ /DATETIME_SECONDSTOSTRUCT/) saw_seconds_to_struct = 1
    if (u ~ /CLEAR_ON_FAIL_LOOP/ || u ~ /CLR\.B .*A2,D0\.W/ || u ~ /MOVE\.B D1,\(A0\)\+/ || u ~ /OUTBYTES\[INDEX\] = 0/) saw_fail_clear = 1
    if (u ~ /MOVEQ(\.L)? #(\$)?1,D[05]/ || u ~ /SUCCESS = 1/) saw_success = 1
    if (u ~ /^RTS$/) saw_return = 1
}

END {
    print "HAS_FIND_CHAR=" saw_find_char
    print "HAS_COPY_PAD=" saw_copy_pad
    print "HAS_PARSE_YEAR_DAY=" saw_parse_year_day
    print "HAS_YEAR_STORE=" saw_year_store
    print "HAS_DAY_STORE=" saw_day_store
    print "HAS_CLOCK_CACHE_YEAR=" saw_cache_year
    print "HAS_LEAP_CHECK=" saw_leap_check
    print "HAS_HOUR_PARSE=" saw_hour_parse
    print "HAS_MINUTE_PARSE=" saw_minute_parse
    print "HAS_NORMALIZE_MONTH=" saw_normalize_month
    print "HAS_NORMALIZE_SECONDS=" saw_normalize_seconds
    print "HAS_SECONDS_TO_STRUCT=" saw_seconds_to_struct
    print "HAS_FAIL_CLEAR=" saw_fail_clear
    print "HAS_SUCCESS=" saw_success
    print "HAS_RTS=" saw_return
}
