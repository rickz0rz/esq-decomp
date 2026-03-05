BEGIN {
    has_entry = 0
    has_repack = 0
    has_entry_table = 0
    has_alloc = 0
    has_replace = 0
    has_free = 0
    has_attr_alloc = 0
    has_copy_loop = 0
    has_return = 0
}

function trim(s, t) {
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

    if (u ~ /^LADFUNC_UPDATEENTRYFROMTEXTANDATTRBUFFERS:/ || u ~ /^LADFUNC_UPDATEENTRYFROMTEXTANDA[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "LADFUNC_REPACKENTRYTEXTANDATTRBUFFERS") > 0 || index(u, "LADFUNC_REPACKENTRYTEXTANDAT") > 0) has_repack = 1
    if (index(u, "LADFUNC_ENTRYPTRTABLE") > 0) has_entry_table = 1

    if (index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATE") > 0) {
        has_alloc = 1
        has_attr_alloc = 1
    }
    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPARS_REPLACEOWNEDSTR") > 0) has_replace = 1
    if (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATE") > 0) has_free = 1

    if (u ~ /MOVE\.B .*\(A[0-7]\)\+,\(A[0-7]\)\+/ || u ~ /MOVE\.B \$0\(A[0-7],D[0-7]\.L\),\$0\(A[0-7],D[0-7]\.L\)/ || u ~ /MOVE\.B \$0\(A[0-7],D[0-7]\.L\),\(A[0-7]\)/) has_copy_loop = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_REPACK=" has_repack
    print "HAS_ENTRY_TABLE=" has_entry_table
    print "HAS_ALLOC=" has_alloc
    print "HAS_REPLACE=" has_replace
    print "HAS_FREE=" has_free
    print "HAS_ATTR_ALLOC=" has_attr_alloc
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_RETURN=" has_return
}
