BEGIN {
    has_via_label = 0
    has_via_symbol = 0
    has_supervisor_call = 0
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

    if (uline ~ /^ESQ_COLDREBOOTVIASUPERVISOR:/ || uline ~ /^ESQ_COLDREBOOTVIASUPER[A-Z0-9_]*:/) has_via_label = 1
    if (uline ~ /ESQ_SUPERVISORCOLDREBOOT/) has_via_symbol = 1
    if (uline ~ /LVOSUPERVISOR/ || uline ~ /_LVOSUPERVISOR/) has_supervisor_call = 1
}

END {
    print "HAS_VIA_LABEL=" has_via_label
    print "HAS_VIA_SYMBOL=" has_via_symbol
    print "HAS_SUPERVISOR_CALL=" has_supervisor_call
}
