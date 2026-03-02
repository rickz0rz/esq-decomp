BEGIN {
    has_compare = 0
    has_parse_long = 0
    has_alloc_brush = 0
    has_alloc_mem = 0
    has_copy_pad = 0
    has_key_filename = 0
    has_key_loadcolor = 0
    has_key_source = 0
    has_key_horizontal = 0
    has_key_vertical = 0
    has_key_id = 0
    has_tag_ppv = 0
    has_tag_right = 0
    has_tag_bottom = 0
    has_desc_head = 0
    has_curr_ptr = 0
    has_temp_ptr = 0
    has_off_190 = 0
    has_off_194 = 0
    has_off_222 = 0
    has_off_226 = 0
    has_off_230 = 0
    has_const_670 = 0
    has_const_12 = 0
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

    if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASE/) has_compare = 1
    if (n ~ /SCRIPT3JMPTBLPARSEREADSIGNEDLONGSKIPCLASS3ALT/) has_parse_long = 1
    if (n ~ /PARSEINIJMPTBLBRUSHALLOCBRUSHNODE/) has_alloc_brush = 1
    if (n ~ /SCRIPTJMPTBLMEMORYALLOCATEMEMORY/) has_alloc_mem = 1
    if (n ~ /SCRIPT3JMPTBLSTRINGCOPYPADNUL/) has_copy_pad = 1
    if (n ~ /PARSEINITAGFILENAMEWEATHERBLOCK/) has_key_filename = 1
    if (n ~ /PARSEINISTRLOADCOLOR/) has_key_loadcolor = 1
    if (n ~ /PARSEINITAGSOURCE/) has_key_source = 1
    if (n ~ /PARSEINISTRHORIZONTAL/) has_key_horizontal = 1
    if (n ~ /PARSEINITAGVERTICAL/) has_key_vertical = 1
    if (n ~ /PARSEINITAGID/) has_key_id = 1
    if (n ~ /PARSEINITAGPPV/) has_tag_ppv = 1
    if (n ~ /PARSEINITAGRIGHT/) has_tag_right = 1
    if (n ~ /PARSEINITAGBOTTOM/) has_tag_bottom = 1
    if (n ~ /PARSEINIPARSEDDESCRIPTORLISTHEAD/) has_desc_head = 1
    if (n ~ /PARSEINICURRENTWEATHERBLOCKPTR/) has_curr_ptr = 1
    if (n ~ /PARSEINICURRENTWEATHERBLOCKTEMPPTR/) has_temp_ptr = 1
    if (u ~ /[^0-9]190[^0-9]/ || u ~ /^190$/) has_off_190 = 1
    if (u ~ /[^0-9]194[^0-9]/ || u ~ /^194$/) has_off_194 = 1
    if (u ~ /[^0-9]222[^0-9]/ || u ~ /^222$/) has_off_222 = 1
    if (u ~ /[^0-9]226[^0-9]/ || u ~ /^226$/) has_off_226 = 1
    if (u ~ /[^0-9]230[^0-9]/ || u ~ /^230$/) has_off_230 = 1
    if (u ~ /[^0-9]670[^0-9]/ || u ~ /^670$/) has_const_670 = 1
    if (u ~ /[^0-9]12[^0-9]/ || u ~ /^12$/) has_const_12 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_COMPARE=" has_compare
    print "HAS_PARSE_LONG=" has_parse_long
    print "HAS_ALLOC_BRUSH=" has_alloc_brush
    print "HAS_ALLOC_MEM=" has_alloc_mem
    print "HAS_COPY_PAD=" has_copy_pad
    print "HAS_KEY_FILENAME=" has_key_filename
    print "HAS_KEY_LOADCOLOR=" has_key_loadcolor
    print "HAS_KEY_SOURCE=" has_key_source
    print "HAS_KEY_HORIZONTAL=" has_key_horizontal
    print "HAS_KEY_VERTICAL=" has_key_vertical
    print "HAS_KEY_ID=" has_key_id
    print "HAS_TAG_PPV=" has_tag_ppv
    print "HAS_TAG_RIGHT=" has_tag_right
    print "HAS_TAG_BOTTOM=" has_tag_bottom
    print "HAS_DESC_HEAD=" has_desc_head
    print "HAS_CURR_PTR=" has_curr_ptr
    print "HAS_TEMP_PTR=" has_temp_ptr
    print "HAS_OFF_190=" has_off_190
    print "HAS_OFF_194=" has_off_194
    print "HAS_OFF_222=" has_off_222
    print "HAS_OFF_226=" has_off_226
    print "HAS_OFF_230=" has_off_230
    print "HAS_CONST_670=" has_const_670
    print "HAS_CONST_12=" has_const_12
    print "HAS_TERMINAL=" has_terminal
}
