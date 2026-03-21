BEGIN {
    entry = (ENTRY != "" ? ENTRY : "PARSE_ReadSignedLong_NegateValue")
}

{
    u = toupper($0)

    if (u ~ "^" toupper(entry) ":$") {
        print "ENTRY"
        next
    }
    if (u ~ /^NEG\.L D[01]$/) {
        print "NEG"
        next
    }
}
