BEGIN {
    has_entry=0
    has_alias_count=0
    has_alias_table=0
    has_compare_call=0
    has_copy_loop=0
    has_measure_loop=0
    has_const12=0
    has_not_found_minus1=0
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

    if (u ~ /^TEXTDISP_FINDALIASINDEXBYNAME:/ || u ~ /^TEXTDISP_FINDALIASINDEXBYNAM[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TEXTDISPALIASCOUNT/) has_alias_count=1
    if (n ~ /TEXTDISPALIASPTRTABLE/) has_alias_table=1
    if (n ~ /STRINGCOMPARENOCASEN/) has_compare_call=1
    if (n ~ /COPY/ || n ~ /MOVEBA0A1/ || n ~ /MOVEB0A0/ || n ~ /MOVEB[A0-7][A0-7]/ || n ~ /TSTBFFFFFFFFA[0-7]/) has_copy_loop=1
    if (n ~ /MEASURE/ || n ~ /TSTBA0/ || n ~ /ADDQL1/) has_measure_loop=1
    if (u ~ /#12([^0-9]|$)/ || u ~ /#\$0C/ || u ~ /\(\$C\)/) has_const12=1
    if (u ~ /#-1/ || u ~ /#\$FFFFFFFF/ || n ~ /MOVEQFF/ || n ~ /MOVEQLFF/) has_not_found_minus1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_ALIAS_COUNT_GLOBAL="has_alias_count
    print "HAS_ALIAS_TABLE_GLOBAL="has_alias_table
    print "HAS_COMPARE_NOCASE_CALL="has_compare_call
    print "HAS_COPY_LOOP_PATTERN="has_copy_loop
    print "HAS_MEASURE_LOOP_PATTERN="has_measure_loop
    print "HAS_CONST_12="has_const12
    print "HAS_NOT_FOUND_MINUS1="has_not_found_minus1
    print "HAS_RTS="has_rts
}
