BEGIN {
    has_current_index = 0
    has_delim_key = 0
    has_delim_value = 0
    has_tag_table = 0
    has_tag_done = 0
    has_tag_color = 0
    has_find_char = 0
    has_skip_class3 = 0
    has_find_any = 0
    has_cmp_nocase_n = 0
    has_validate = 0
    has_parse_signed = 0
    has_parse_hex = 0
    has_const_32 = 0
    has_shift7 = 0
    has_terminal = 0
}

function trim(s,    t) {
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

    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /PARSEINICURRENTRANGETABLEINDEX/) has_current_index = 1
    if (n ~ /PARSEINIDELIMSPACETABRANGEKEY/) has_delim_key = 1
    if (n ~ /PARSEINIDELIMSPACESEMICOLONTABRANGEVALUE/) has_delim_value = 1
    if (n ~ /PARSEINITAGTABLE/) has_tag_table = 1
    if (n ~ /PARSEINITAGDONE/) has_tag_done = 1
    if (n ~ /PARSEINITAGCOLOR/) has_tag_color = 1
    if (n ~ /PARSEINIJMPTBLSTRFINDCHARPTR/) has_find_char = 1
    if (n ~ /NEWGRID2JMPTBLSTRSKIPCLASS3CHARS/) has_skip_class3 = 1
    if (n ~ /PARSEINIJMPTBLSTRFINDANYCHARPTR/) has_find_any = 1
    if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASEN/) has_cmp_nocase_n = 1
    if (n ~ /PARSEINIJMPTBLGCOMMANDVALIDATEPRESETTABLE/) has_validate = 1
    if (n ~ /SCRIPT3JMPTBLPARSEREADSIGNEDLONGSKIPCLASS3ALT/) has_parse_signed = 1
    if (n ~ /PARSEINIPARSEHEXVALUEFROMSTRING/) has_parse_hex = 1
    if (u ~ /[^0-9]32[^0-9]/ || u ~ /^32$/) has_const_32 = 1
    if (u ~ /#7/ || u ~ /<<7/ || u ~ /ASL.L #7/) has_shift7 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_CURRENT_INDEX=" has_current_index
    print "HAS_DELIM_KEY=" has_delim_key
    print "HAS_DELIM_VALUE=" has_delim_value
    print "HAS_TAG_TABLE=" has_tag_table
    print "HAS_TAG_DONE=" has_tag_done
    print "HAS_TAG_COLOR=" has_tag_color
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_SKIP_CLASS3=" has_skip_class3
    print "HAS_FIND_ANY=" has_find_any
    print "HAS_CMP_NOCASE_N=" has_cmp_nocase_n
    print "HAS_VALIDATE=" has_validate
    print "HAS_PARSE_SIGNED=" has_parse_signed
    print "HAS_PARSE_HEX=" has_parse_hex
    print "HAS_CONST_32=" has_const_32
    print "HAS_SHIFT7=" has_shift7
    print "HAS_TERMINAL=" has_terminal
}
