BEGIN {
    has_label = 0
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
    uline = toupper(line)

    if (uline ~ /^COI_RENDERCLOCKFORMATENTRYVARIANT:/) has_label = 1
}

END {
    print "HAS_LABEL=" has_label
}
