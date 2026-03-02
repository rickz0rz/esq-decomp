BEGIN {
    has_selected = 0
    has_fallback = 0
    has_100 = 0
    has_branch = 0
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
    if (u ~ /[^0-9]100[^0-9]/ || u ~ /^100$/) has_100 = 1
    if (u ~ /^BEQ|^BNE|^BRA|^J/ || u ~ /IF|ELSE/) has_branch = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_SELECTED=" has_selected
    print "HAS_FALLBACK=" has_fallback
    print "HAS_100=" has_100
    print "HAS_BRANCH=" has_branch
    print "HAS_TERMINAL=" has_terminal
}
