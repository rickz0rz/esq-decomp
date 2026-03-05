BEGIN {
    has_entry = 0
    has_ciab = 0
    has_bit3 = 0
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

    if (u ~ /^SCRIPT_READHANDSHAKEBIT3FLAG:/ || u ~ /^SCRIPT_READHANDSHAKEBIT3FLA[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /CIABPRA/) has_ciab = 1
    if (u ~ /#3/ || u ~ /[^0-9]3[^0-9]/) has_bit3 = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CIAB=" has_ciab
    print "HAS_BIT3=" has_bit3
    print "HAS_RETURN=" has_return
}
