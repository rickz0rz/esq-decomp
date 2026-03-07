BEGIN {
    has_entry=0
    has_alloc=0
    has_dealloc=0
    has_loop=0
    has_copy=0
    has_const10=0
    has_const47=0
    has_const58=0
    has_const77=0
    has_flags=0
    has_str1=0
    has_str2=0
    has_str3=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^P_TYPE_ALLOCATEENTRY:/ || u ~ /^P_TYPE_ALLOCATEENTRY[A-Z0-9_]*:/) has_entry=1
    if (n ~ /SCRIPTJMPTBLMEMORYALLOCATEMEMORY/ || n ~ /SCRIPTJMPTBLMEMORYALLOCATEMEM/) has_alloc=1
    if (n ~ /SCRIPTJMPTBLMEMORYDEALLOCATEMEMORY/ || n ~ /SCRIPTJMPTBLMEMORYDEALLOCATEM/) has_dealloc=1
    if (n ~ /CMP/ && n ~ /D6/ || n ~ /DBF/) has_loop=1
    if (n ~ /MOVEB0A3D5LA0/ || n ~ /MOVEB0A3D0/ || n ~ /MOVEB0A3/ || n ~ /MOVEB0A5D5L0A2D5L/) has_copy=1
    if (u ~ /#10([^0-9]|$)/ || u ~ /#\$0A/ || u ~ /10\.[Ww]/ || u ~ /\(\$A\)/) has_const10=1
    if (u ~ /#47([^0-9]|$)/ || u ~ /#\$2F/ || u ~ /47\.[Ww]/ || u ~ /\(\$2F\)/) has_const47=1
    if (u ~ /#58([^0-9]|$)/ || u ~ /#\$3A/ || u ~ /58\.[Ww]/ || u ~ /\(\$3A\)/) has_const58=1
    if (u ~ /#77([^0-9]|$)/ || u ~ /#\$4D/ || u ~ /77\.[Ww]/ || u ~ /\(\$4D\)/) has_const77=1
    if (u ~ /#65537([^0-9]|$)/ || u ~ /#\$10001/ || u ~ /#\$00010001/ || n ~ /MEMFPUBLICMEMFCLEAR/) has_flags=1
    if (n ~ /GLOBALSTRPTYPEC1/) has_str1=1
    if (n ~ /GLOBALSTRPTYPEC2/) has_str2=1
    if (n ~ /GLOBALSTRPTYPEC3/) has_str3=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_ALLOCATE_CALL="has_alloc
    print "HAS_DEALLOCATE_CALL="has_dealloc
    print "HAS_LOOP_PATTERN="has_loop
    print "HAS_COPY_PATTERN="has_copy
    print "HAS_CONST_10="has_const10
    print "HAS_CONST_47="has_const47
    print "HAS_CONST_58="has_const58
    print "HAS_CONST_77="has_const77
    print "HAS_MEM_FLAGS="has_flags
    print "HAS_STR_P_TYPE_C_1="has_str1
    print "HAS_STR_P_TYPE_C_2="has_str2
    print "HAS_STR_P_TYPE_C_3="has_str3
    print "HAS_RTS="has_rts
}
