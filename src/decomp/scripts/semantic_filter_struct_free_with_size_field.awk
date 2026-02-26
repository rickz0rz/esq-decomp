BEGIN {
    has_mark_invalid = 0
    has_store_minus_one = 0
    has_size_load = 0
    has_freemem_call = 0
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

    if (u ~ /MOVE\.B[[:space:]]+#\$?FF,8\(/ || u ~ /^ST[[:space:]]+\(8,/) has_mark_invalid = 1
    if (u ~ /20\(/ || u ~ /24\(/ || u ~ /\(20,/ || u ~ /\(24,/) {
        if (u ~ /#\$?FFFFFFFF/ || u ~ /#-1/ || u ~ /A0,20\(/ || u ~ /A0,24\(/ || u ~ /D[0-7],20\(/ || u ~ /D[0-7],24\(/ || u ~ /^MOVE\.L[[:space:]]+D[0-7],\(20,/ || u ~ /^MOVE\.L[[:space:]]+D[0-7],\(24,/) has_store_minus_one = 1
    }
    if (u ~ /MOVE\.W[[:space:]]+18\(/ || u ~ /MOVE\.W[[:space:]]+\(18,/) has_size_load = 1
    if (u ~ /LVOFREEMEM/ || u ~ /JSR .*FREEMEM/ || u ~ /JSR .*\(A6\)/) has_freemem_call = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_MARK_INVALID=" has_mark_invalid
    print "HAS_STORE_MINUS_ONE=" has_store_minus_one
    print "HAS_SIZE_LOAD=" has_size_load
    print "HAS_FREEMEM_CALL=" has_freemem_call
    print "HAS_RTS=" has_rts
}
