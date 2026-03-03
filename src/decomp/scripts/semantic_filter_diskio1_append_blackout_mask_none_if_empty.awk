BEGIN {
    has_entry = 0
    has_tst = 0
    has_pea = 0
    has_jsr = 0
    has_addq = 0
    has_branch = 0
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

    if (uline ~ /^DISKIO1_APPENDBLACKOUTMASKNONEIFEMPTY:/) has_entry = 1
    if (uline ~ /^TST\.L D5$/) has_tst = 1
    if (uline ~ /^PEA DISKIO_STR_NONE_BLACKOUTMASKEMPTY$/) has_pea = 1
    if (uline ~ /^JSR GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRATCHBUFFER(\(PC\))?$/) has_jsr = 1
    if (uline ~ /^ADDQ\.W #4,A7$/) has_addq = 1
    if (uline ~ /^BNE\.[SW] DISKIO1_APPENDBLACKOUTMASKALLIFALLBITSSET$/ || uline ~ /^JMP DISKIO1_APPENDBLACKOUTMASKALLIFALLBITSSET$/) has_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TST=" has_tst
    print "HAS_PEA=" has_pea
    print "HAS_JSR=" has_jsr
    print "HAS_ADDQ=" has_addq
    print "HAS_BRANCH=" has_branch
}
