BEGIN {
    has_tag_current = 0
    has_tag_forecast = 0
    has_tag_bottom = 0
    has_ptr_current = 0
    has_ptr_forecast = 0
    has_ptr_bottom = 0
    has_cmp_nocase = 0
    has_replace_owned = 0
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

    if (n ~ /PARSEINISTRWEATHERCURRENT/) has_tag_current = 1
    if (n ~ /PARSEINISTRWEATHERFORECAST/) has_tag_forecast = 1
    if (n ~ /PARSEINISTRBOTTOMLINETAG/) has_tag_bottom = 1
    if (n ~ /PTYPEWEATHERCURRENTMSGPTR/) has_ptr_current = 1
    if (n ~ /PTYPEWEATHERFORECASTMSGPTR/) has_ptr_forecast = 1
    if (n ~ /PTYPEWEATHERBOTTOMLINEMSGPTR/) has_ptr_bottom = 1
    if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASE/) has_cmp_nocase = 1
    if (n ~ /PARSEINIJMPTBLESQPARSREPLACEOWNEDSTRING/) has_replace_owned = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_TAG_CURRENT=" has_tag_current
    print "HAS_TAG_FORECAST=" has_tag_forecast
    print "HAS_TAG_BOTTOM=" has_tag_bottom
    print "HAS_PTR_CURRENT=" has_ptr_current
    print "HAS_PTR_FORECAST=" has_ptr_forecast
    print "HAS_PTR_BOTTOM=" has_ptr_bottom
    print "HAS_CMP_NOCASE=" has_cmp_nocase
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_TERMINAL=" has_terminal
}
