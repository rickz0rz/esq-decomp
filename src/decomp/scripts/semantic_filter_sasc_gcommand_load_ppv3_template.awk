BEGIN {
    has_entry = 0
    has_primary_load = 0
    has_fallback_load = 0
    has_delete_file = 0
    has_copy_mem = 0
    has_ppv_ref = 0
    has_copy_size_56 = 0
    has_copy_size_52 = 0
    has_find_char = 0
    has_replace_owned = 0
    has_dealloc = 0
    has_call_load_ppv_template = 0
    has_return_one = 0
    has_return = 0
    replace_owned_count = 0
    load_file_call_count = 0
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

    if (u ~ /^GCOMMAND_LOADPPV3TEMPLATE[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "GROUP_AY_JMPTBL_DISKIO_LOADFILETOWORKBUFFER") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_LOADFILET") > 0) load_file_call_count += 1

    if (index(u, "_LVODELETEFILE") > 0) has_delete_file = 1

    if (index(u, "_LVOCOPYMEM") > 0) has_copy_mem = 1
    if (index(u, "GCOMMAND_DIGITALPPVENABLEDFLAG") > 0) has_ppv_ref = 1

    if (u ~ /^MOVEQ(\.L)? #56,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$38,D[0-7]$/) has_copy_size_56 = 1
    if (u ~ /^MOVEQ(\.L)? #52,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$34,D[0-7]$/) has_copy_size_52 = 1

    if (index(u, "GROUP_AS_JMPTBL_STR_FINDCHARPTR") > 0 || index(u, "GROUP_AS_JMPTBL_STR_FINDCHARP") > 0) has_find_char = 1

    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPARS_REPLACEOWNEDSTRI") > 0) replace_owned_count += 1

    if (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCAT") > 0) has_dealloc = 1

    if (index(u, "GCOMMAND_LOADPPVTEMPLATE") > 0) has_call_load_ppv_template = 1

    if (u ~ /^MOVEQ(\.L)? #1,D0$/ || u ~ /^MOVEQ(\.L)? #\$1,D0$/) has_return_one = 1
    if (u == "RTS") has_return = 1
}

END {
    if (load_file_call_count >= 1) has_primary_load = 1
    if (load_file_call_count >= 2) has_fallback_load = 1
    if (replace_owned_count >= 2) has_replace_owned = 1
    print "HAS_ENTRY=" has_entry
    print "HAS_PRIMARY_LOAD=" has_primary_load
    print "HAS_FALLBACK_LOAD=" has_fallback_load
    print "HAS_DELETE_FILE=" has_delete_file
    print "HAS_COPY_MEM=" has_copy_mem
    print "HAS_PPV_REF=" has_ppv_ref
    print "HAS_COPY_SIZE_56=" has_copy_size_56
    print "HAS_COPY_SIZE_52=" has_copy_size_52
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_CALL_LOAD_PPV_TEMPLATE=" has_call_load_ppv_template
    print "HAS_RETURN_ONE=" has_return_one
    print "HAS_RETURN=" has_return
}
