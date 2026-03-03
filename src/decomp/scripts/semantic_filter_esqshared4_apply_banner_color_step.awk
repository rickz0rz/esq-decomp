BEGIN {
    has_set_call = 0
    has_d1_58 = 0
    has_bind_call = 0
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

    if (u ~ /ESQSHARED4_SETBANNERCOPPERCOLORANDTHRESHOLD/) has_set_call = 1
    if (u ~ /^MOVE\.[WL] #\$?58,D1$/ || u ~ /^MOVEQ #88,D1$/) has_d1_58 = 1
    if (u ~ /ESQSHARED4_BINDANDCLEARBANNERWORKRASTER/) has_bind_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SET_CALL=" has_set_call
    print "HAS_D1_58=" has_d1_58
    print "HAS_BIND_CALL=" has_bind_call
    print "HAS_RTS=" has_rts
}
