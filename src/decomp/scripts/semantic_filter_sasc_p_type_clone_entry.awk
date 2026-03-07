BEGIN {
    has_entry=0
    has_free=0
    has_alloc=0
    has_null_check=0
    has_len_access=0
    has_payload_access=0
    has_scratch_copy=0
    has_clear_term=0
    has_const104=0
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

    if (u ~ /^P_TYPE_CLONEENTRY:/ || u ~ /^P_TYPE_CLONEENTRY[A-Z0-9_]*:/) has_entry=1
    if (n ~ /PTYPEFREEENTRY/) has_free=1
    if (n ~ /PTYPEALLOCATEENTRY/) has_alloc=1
    if (n ~ /TSTL/ && (n ~ /A2/ || n ~ /A3/ || n ~ /A5/) || n ~ /BEQ/) has_null_check=1
    if (n ~ /2A2/ || n ~ /2A0/) has_len_access=1
    if (n ~ /6A2/ || n ~ /6A1/ || n ~ /6A0/ || n ~ /LEA6A3A0/ || n ~ /MOVELA0A1/) has_payload_access=1
    if (n ~ /MOVEB/ && n ~ /A5/ && n ~ /A0/ || n ~ /D7L/) has_scratch_copy=1
    if (n ~ /CLRB/ || n ~ /MOVEB0/) has_clear_term=1
    if (u ~ /#104([^0-9]|$)/ || u ~ /#\$68/ || u ~ /104\.[Ww]/ || u ~ /\(\$68\)/ || u ~ /-100\(A5/) has_const104=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_FREE_CALL="has_free
    print "HAS_ALLOCATE_CALL="has_alloc
    print "HAS_NULL_CHECK_PATTERN="has_null_check
    print "HAS_LENGTH_ACCESS_PATTERN="has_len_access
    print "HAS_PAYLOAD_ACCESS_PATTERN="has_payload_access
    print "HAS_SCRATCH_COPY_PATTERN="has_scratch_copy
    print "HAS_TERMINATOR_WRITE_PATTERN="has_clear_term
    print "HAS_CONST_104_OR_STACK_BUFFER="has_const104
    print "HAS_RTS="has_rts
}
