BEGIN {
    has_owner_check = 0
    has_allocmem_call = 0
    has_field_init = 0
    has_size_store = 0
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

    if (u ~ /BNE/ || u ~ /BEQ/ || u ~ /TST\.L/) has_owner_check = 1
    if (u ~ /LVOALLOCMEM/ || u ~ /JSR .*ALLOCMEM/ || u ~ /JSR .*\(A6\)/) has_allocmem_call = 1
    if (u ~ /8\(/ || u ~ /\(8,/) {
        if (u ~ /#\$?5/ || u ~ /^ST / || u ~ /^CLR\.B/ || u ~ /MOVE\.B .*8\(/ || u ~ /MOVE\.B .*\(8,/) has_field_init = 1
    }
    if (u ~ /MOVE\.W .*18\(/ || u ~ /MOVE\.W .*\(18,/) has_size_store = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_OWNER_CHECK=" has_owner_check
    print "HAS_ALLOCMEM_CALL=" has_allocmem_call
    print "HAS_FIELD_INIT=" has_field_init
    print "HAS_SIZE_STORE=" has_size_store
    print "HAS_RTS=" has_rts
}
