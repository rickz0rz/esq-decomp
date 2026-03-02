BEGIN {
    has_banner_head = 0
    has_weather_ptr = 0
    has_tag_filename = 0
    has_cmp_nocase = 0
    has_alloc_brush = 0
    has_node_type_10 = 0
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

    if (n ~ /PARSEINIBANNERBRUSHRESOURCEHEAD/) has_banner_head = 1
    if (n ~ /PARSEINIWEATHERBRUSHNODEPTR/) has_weather_ptr = 1
    if (n ~ /PARSEINITAGFILENAMEWEATHERSTRING/) has_tag_filename = 1
    if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASE/) has_cmp_nocase = 1
    if (n ~ /PARSEINIJMPTBLBRUSHALLOCBRUSHNODE/) has_alloc_brush = 1
    if (u ~ /190/ || u ~ /#10/ || u ~ / 10/) has_node_type_10 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_BANNER_HEAD=" has_banner_head
    print "HAS_WEATHER_PTR=" has_weather_ptr
    print "HAS_TAG_FILENAME=" has_tag_filename
    print "HAS_CMP_NOCASE=" has_cmp_nocase
    print "HAS_ALLOC_BRUSH=" has_alloc_brush
    print "HAS_NODE_TYPE_10=" has_node_type_10
    print "HAS_TERMINAL=" has_terminal
}
