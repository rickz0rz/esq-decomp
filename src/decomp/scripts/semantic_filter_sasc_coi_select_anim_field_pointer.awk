BEGIN {
    has_entry = 0
    has_passthrough = 0
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
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^COI_SELECTANIMFIELDPOINTER:/) {
        has_entry = 1
    }

    if (u ~ /^COI_GETANIMFIELDPOINTERBYMODE:/) {
        has_passthrough = 1
    }

    if (u ~ /^(BSR|JSR|BRA|JMP)(\.[A-Z]+)? .*COI_GETANIMFIELDPOINTERBYMODE/) {
        has_passthrough = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PASSTHROUGH=" has_passthrough
}
