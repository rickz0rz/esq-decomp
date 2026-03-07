BEGIN {
    has_entry=0
    has_vm_base=0
    has_mul_154=0
    has_store0=0
    has_store2=0
    has_store4=0
    has_store6=0
    has_store8=0
    has_copy_loop=0
    has_set_bitmap_ptr=0
    has_init_bitmap=0
    has_plane_copy=0
    has_store150=0
    has_store152=0
    has_rts=0
    saw_mul_call=0
    saw_77=0
    saw_double=0
    saw_9a=0
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

    if (u ~ /^TLIBA3_INITRUNTIMEENTRY:/ || u ~ /^TLIBA3_INITRUNTIMEENTR[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TLIBA3VMARRAYRUNTIMETABLE/) has_vm_base=1
    if (u ~ /#77/) saw_77=1
    if (n ~ /ADDLD1D1/) saw_double=1
    if (u ~ /\$9A/ || n ~ /PEA9AW/) saw_9a=1
    if (n ~ /MATHMULU32/) saw_mul_call=1
    if (u ~ /MOVE\.W D6,\(A1\)/ || u ~ /MOVE\.W D6,\$0\(A1\)/ || u ~ /MOVE\.W D0,\(A5\)/ || u ~ /MOVE\.W D0,\$0\(A5\)/) has_store0=1
    if (u ~ /MOVE\.W D5,2\(A1\)/ || u ~ /MOVE\.W D5,\$2\(A1\)/ || u ~ /MOVE\.W D1,\(A0\)/) has_store2=1
    if (u ~ /MOVE\.W D4,4\(A1\)/ || u ~ /MOVE\.W D4,\$4\(A1\)/ || u ~ /LEA \$4\(A5\),A0/) has_store4=1
    if (u ~ /MOVE\.W 26\(A5\),6\(A1\)/ || u ~ /MOVE\.W 26\(A5\),\$6\(A1\)/ || u ~ /LEA \$6\(A5\),A0/) has_store6=1
    if (u ~ /MOVE\.W 30\(A5\),8\(A1\)/ || u ~ /MOVE\.W 30\(A5\),\$8\(A1\)/ || u ~ /LEA \$8\(A5\),A0/) has_store8=1
    if (u ~ /MOVEQ #24,D1/ || n ~ /MOVEQ24D1/ || n ~ /MOVEQL18D1/) has_copy_loop=1
    if (u ~ /MOVE\.L A3,14\(A1\)/ || u ~ /MOVE\.L A3,\$E\(A1\)/ || (u ~ /LEA \$E\(A5\),A0/)) has_set_bitmap_ptr=1
    if (n ~ /LVOINITBITMAP/) has_init_bitmap=1
    if (u ~ /\$76\(A0\)/ || u ~ /118\(A0\)/ || u ~ /WDISP_DISPLAYCONTEXTPLANEPOINTER0/) has_plane_copy=1
    if (u ~ /MOVE\.W D1,150\(A1\)/ || u ~ /MOVE\.W D1,\$96\(A1\)/ || (u ~ /LEA \$96\(A5\),A0/ && has_store150==0)) has_store150=1
    if (u ~ /MOVE\.W D1,152\(A0\)/ || u ~ /MOVE\.W D1,\$98\(A0\)/ || (u ~ /LEA \$98\(A5\),A0/ && has_store152==0)) has_store152=1
    if (u == "RTS") has_rts=1
}

END {
    has_mul_154 = (saw_mul_call && ((saw_77 && saw_double) || saw_9a)) ? 1 : 0
    print "HAS_ENTRY="has_entry
    print "HAS_VM_BASE="has_vm_base
    print "HAS_MUL_154_PATH="has_mul_154
    print "HAS_STORE_OFF_0="has_store0
    print "HAS_STORE_OFF_2="has_store2
    print "HAS_STORE_OFF_4="has_store4
    print "HAS_STORE_OFF_6="has_store6
    print "HAS_STORE_OFF_8="has_store8
    print "HAS_RASTPORT_COPY_LOOP="has_copy_loop
    print "HAS_SET_BITMAP_PTR="has_set_bitmap_ptr
    print "HAS_INIT_BITMAP_CALL="has_init_bitmap
    print "HAS_PLANE_PTR_COPY="has_plane_copy
    print "HAS_STORE_OFF_150="has_store150
    print "HAS_STORE_OFF_152="has_store152
    print "HAS_RTS="has_rts
}
