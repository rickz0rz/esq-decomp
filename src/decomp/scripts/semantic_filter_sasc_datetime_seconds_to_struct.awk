BEGIN {
    has_divs32 = 0
    has_divu32 = 0
    has_mulu32 = 0
    has_is_leap = 0
    has_normalize_month = 0
    has_feb29_path = 0
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

    if (u ~ /(BSR|JSR).*MATH_DIVS32/) has_divs32 = 1
    if (u ~ /(BSR|JSR).*MATH_DIVU32/) has_divu32 = 1
    if (u ~ /(BSR|JSR).*MATH_MULU32/) has_mulu32 = 1
    if (u ~ /(BSR|JSR).*DATETIME_ISLEAPYEAR/) has_is_leap = 1
    if (u ~ /(BSR|JSR).*DATETIME_NORMALIZEMONTHRANGE/) has_normalize_month = 1
    if (u ~ /MOVE\\.W #\\$1D,4\\(A3\\)/ || u ~ /MOVE\\.W #29,4\\(A[0-7]\\)/) has_feb29_path = 1
    if (u ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_DIVS32=" has_divs32
    print "HAS_DIVU32=" has_divu32
    print "HAS_MULU32=" has_mulu32
    print "HAS_IS_LEAP=" has_is_leap
    print "HAS_NORMALIZE_MONTH=" has_normalize_month
    print "HAS_FEB29_PATH=" has_feb29_path
    print "HAS_RTS=" has_rts
}
