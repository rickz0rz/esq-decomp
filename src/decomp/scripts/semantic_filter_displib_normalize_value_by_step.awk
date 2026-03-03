BEGIN {
    has_entry = 0
    has_low_loop = 0
    has_high_loop = 0
    has_add_step = 0
    has_sub_step = 0
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
    uline = toupper(line)

    if (uline ~ /^DISPLIB_NORMALIZEVALUEBYSTEP:/) has_entry = 1
    if (uline ~ /^\.LAB_0560:/ || uline ~ /BRA\.S \.LAB_0560/) has_low_loop = 1
    if (uline ~ /^\.LAB_0561:/ || uline ~ /BRA\.S \.LAB_0561/) has_high_loop = 1
    if (uline ~ /ADD\.W D5,D7/) has_add_step = 1
    if (uline ~ /SUB\.W D5,D7/) has_sub_step = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOW_LOOP=" has_low_loop
    print "HAS_HIGH_LOOP=" has_high_loop
    print "HAS_ADD_STEP=" has_add_step
    print "HAS_SUB_STEP=" has_sub_step
    print "HAS_RETURN=" has_return
}
