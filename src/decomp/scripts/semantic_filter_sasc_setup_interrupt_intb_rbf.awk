BEGIN {
    has_entry=0
    alloc_calls=0
    has_store_intr_ptr=0
    has_store_buffer_ptr=0
    has_size_64000=0
    has_type_2=0
    has_name_ptr=0
    has_data_ptr=0
    has_code_ptr=0
    has_intb_rbf=0
    has_set_vector=0
    has_store_prev=0
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

    if (u ~ /^SETUP_INTERRUPT_INTB_RBF:/ || u ~ /^SETUP_INTERRUPT_INTB_RB[A-Z0-9_]*:/) has_entry=1
    if (n ~ /ALLOCATEMEM/) alloc_calls++
    if ((n ~ /GLOBALREFINTERRUPTSTRUCTINTBRBF/ || n ~ /GLOBALREFINTERRUPTSTRUCTINTB/) && (n ~ /MOVELD0/ || n ~ /MOVELA5/)) has_store_intr_ptr=1
    if (n ~ /GLOBALREFINTBRBF64KBUFFER/ && n ~ /MOVELD0/) has_store_buffer_ptr=1
    if (u ~ /#64000/ || u ~ /#\$FA00/ || u ~ /\(\$FA00\)/) has_size_64000=1
    if (u ~ /#\$2/ || u ~ /#2([^0-9]|$)/) has_type_2=1
    if (n ~ /RS232RECEIVEHANDLER/) has_name_ptr=1
    if (n ~ /GLOBALREFINTBRBF64KBUFFER/) has_data_ptr=1
    if (n ~ /HANDLESERIALRBFINTERRUPT/ || n ~ /HANDLESERIALRBFINTER/ || n ~ /HANDLESERIALR/) has_code_ptr=1
    if (u ~ /#INTB_RBF/ || u ~ /#\$B/ || u ~ /#11([^0-9]|$)/ || u ~ /\(\$B\)/) has_intb_rbf=1
    if (n ~ /SETINTVECTOR/ || n ~ /LVOSETINTVECTOR/ || n ~ /JSRFFFFFF5EA6/) has_set_vector=1
    if (n ~ /GLOBALREFINTBRBFINTERRUPT/ && n ~ /MOVELD0/) has_store_prev=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_ALLOC_CALLS_GE_2="(alloc_calls >= 2 ? 1 : 0)
    print "HAS_STORE_INTR_PTR="has_store_intr_ptr
    print "HAS_STORE_BUFFER_PTR="has_store_buffer_ptr
    print "HAS_SIZE_64000="has_size_64000
    print "HAS_TYPE_2="has_type_2
    print "HAS_NAME_PTR="has_name_ptr
    print "HAS_DATA_PTR="has_data_ptr
    print "HAS_CODE_PTR="has_code_ptr
    print "HAS_INTB_RBF_CONST="has_intb_rbf
    print "HAS_SET_VECTOR_CALL="has_set_vector
    print "HAS_STORE_PREV_VECTOR="has_store_prev
    print "HAS_RTS="has_rts
}
