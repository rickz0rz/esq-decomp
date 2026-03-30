BEGIN {
    has_entry = 0
    has_full_mask_compare = 0
    has_off_air_transfer = 0
    has_none_literal = 0
    has_fmt_call = 0
    has_blackout_tail = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    if (index(line, "DISKIO1_APPENDTIMESLOTMASKNONEIFALLBITSSET:") == 1 ||
        index(line, "DISKIO1_APPENDTIMESLOTMASKNONEIF") == 1) {
        has_entry = 1
    }

    if ((line ~ /^CMPI\.[BWL] #\$?5FA,/ || line ~ /^CMPI\.[BWL] #\$?5FA,D5$/) ||
        line ~ /DISKIO1_MASK_SUM_ALL_BITS_SET/) {
        has_full_mask_compare = 1
    }

    if ((line ~ /^(B[A-Z]+|JMP|JSR)(\.[A-Z]+)? / ||
         line ~ /^(BRA|BSR)\.[A-Z]+ /) &&
        index(line, "DISKIO1_APPENDTIMESLOTMASKOFFAIR") > 0) {
        has_off_air_transfer = 1
    }

    if (line ~ /DISKIO_STR_NONE_TIMESLOTMASKALLS/) {
        has_none_literal = 1
    }

    if (line ~ /FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ ||
        line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ ||
        line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTW/) {
        has_fmt_call = 1
    }

    if ((line ~ /^(B[A-Z]+|JMP|JSR)(\.[A-Z]+)? / ||
         line ~ /^(BRA|BSR)\.[A-Z]+ /) &&
        index(line, "DISKIO1_FORMATBLACKOUTMASKFLAGS") > 0) {
        has_blackout_tail = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FULL_MASK_COMPARE=" has_full_mask_compare
    print "HAS_OFF_AIR_TRANSFER=" has_off_air_transfer
    print "HAS_NONE_LITERAL=" has_none_literal
    print "HAS_FMT_CALL=" has_fmt_call
    print "HAS_BLACKOUT_TAIL=" has_blackout_tail
}
