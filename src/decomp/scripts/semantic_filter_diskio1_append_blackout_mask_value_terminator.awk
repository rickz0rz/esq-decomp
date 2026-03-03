BEGIN {
    has_entry = 0
    has_pea = 0
    has_jsr = 0
    has_addq = 0
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

    if (uline ~ /^DISKIO1_APPENDBLACKOUTMASKVALUETERMINATOR:/) has_entry = 1
    if (uline ~ /^PEA DISKIO_STR_BLACKOUTLISTCLOSEPARENNEWLINE$/) has_pea = 1
    if (uline ~ /^JSR GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRATCHBUFFER(\(PC\))?$/) has_jsr = 1
    if (uline ~ /^ADDQ\.W #4,A7$/) has_addq = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PEA=" has_pea
    print "HAS_JSR=" has_jsr
    print "HAS_ADDQ=" has_addq
}
