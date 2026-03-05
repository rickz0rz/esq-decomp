BEGIN {
    has_entry = 0
    has_load_call = 0
    has_copy_mem = 0
    has_template_ref = 0
    has_work_ptr_advance = 0
    has_replace_owned = 0
    has_dealloc = 0
    has_return_one = 0
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

    if (u ~ /^GCOMMAND_LOADDEFAULTTABLE[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "GROUP_AY_JMPTBL_DISKIO_LOADFILETOWORKBUFFER") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_LOADFILET") > 0) has_load_call = 1
    if (index(u, "_LVOCOPYMEM") > 0) has_copy_mem = 1
    if (index(u, "GCOMMAND_DIGITALNICHEENABLEDFLAG") > 0) has_template_ref = 1
    if (index(u, "GLOBAL_PTR_WORK_BUFFER") > 0 && (u ~ /^ADD(\.L)? / || u ~ /^MOVE\.L /)) has_work_ptr_advance = 1
    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0) has_replace_owned = 1
    if (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCAT") > 0) has_dealloc = 1
    if (u ~ /^MOVEQ(\.L)? #1,D0$/ || u ~ /^MOVEQ(\.L)? #\$1,D0$/) has_return_one = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD_CALL=" has_load_call
    print "HAS_COPY_MEM=" has_copy_mem
    print "HAS_TEMPLATE_REF=" has_template_ref
    print "HAS_WORK_PTR_ADVANCE=" has_work_ptr_advance
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_RETURN_ONE=" has_return_one
    print "HAS_RETURN=" has_return
}
