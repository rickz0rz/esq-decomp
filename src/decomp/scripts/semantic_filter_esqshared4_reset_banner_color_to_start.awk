BEGIN {
    has_entry = 0
    has_lea = 0
    has_step = 0
    has_d0 = 0
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

    if (uline ~ /^ESQSHARED4_RESETBANNERCOLORTOSTART:/) has_entry = 1
    if (uline ~ /^LEA ESQ_COPPERLISTBANNERA,A4$/) has_lea = 1
    if (uline ~ /^MOVE\.W #0X62,ESQPARS2_BANNERCOLORSTEPCOUNTER$/ || uline ~ /^MOVE\.W #\$62,ESQPARS2_BANNERCOLORSTEPCOUNTER$/) has_step = 1
    if (uline ~ /^MOVE\.W #0X19,D0$/ || uline ~ /^MOVE\.W #\$19,D0$/) has_d0 = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LEA=" has_lea
    print "HAS_STEP=" has_step
    print "HAS_D0=" has_d0
}
