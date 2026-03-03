BEGIN {
    has_rts = 0
    op_count = 0
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

    if (u ~ /^[A-Z][A-Z0-9_]*:$/) next
    if (u ~ /^\./) next
    if (u ~ /^#/) next

    if (u == "RTS") {
        has_rts = 1
        op_count++
        next
    }

    if (u ~ /^(MOVE|MOVEM|LEA|PEA|JSR|BSR|BRA|B[A-Z]+|ADD|SUB|CLR|TST|CMP|AND|OR|EOR|NOT|NEG|MUL|DIV|SWAP|EXT|DBF|JMP|LINK|UNLK)/) {
        op_count++
    }
}

END {
    print "HAS_RTS=" has_rts
    print "OP_COUNT=" op_count
}
