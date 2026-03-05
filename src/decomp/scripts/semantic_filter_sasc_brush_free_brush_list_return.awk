BEGIN {
    has_entry = 0
    has_epilogue_or_rts = 0
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

    if (ENTRY != "" && u == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_REGEX != "" && u ~ toupper(ENTRY_REGEX)) has_entry = 1

    if (u == "RTS" || u ~ /^UNLK A5$/ || u ~ /^MOVEM\.L \(A7\)\+,/) {
        has_epilogue_or_rts = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_EPILOGUE_OR_RTS=" has_epilogue_or_rts
}
