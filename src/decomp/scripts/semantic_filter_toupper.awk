BEGIN {
    has_cmp_a = 0
    has_cmp_z = 0
    has_low_branch = 0
    has_high_branch = 0

    has_add_neg97 = 0
    has_cmp_25 = 0
    has_jhi = 0

    has_shift_32 = 0
    has_write_d0 = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = $0
    line = trim(line)
    if (line == "") next

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CMPI\.B +#'A',D0$/) has_cmp_a = 1
    if (u ~ /^CMPI\.B +#'Z',D0$/) has_cmp_z = 1
    if (u ~ /^(BLT|BLT\.S|JLT|JLT\.S) /) has_low_branch = 1
    if (u ~ /^(BGT|BGT\.S|JGT|JGT\.S|BHI|BHI\.S|JHI|JHI\.S) /) has_high_branch = 1

    if (u ~ /^ADD\.B +#-97,D0$/) has_add_neg97 = 1
    if (u ~ /^CMP\.B +#25,D0$/) has_cmp_25 = 1
    if (u ~ /^(JHI|JHI\.S|BHI|BHI\.S) /) has_jhi = 1

    if (u ~ /^SUBI\.B +#\$20,D0$/) has_shift_32 = 1
    if (u ~ /^ADD\.B +#-32,D[0-7]$/) has_shift_32 = 1

    if (u ~ /^MOVE(\.B|\.L|Q) .*D0$/) has_write_d0 = 1
    if (u == "RTS") has_rts = 1
}

END {
    has_range_check = 0
    if (has_cmp_a && has_cmp_z && has_low_branch && has_high_branch) has_range_check = 1
    if (has_add_neg97 && has_cmp_25 && has_jhi) has_range_check = 1

    print "HAS_RANGE_CHECK=" has_range_check
    print "HAS_CASE_SHIFT_32=" has_shift_32
    print "HAS_D0_WRITE=" has_write_d0
    print "HAS_RTS=" has_rts
}
