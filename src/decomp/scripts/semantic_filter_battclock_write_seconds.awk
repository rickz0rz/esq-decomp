BEGIN {
    has_resource_ref = 0
    has_d0_arg = 0
    has_write_call = 0
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

    if (u ~ /GLOBAL_REF_BATTCLOCK_RESOURCE/ || u ~ /^MOVEA\.L .*A6$/) has_resource_ref = 1
    if (u ~ /D0/ || u ~ /^MOVE\.L 8\(A7\),D0$/ || u ~ /^MOVE\.L \(8,A7\),D0$/) has_d0_arg = 1
    if (u ~ /JSR .*LVOWRITEBATTCLOCK/) has_write_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_RESOURCE_REF=" has_resource_ref
    print "HAS_D0_ARG=" has_d0_arg
    print "HAS_WRITE_CALL=" has_write_call
    print "HAS_RTS=" has_rts
}
