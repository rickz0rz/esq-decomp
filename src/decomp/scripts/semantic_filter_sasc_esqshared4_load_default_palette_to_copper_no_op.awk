BEGIN {
    has_entry = 0
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

    if (uline ~ /^ESQSHARED4_LOADDEFAULTPALETTETOCOPPER_NOOP:/ || uline ~ /^ESQSHARED4_LOADDEFAULTPALETTETOCOP[A-Z0-9_]*:/ || uline ~ /^ESQSHARED4_LOADDEFAULTPALETTETOC[A-Z0-9_]*:/) has_entry = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
}
