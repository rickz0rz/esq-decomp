BEGIN {
    has_entry=0
    has_dealloc=0
    has_str4=0
    has_str5=0
    has_const92=0
    has_const95=0
    has_const10=0
    has_null_test=0
    has_payload_test=0
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

    if (u ~ /^P_TYPE_FREEENTRY:/ || u ~ /^P_TYPE_FREEENTRY[A-Z0-9_]*:/) has_entry=1
    if (n ~ /SCRIPTJMPTBLMEMORYDEALLOCATEMEMORY/ || n ~ /SCRIPTJMPTBLMEMORYDEALLOCATEM/) has_dealloc=1
    if (n ~ /GLOBALSTRPTYPEC4/) has_str4=1
    if (n ~ /GLOBALSTRPTYPEC5/) has_str5=1
    if (u ~ /#92([^0-9]|$)/ || u ~ /#\$5C/ || u ~ /92\.[Ww]/ || u ~ /\(\$5C\)/) has_const92=1
    if (u ~ /#95([^0-9]|$)/ || u ~ /#\$5F/ || u ~ /95\.[Ww]/ || u ~ /\(\$5F\)/) has_const95=1
    if (u ~ /#10([^0-9]|$)/ || u ~ /#\$0A/ || u ~ /10\.[Ww]/ || u ~ /\(\$A\)/) has_const10=1
    if (n ~ /TSTL/ && n ~ /A3/ || n ~ /BEQ/) has_null_test=1
    if (n ~ /TSTL6A3/ || n ~ /TSTL6A/ || n ~ /LEA6A5A0/ || n ~ /MOVELA0D0/) has_payload_test=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DEALLOCATE_CALL="has_dealloc
    print "HAS_STR_P_TYPE_C_4="has_str4
    print "HAS_STR_P_TYPE_C_5="has_str5
    print "HAS_CONST_92="has_const92
    print "HAS_CONST_95="has_const95
    print "HAS_CONST_10="has_const10
    print "HAS_NULL_TEST_PATTERN="has_null_test
    print "HAS_PAYLOAD_TEST_PATTERN="has_payload_test
    print "HAS_RTS="has_rts
}
