BEGIN {
    has_label = 0
    has_call = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^GROUP_AB_JMPTBL_UNKNOWN2A_STUB0[A-Z0-9_]*:/) has_label = 1
    if (u ~ /UNKNOWN2A_STUB0/) has_call = 1
    if (u == "RTS" || u ~ /^JMP /) has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_CALL=" has_call
    print "HAS_RETURN=" has_return
}
