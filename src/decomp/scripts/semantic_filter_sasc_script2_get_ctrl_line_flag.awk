BEGIN {
    has_entry = 0
    has_flag = 0
    has_return = 0
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
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^SCRIPT_GETCTRLLINEFLAG:/ || u ~ /^SCRIPT_GETCTRLLINEFLA[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /SCRIPTCTRLLINEASSERTEDFLAG/ || n ~ /SCRIPTCTRLLINEASSERTEDFLA/) has_flag = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FLAG=" has_flag
    print "HAS_RETURN=" has_return
}
