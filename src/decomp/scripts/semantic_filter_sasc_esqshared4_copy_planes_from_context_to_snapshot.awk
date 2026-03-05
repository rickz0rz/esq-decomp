BEGIN {
    has_entry = 0
    has_2b = 0
    has_copy_postinc = 0
    has_dst_base = 0
    has_writeback = 0
    has_rts = 0
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

    if (uline ~ /^ESQSHARED4_COPYPLANESFROMCONTEXTTOSNAPSHOT:/ || uline ~ /^ESQSHARED4_COPYPLANESFROMCONTEXT[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /#(\$)?2B/ || uline ~ /#43/) has_2b = 1
    if (uline ~ /MOVE\.L \(A[0-7]\)\+,\(A[0-7]\)\+/ || uline ~ /MOVE\.L .*\(A[0-7]\)\+.*\(A[0-7]\)\+/) has_copy_postinc = 1
    if (index(uline, "ESQPARS2_BANNERSNAPSHOTPLANE0DSTPTR") > 0 || index(uline, "ESQPARS2_BANNERSNAPSHOTPLANE1DSTPTR") > 0 || index(uline, "ESQPARS2_BANNERSNAPSHOTPLANE2DSTPTR") > 0 || index(uline, "ESQPARS2_BANNERSNAPSHOTPLANE0DST") > 0 || index(uline, "ESQPARS2_BANNERSNAPSHOTPLANE1DST") > 0 || index(uline, "ESQPARS2_BANNERSNAPSHOTPLANE2DST") > 0 || index(uline, "ESQPARS2_BANNERSNAPSHOTPLANE0") > 0 || index(uline, "ESQPARS2_BANNERSNAPSHOTPLANE1") > 0 || index(uline, "ESQPARS2_BANNERSNAPSHOTPLANE2") > 0) has_dst_base = 1
    if (uline ~ /^MOVE\.L A[0-7],\(A[0-7]\)\+/ || uline ~ /^MOVE\.L A[0-7],\(A[0-7]\)/) has_writeback = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_2B_CONST=" has_2b
    print "HAS_COPY_POSTINC=" has_copy_postinc
    print "HAS_DST_BASE=" has_dst_base
    print "HAS_WRITEBACK=" has_writeback
    print "HAS_RTS=" has_rts
}
