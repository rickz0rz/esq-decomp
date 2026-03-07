BEGIN {
    has_entry=0
    has_alloc=0
    has_store_intr_ptr=0
    has_type_2=0
    has_name_ptr=0
    has_data_ptr=0
    has_code_ptr=0
    has_intb_aud1=0
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

    if (u ~ /^SETUP_INTERRUPT_INTB_AUD1:/ || u ~ /^SETUP_INTERRUPT_INTB_AUD[A-Z0-9_]*:/) has_entry=1
    if (n ~ /ALLOCATEMEM/) has_alloc=1
    if ((n ~ /GLOBALREFINTERRUPTSTRUCTINTB/ || n ~ /GLOBALREFINTERRUPTSTRUCTINTBAUD1/) && (n ~ /MOVELD0/ || n ~ /MOVELA5/)) has_store_intr_ptr=1
    if (u ~ /#\$2/ || u ~ /#2([^0-9]|$)/) has_type_2=1
    if (n ~ /GLOBALSTRJOYSTICKINT/) has_name_ptr=1
    if (n ~ /CTRLSAMPLEENTRYSCRATCH/) has_data_ptr=1
    if (n ~ /POLLCTRLINPUT/) has_code_ptr=1
    if (u ~ /#INTB_AUD1/ || u ~ /#\$8/ || u ~ /#8([^0-9]|$)/) has_intb_aud1=1
    if (n ~ /SETINTVECTOR/ || n ~ /LVOSETINTVECTOR/ || n ~ /JSRFFFFFF5EA6/) has_set_vector=1
    if (n ~ /GLOBALREFINTBAUD1INTERRUPT/ && n ~ /MOVELD0/) has_store_prev=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_ALLOC_CALL="has_alloc
    print "HAS_STORE_INTR_PTR="has_store_intr_ptr
    print "HAS_TYPE_2="has_type_2
    print "HAS_NAME_PTR="has_name_ptr
    print "HAS_DATA_PTR="has_data_ptr
    print "HAS_CODE_PTR="has_code_ptr
    print "HAS_INTB_AUD1_CONST="has_intb_aud1
    print "HAS_SET_VECTOR_CALL="has_set_vector
    print "HAS_STORE_PREV_VECTOR="has_store_prev
    print "HAS_RTS="has_rts
}
