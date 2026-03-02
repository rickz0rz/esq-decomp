BEGIN {
    has_list_head = 0
    has_block_size = 0
    has_bytes_total = 0
    has_div = 0
    has_mul = 0
    has_memlist_alloc = 0
    has_insert_free = 0
    has_recursive = 0
    has_min8 = 0
    has_terminal = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /GLOBALALLOCLISTHEAD/) has_list_head = 1
    if (n ~ /GLOBALALLOCBLOCKSIZE/) has_block_size = 1
    if (n ~ /GLOBALALLOCBYTESTOTAL/) has_bytes_total = 1
    if (n ~ /MATHDIVS32/) has_div = 1
    if (n ~ /MATHMULU32/) has_mul = 1
    if (n ~ /MEMLISTALLOCTRACKED/) has_memlist_alloc = 1
    if (n ~ /ALLOCINSERTFREEBLOCK/) has_insert_free = 1
    if (n ~ /ALLOCALLOCFROMFREELIST/) has_recursive = 1
    if (u ~ /#8/ || u ~ /[^0-9]8[^0-9]/) has_min8 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_LIST_HEAD=" has_list_head
    print "HAS_BLOCK_SIZE=" has_block_size
    print "HAS_BYTES_TOTAL=" has_bytes_total
    print "HAS_DIV=" has_div
    print "HAS_MUL=" has_mul
    print "HAS_MEMLIST_ALLOC=" has_memlist_alloc
    print "HAS_INSERT_FREE=" has_insert_free
    print "HAS_RECURSIVE=" has_recursive
    print "HAS_MIN8=" has_min8
    print "HAS_TERMINAL=" has_terminal
}
