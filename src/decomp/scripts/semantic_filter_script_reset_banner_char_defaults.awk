BEGIN {
    has_selected = 0
    has_fallback = 0
    has_matchidx = 0
    has_neg1 = 0
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

    if (n ~ /TEXTDISPBANNERCHARSELECTED/) has_selected = 1
    if (n ~ /TEXTDISPBANNERCHARFALLBACK/) has_fallback = 1
    if (n ~ /TEXTDISPCURRENTMATCHINDEX/) has_matchidx = 1
    if (u ~ /-1/) has_neg1 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_SELECTED=" has_selected
    print "HAS_FALLBACK=" has_fallback
    print "HAS_MATCHIDX=" has_matchidx
    print "HAS_NEG1=" has_neg1
    print "HAS_TERMINAL=" has_terminal
}
