BEGIN {
    has_entry = 0
    has_inc = 0
    has_transfer = 0
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

    if (uline ~ /^DISKIO1_ADVANCETIMESLOTBITINDEX:/) has_entry = 1
    if (uline ~ /^ADDQ\.B #1,D4$/) has_inc = 1
    if (uline ~ /^BRA\.[SW] DISKIO1_APPENDTIMESLOTMASKSELECTEDTIMES$/ || uline ~ /^JMP DISKIO1_APPENDTIMESLOTMASKSELECTEDTIMES$/) has_transfer = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INC=" has_inc
    print "HAS_TRANSFER=" has_transfer
}
