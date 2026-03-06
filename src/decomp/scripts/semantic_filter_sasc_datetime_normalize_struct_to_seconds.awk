BEGIN {
    has_adjust_month = 0
    has_is_leap = 0
    has_mulu32 = 0
    has_normalize_month = 0
    has_invalid_ret = 0
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

    if (u ~ /(BSR|JSR).*DATETIME_ADJUSTMONTHINDEX/) has_adjust_month = 1
    if (u ~ /(BSR|JSR).*DATETIME_ISLEAPYEAR/) has_is_leap = 1
    if (u ~ /(BSR|JSR).*MATH_MULU32/) has_mulu32 = 1
    if (u ~ /(BSR|JSR).*DATETIME_NORMALIZEMONTHRANGE/) has_normalize_month = 1
    if (u ~ /MOVEQ(\.L)? #(-1|\$-?1|\$FF),D0/) has_invalid_ret = 1
    if (u ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ADJUST_MONTH=" has_adjust_month
    print "HAS_IS_LEAP=" has_is_leap
    print "HAS_MULU32=" has_mulu32
    print "HAS_NORMALIZE_MONTH=" has_normalize_month
    print "HAS_INVALID_RET=" has_invalid_ret
    print "HAS_RTS=" has_rts
}
