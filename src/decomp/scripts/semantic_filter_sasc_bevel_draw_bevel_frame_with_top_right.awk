BEGIN {
    has_label = 0
    has_beveled = 0
    has_horiz = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    if (u ~ /^BEVEL_DRAWBEVELFRAMEWITHTOPRIGHT[A-Z0-9_]*:/) has_label = 1
    if (u ~ /BEVEL_DRAWBEVELEDFRAME/) has_beveled = 1
    if (u ~ /BEVEL_DRAWHORIZONTALBEVEL/) has_horiz = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_BEVELED=" has_beveled
    print "HAS_HORIZ=" has_horiz
    print "HAS_RETURN=" has_return
}
