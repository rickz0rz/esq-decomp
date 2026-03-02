BEGIN {
    has_replace = 0
    has_120 = 0
    has_one = 0
    has_226 = 0
    has_26 = 0
    has_428 = 0
    has_1b0 = 0
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

    if (n ~ /ESQPROTOJMPTBLESQPARSREPLACEOWNEDSTRING/) has_replace = 1
    if (u ~ /#120/ || u ~ /[^0-9]120[^0-9]/) has_120 = 1
    if (u ~ /#1/ || u ~ /[^0-9]1[^0-9]/) has_one = 1
    if (u ~ /226\(A[0-7]\)/ || u ~ /\(226,A[0-7]\)/) has_226 = 1
    if (u ~ /26\(A[0-7]\)/ || u ~ /\(26,A[0-7]\)/) has_26 = 1
    if (u ~ /#428/ || u ~ /[^0-9]428[^0-9]/) has_428 = 1
    if (u ~ /1B0/ || u ~ /432/) has_1b0 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_REPLACE=" has_replace
    print "HAS_120=" has_120
    print "HAS_ONE=" has_one
    print "HAS_226=" has_226
    print "HAS_26=" has_26
    print "HAS_428=" has_428
    print "HAS_1B0=" has_1b0
    print "HAS_TERMINAL=" has_terminal
}
