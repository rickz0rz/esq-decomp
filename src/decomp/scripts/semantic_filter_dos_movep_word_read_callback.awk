BEGIN {
    has_movep = 0
    has_pad_word = 0
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

    if (u ~ /^MOVEP\.W 0\(A2\),D6$/) has_movep = 1
    if (u ~ /^DC\.W \$0+$/ || u ~ /^\.WORD 0X?0+$/ || u ~ /^\.WORD 0+$/) has_pad_word = 1
}

END {
    print "HAS_MOVEP=" has_movep
    print "HAS_PAD_WORD=" has_pad_word
}
