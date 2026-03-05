BEGIN {
    has_entry = 0
    has_save = 0
    has_lock_test = 0
    has_seed_ptr0 = 0
    has_current_idx = 0
    has_len_table = 0
    has_header_adjust = 0
    has_loop = 0
    has_line_ptr_table = 0
    has_text_ptr_table = 0
    has_lock_store = 0
    has_return = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next
    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /^MOVEM\.L .*,-\(A7\)$/) has_save = 1
    if (l ~ /DISPTEXT_LINETABLELOCKFLAG/ && (l ~ /TST\.L/ || l ~ /MOVE\.L/)) has_lock_test = 1
    if (l ~ /DISPTEXT_TEXTBUFFERPTR/ && l ~ /DISPTEXT_LINEPTRTABLE/) has_seed_ptr0 = 1
    if (l ~ /DISPTEXT_CURRENTLINEINDEX/) has_current_idx = 1
    if (l ~ /DISPTEXT_LINELENGTHTABLE/) has_len_table = 1
    if (l ~ /MOVEQ(\.L)? #\$?1,D0/ || l ~ /MOVEQ(\.L)? #\$?0,D0/) has_header_adjust = 1
    if (l ~ /CMP\.L D5,D6/ || l ~ /BGE\./ || l ~ /ADDQ\.L #\$?1,D6/) has_loop = 1
    if (l ~ /DISPTEXT_LINEPTRTABLE/) has_line_ptr_table = 1
    if (l ~ /DISPTEXT_TEXTBUFFERPTRTABLE/ || l ~ /DISPTEXT_TEXTBUFFERPTR/) has_text_ptr_table = 1
    if (l ~ /DISPTEXT_LINETABLELOCKFLAG/ && l ~ /MOVE\.L D7/) has_lock_store = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_LOCK_TEST=" has_lock_test
    print "HAS_SEED_PTR0=" has_seed_ptr0
    print "HAS_CURRENT_IDX=" has_current_idx
    print "HAS_LEN_TABLE=" has_len_table
    print "HAS_HEADER_ADJUST=" has_header_adjust
    print "HAS_LOOP=" has_loop
    print "HAS_LINE_PTR_TABLE=" has_line_ptr_table
    print "HAS_TEXT_PTR_TABLE=" has_text_ptr_table
    print "HAS_LOCK_STORE=" has_lock_store
    print "HAS_RETURN=" has_return
}
