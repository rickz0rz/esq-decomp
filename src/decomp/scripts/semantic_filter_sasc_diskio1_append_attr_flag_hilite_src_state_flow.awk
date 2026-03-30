BEGIN {
    fmt_call_count = 0
    has_entry_hilite = 0
    has_btst_1 = 0
    has_str_hilite = 0
    has_continue_summary = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

function mark_btst(bit, next_label) {
    if (index(uline, "BTST #" bit ",") == 1 || index(uline, "BTST #$" bit ",") == 1) {
        if (bit == "1") {
            has_btst_1 = 1
        }
        pending_branch = next_label
    }
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    uline = line

    if (uline ~ /^DISKIO1_APPENDATTRFLAGHILITESRC[A-Z0-9_]*:/) has_entry_hilite = 1

    mark_btst("1", "DISKIO1_APPENDATTRFLAGSUMMARYSRC")

    if (pending_branch != "" && uline ~ /^BEQ\./ && index(uline, pending_branch) > 0) {
        if (pending_branch ~ /SUMMARYSRC/) has_continue_summary = 1
        pending_branch = ""
    }

    if (uline ~ /DISKIO_STR_HILITE_SRC_COMPACTSOURCEATTRFLAGS/ || uline ~ /DISKIO_STR_HILITE_SRC_COMPACTSOU/) has_str_hilite = 1

    if (uline ~ /FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ ||
        uline ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ ||
        uline ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRAT/ ||
        uline ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTW/) {
        fmt_call_count++
    }

    if (uline ~ /DISKIO1_APPENDATTRFLAGSUMMARYSRC/ && uline ~ /^(BRA|BSR|JSR|JMP)/) {
        has_continue_summary = 1
    }
}

END {
    print "FMT_CALL_COUNT=" fmt_call_count
    print "HAS_ENTRY_HILITE=" has_entry_hilite
    print "HAS_BTST_1=" has_btst_1
    print "HAS_STR_HILITE=" has_str_hilite
    print "HAS_CONTINUE_SUMMARY=" has_continue_summary
}
