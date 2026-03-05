BEGIN {
    has_entry = 0
    has_serdat = 0
    has_shadow = 0
    has_mask_ff = 0
    has_set_bit8 = 0
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

    if (u ~ /^SCRIPT_WRITECTRLSHADOWTOSERDAT:/ || u ~ /^SCRIPT_WRITECTRLSHADOWTOSERDA[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /SERDAT/) has_serdat = 1
    if (n ~ /SCRIPTSERIALSHADOWWORD/ || n ~ /SCRIPTSERIALSHADOWWOR/) has_shadow = 1
    if (u ~ /#255/ || u ~ /[^0-9]255[^0-9]/ || u ~ /\$FF/) has_mask_ff = 1
    if (u ~ /#8/ || u ~ /[^0-9]8[^0-9]/ || u ~ /\$100/) has_set_bit8 = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SERDAT=" has_serdat
    print "HAS_SHADOW=" has_shadow
    print "HAS_MASK_FF=" has_mask_ff
    print "HAS_SET_BIT8=" has_set_bit8
    print "HAS_RETURN=" has_return
}
