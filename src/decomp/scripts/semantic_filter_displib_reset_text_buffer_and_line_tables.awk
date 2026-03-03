BEGIN {
    has_entry = 0
    has_replace_owned = 0
    has_store_new_ptr = 0
    has_reset_line_call = 0
    has_stack_fixup = 0
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
    uline = toupper(line)

    if (uline ~ /^DISPLIB_RESETTEXTBUFFERANDLINETABLES:/) has_entry = 1
    if (uline ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/) has_replace_owned = 1
    if (uline ~ /MOVE\.L D0,DISPTEXT_TEXTBUFFERPTR/) has_store_new_ptr = 1
    if (uline ~ /BSR\.S DISPLIB_RESETLINETABLES/) has_reset_line_call = 1
    if (uline ~ /ADDQ\.W #8,A7/) has_stack_fixup = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_STORE_NEW_PTR=" has_store_new_ptr
    print "HAS_RESET_LINE_CALL=" has_reset_line_call
    print "HAS_STACK_FIXUP=" has_stack_fixup
    print "HAS_RETURN=" has_return
}
