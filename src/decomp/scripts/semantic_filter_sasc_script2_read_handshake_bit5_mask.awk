BEGIN {
    has_entry = 0
    has_ciab = 0
    has_mask = 0
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
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^SCRIPT_READHANDSHAKEBIT5MASK:/ || u ~ /^SCRIPT_READHANDSHAKEBIT5MAS[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /CIABPRA/) has_ciab = 1
    if (u ~ /#32/ || u ~ /[^0-9]32[^0-9]/ || u ~ /\$20/) has_mask = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CIAB=" has_ciab
    print "HAS_MASK=" has_mask
    print "HAS_RETURN=" has_return
}
