BEGIN {
    call_norm = 0
    call_store = 0
    c_hour = 0
    c_min = 0
    mul = 0
    add = 0
    has_rts_or_jmp = 0
    shift_mul_path = 0
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

    if (u ~ /DATETIME_NORMALIZESTRUCTTOSECONDS|DATETIME_NORMALIZESTRUCTTOSECOND/) call_norm = 1
    if (u ~ /DATETIME_SECONDSTOSTRUCT/) call_store = 1
    if (u ~ /#\$E10|#3600|0X0E10/) c_hour = 1
    if (u ~ /#\$3C|#60|0X3C/) c_min = 1
    if (u ~ /^MULS / || u ~ /^MULS\.W / || u ~ /^MULS\.L /) mul = 1
    if (u ~ /^ASL\.L #\$4,D[01]$/ || u ~ /^ASL\.L #4,D[01]$/ || u ~ /^ASL\.L #\$2,D0$/ || u ~ /^ASL\.L #2,D0$/ || u ~ /^SUB\.L D[067],D[01]$/) shift_mul_path = 1
    if (shift_mul_path) mul = 1
    if (u ~ /ASL\.L #\$4,D1/ || u ~ /ASL\.L #4,D1/) c_hour = 1
    if (u ~ /ASL\.L #\$2,D0/ || u ~ /ASL\.L #2,D0/) c_min = 1
    if (u ~ /^ADD\.L / || u ~ /^ADD\.W /) add = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_NORMALIZE_CALL=" call_norm
    print "HAS_SECONDS_TO_STRUCT_CALL=" call_store
    print "HAS_HOUR_SECONDS_CONST=" c_hour
    print "HAS_MIN_SECONDS_CONST=" c_min
    print "HAS_MULTIPLY_PATH=" mul
    print "HAS_ACCUMULATE_PATH=" add
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
