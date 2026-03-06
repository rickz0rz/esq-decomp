BEGIN {
    normalize_calls = 0
    copy_ops = 0
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

    if (u ~ /^(BSR|JSR)\\..*DATETIME_NORMALIZESTRUCTTOSECOND/ || u ~ /^(BSR|JSR) .*DATETIME_NORMALIZESTRUCTTOSECOND/) normalize_calls++
    if (u ~ /MOVE\\.B \\(A[0-7]\\)\\+,\\(A[0-7]\\)\\+/) copy_ops++
    if (u ~ /^RTS$/) saw_return = 1
}

END {
    print "NORMALIZE_CALL_COUNT=" normalize_calls
    print "HAS_COPY_BYTE_MOVE=" (copy_ops > 0 ? 1 : 0)
    print "HAS_RTS=" saw_return
}
