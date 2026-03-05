BEGIN {
    has_entry = 0
    has_flag_test = 0
    has_value_select = 0
    has_mask_bits = 0
    has_template_write = 0
    has_banner_write = 0
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

    if (u ~ /^GCOMMAND_APPLYHIGHLIGHTFLAG:/) has_entry = 1
    if (index(u, "GCOMMAND_HIGHLIGHTFLAG") > 0 && (u ~ /^TST\.[WL] / || u ~ /^MOVE\.[WL] /)) has_flag_test = 1
    if (u ~ /^MOVEQ(\.L)? #\$2,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #2,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$0,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #0,D[0-7]$/) has_value_select = 1
    if (u ~ /^MOVEQ(\.L)? #\-3,D[0-7]$/ || u ~ /^AND\.[WL] [0-9]+\((A[0-7])\),D[0-7]$/ || u ~ /^OR\.[WL] D[0-7],D[0-7]$/ || index(u, "GCOMMAND_APPLYHIGHLIGHTWORD") > 0) has_mask_bits = 1
    if (index(u, "ESQ_COPPEREFFECTTEMPLATEROWSSET0") > 0 || index(u, "ESQ_COPPEREFFECTTEMPLATEROWSSET1") > 0) has_template_write = 1
    if (index(u, "ESQ_COPPERLISTBANNERA") > 0 || index(u, "ESQ_COPPERLISTBANNERB") > 0) has_banner_write = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FLAG_TEST=" has_flag_test
    print "HAS_VALUE_SELECT=" has_value_select
    print "HAS_MASK_BITS=" has_mask_bits
    print "HAS_TEMPLATE_WRITE=" has_template_write
    print "HAS_BANNER_WRITE=" has_banner_write
    print "HAS_RETURN=" has_return
}
