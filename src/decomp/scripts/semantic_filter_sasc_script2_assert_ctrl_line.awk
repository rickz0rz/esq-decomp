BEGIN {
    has_entry = 0
    has_asserted_flag = 0
    has_shadow = 0
    has_set_bit20 = 0
    has_write_call = 0
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

    if (u ~ /^SCRIPT_ASSERTCTRLLINE:/ || u ~ /^SCRIPT_ASSERTCTRLLIN[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /SCRIPTCTRLLINEASSERTEDFLAG/ || n ~ /SCRIPTCTRLLINEASSERTEDFLA/) has_asserted_flag = 1
    if (n ~ /SCRIPTSERIALSHADOWWORD/ || n ~ /SCRIPTSERIALSHADOWWOR/) has_shadow = 1
    if (u ~ /#32/ || u ~ /[^0-9]32[^0-9]/ || u ~ /\$20/ || u ~ /BSET[[:space:]]+#\$?5/) has_set_bit20 = 1
    if (n ~ /SCRIPTWRITECTRLSHADOWTOSERDAT/ || n ~ /SCRIPTWRITECTRLSHADOWTOSERDA/) has_write_call = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ASSERTED_FLAG=" has_asserted_flag
    print "HAS_SHADOW=" has_shadow
    print "HAS_SET_BIT20=" has_set_bit20
    print "HAS_WRITE_CALL=" has_write_call
    print "HAS_RETURN=" has_return
}
