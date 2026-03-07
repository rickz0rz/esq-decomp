BEGIN {
    has_entry=0
    has_alloc=0
    has_store_intr_ptr=0
    has_type_2=0
    has_name_ptr=0
    has_data_ptr=0
    has_code_ptr=0
    has_intb_vertb=0
    has_add_vector=0
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

    if (u ~ /^SETUP_INTERRUPT_INTB_VERTB:/ || u ~ /^SETUP_INTERRUPT_INTB_VER[A-Z0-9_]*:/) has_entry=1
    if (n ~ /ALLOCATEMEM/) has_alloc=1
    if ((n ~ /GLOBALREFINTERRUPTSTRUCTINTBVERTB/ || n ~ /GLOBALREFINTERRUPTSTRUCTINTB/) && (n ~ /MOVELD0/ || n ~ /MOVELA5/)) has_store_intr_ptr=1
    if (u ~ /#\$2/ || u ~ /#2([^0-9]|$)/) has_type_2=1
    if (n ~ /GLOBALSTRVERTICALBLANKINT/) has_name_ptr=1
    if (n ~ /VERTICALBLANKINTERRUPTUSERDATA/ || n ~ /VERTICALBLANKINTERRUPTUSERDA/) has_data_ptr=1
    if (n ~ /TICKGLOBALCOUNTERS/ || n ~ /TICKGLOBALCOU/) has_code_ptr=1
    if (u ~ /#INTB_VERTB/ || u ~ /#\$5/ || u ~ /#5([^0-9]|$)/ || u ~ /\(\$5\)/) has_intb_vertb=1
    if (n ~ /ADDINTVECTOR/ || n ~ /LVOADDINTVECTOR/ || n ~ /JSRFFFFFFA0A6/) has_add_vector=1
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
    print "HAS_INTB_VERTB_CONST="has_intb_vertb
    print "HAS_ADD_VECTOR_CALL="has_add_vector
    print "HAS_RTS="has_rts
}
