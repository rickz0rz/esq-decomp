BEGIN {
    has_entry = 0
    has_add_byte = 0
    has_ptr_store = 0
    has_rts = 0
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

    if (uline ~ /^GCOMMAND_ADDBANNERTABLEBYTEDELTA:/) has_entry = 1
    if ((uline ~ /^ADD\.B / && uline ~ /\(A[0-7]\)$/) || uline ~ /^ADD\.L D[0-7],D[0-7]$/ || uline ~ /^ADD\.W D[0-7],D[0-7]$/) has_add_byte = 1
    if (uline ~ /^MOVE\.B / && uline ~ /,D[0-7]$/) has_ptr_store = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ADD_BYTE=" has_add_byte
    print "HAS_PTR_BYTE_LOAD=" has_ptr_store
    print "HAS_RTS=" has_rts
}
